 

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl_standalone.dart';
import 'package:myapp/core/helper/global_prefs.dart';
import 'package:myapp/core/utils/common_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastification/toastification.dart';

import '../app_localization.dart';
import 'translations.dart';

class LocalizationController extends ChangeNotifier {
  Locale? get savedLocale => _savedLocale;
  static Locale? _savedLocale;

  Locale get deviceLocale => _deviceLocale;
  static late Locale _deviceLocale;

  Locale get locale => _locale;
  late Locale _locale;

  Locale? _fallbackLocale;

  List<Locale> get supportedLocales => _supportedLocales ?? [];
  List<Locale>? _supportedLocales;

  final String path;
  final bool useFallbackTranslations;
  bool _useApiTranslations = false;
  final bool saveLocale;
  Translations? _translations, _fallbackTranslations;

  Translations? get translations => _translations;

  Translations? get fallbackTranslations => _fallbackTranslations;

  void setTranslations(Translations? t) {
    _translations = t;
    _useApiTranslations = t != null;
    AppLocalization.logger.debug("Translations set explictly");
    notifyListeners();
  }

  void setSupportedLocales(List<Locale>? t) {
    _supportedLocales = t;
    AppLocalization.logger.debug("SupportedLocales set explictly");
    notifyListeners();
  }

  LocalizationController({
    required List<Locale> supportedLocales,
    required this.useFallbackTranslations,
    required this.saveLocale,
    required this.path,
    Locale? startLocale,
    Locale? fallbackLocale,
    Locale? forceLocale,
  }) {
    _fallbackLocale = fallbackLocale;
    _supportedLocales = supportedLocales;
    if (forceLocale != null) {
      _locale = forceLocale;
    } else if (_savedLocale == null && startLocale != null) {
      _locale = _getFallbackLocale(supportedLocales, startLocale);
      AppLocalization.logger('Start locale loaded ${_locale.toString()}');
    } else if (saveLocale && _savedLocale != null) {
      AppLocalization.logger('Saved locale loaded ${_savedLocale.toString()}');
      _locale = selectLocaleFrom(
        supportedLocales,
        _savedLocale!,
        fallbackLocale: fallbackLocale,
      );
    } else {
      _locale = selectLocaleFrom(
        supportedLocales,
        _deviceLocale,
        fallbackLocale: fallbackLocale,
      );
    }
  }

  static Future<void> init() async {
    final preferences = await SharedPreferences.getInstance();
    final strLocale = preferences.getString('app_locale');
    _savedLocale = strLocale?.toLocale();
    final foundPlatformLocale = await findSystemLocale();
    _deviceLocale = foundPlatformLocale.toLocale();
    AppLocalization.logger.debug('Localization initialized');
  }

  static Locale selectLocaleFrom(List<Locale> supportedLocales, Locale deviceLocale, {Locale? fallbackLocale}) {
    final selectedLocale = supportedLocales.firstWhere(
      (locale) => locale.supports(deviceLocale),
      orElse: () => _getFallbackLocale(
        supportedLocales,
        fallbackLocale,
        deviceLocale: deviceLocale,
      ),
    );
    return selectedLocale;
  }

  static Locale _getFallbackLocale(List<Locale> supportedLocales, Locale? fallbackLocale, {final Locale? deviceLocale}) {
    if (deviceLocale != null) {
      final deviceLanguage = deviceLocale.languageCode;
      for (Locale locale in supportedLocales) {
        if (locale.languageCode == deviceLanguage) {
          return locale;
        }
      }
    }
    if (fallbackLocale != null) {
      return fallbackLocale;
    } else {
      return supportedLocales.first;
    }
  }

  Future<bool> loadTranslations() async {
    Map<String, dynamic> data;
    try {
      final storedLang = GlobalPrefs.getLanguage;
      if (_useApiTranslations && storedLang != null) {
        _translations = storedLang.translations;
        AppLocalization.logger("API Translations used");
      } else {
        data = Map.from(await loadTranslationData(_locale));
        _translations = Translations(data);
        if (useFallbackTranslations && _fallbackLocale != null) {
          Map<String, dynamic>? baseLangData;
          if (_locale.countryCode != null && _locale.countryCode!.isNotEmpty) {
            baseLangData = await loadBaseLangTranslationData(Locale(locale.languageCode));
          }
          data = Map.from(await loadTranslationData(_fallbackLocale!));
          if (baseLangData != null) {
            try {
              data.addAll(baseLangData);
            } on UnsupportedError {
              data = Map.of(data)..addAll(baseLangData);
            }
          }
          _fallbackTranslations = Translations(data);
        }
      }
      notifyListeners();
      return true;
    } on FlutterError catch (e) {
      showSnackbar(e.message, type: ToastificationType.error);
      return false;
    } catch (e) {
      showSnackbar(e.toString(), type: ToastificationType.error);
      return false;
    }
  }

  Future<Map<String, dynamic>?> loadBaseLangTranslationData(Locale locale) async {
    try {
      return await loadTranslationData(Locale(locale.languageCode));
    } on FlutterError catch (e) {
      AppLocalization.logger.warning(e.message);
    }
    return null;
  }

  Future<Map<String, dynamic>> loadTranslationData(Locale locale) async => _loadAssets(
        path: path,
        locale: locale,
      );

  Future<Map<String, dynamic>> _loadAssets({required String path, required Locale locale}) async {
    Map<String, dynamic>? result;
    final localePath = '$path/${locale.toStringWithSeparator(separator: "-")}.json';
    AppLocalization.logger.debug('Load asset from $path');
    try {
      result = json.decode(await rootBundle.loadString(localePath));
    } catch(e){
      throw FlutterError("Language is not available.!");
    }
    return result ?? {};
  }

  /// SET AND SAVE AND DELETE LOCALE
  ///

  Future<void> setLocale(Locale l) async {
    final prevLocale = _locale;
    _locale = l;
    final success = await loadTranslations();
    if (!success) {
      _locale = prevLocale;
      notifyListeners();
      return;
    }
    notifyListeners();
    AppLocalization.logger('Locale $locale changed');
    await _saveLocale(_locale);
  }

  Future<void> _saveLocale(Locale? locale) async {
    if (!saveLocale) return;
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString('app_locale', locale.toString());
    AppLocalization.logger('Locale $locale saved');
  }

  Future<void> deleteSavedLocale() async {
    _savedLocale = null;
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove('locale');
    AppLocalization.logger('Saved locale deleted');
  }

  Future<void> resetLocale() async {
    final locale = selectLocaleFrom(_supportedLocales!, deviceLocale, fallbackLocale: _fallbackLocale);
    AppLocalization.logger('Reset locale to $locale while the platform locale is $_deviceLocale and the fallback locale is $_fallbackLocale');
    await setLocale(locale);
  }
}
