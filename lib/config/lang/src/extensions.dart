

import 'package:flutter/widgets.dart';
import 'package:myapp/config/lang/src/translations.dart';

import '../app_localization.dart';
import 'localization.dart';

String translate(String key, {BuildContext? context, List<String>? args, Map<String, String>? namedArgs, String? gender}) {
  return context != null
      ? Localization.of(context)!.tr(key, args: args, namedArgs: namedArgs, gender: gender)
      : Localization.instance.tr(key, args: args, namedArgs: namedArgs, gender: gender);
}

bool translateExists(String key, {BuildContext? context}) {
  return context != null ? Localization.of(context)!.exists(key) : Localization.instance.exists(key);
}

class LocaleNotFoundException implements Exception {
  const LocaleNotFoundException();

  @override
  String toString() => 'Locale not found !';
}

extension LocaleExtension on Locale {
  bool supports(Locale locale) {
    if (this == locale) {
      return true;
    }
    if (languageCode != locale.languageCode) {
      return false;
    }
    if (countryCode != null && countryCode!.isNotEmpty && countryCode != locale.countryCode) {
      return false;
    }
    if (scriptCode != null && scriptCode != locale.scriptCode) {
      return false;
    }

    return true;
  }
}

extension LocaleToStringHelperExt on Locale {
  String toStringWithSeparator({String separator = '_'}) {
    return toString().split('_').join(separator);
  }
}

extension StringToLocaleHelperExt on String {
  Locale toLocale({String separator = '_'}) {
    final localeList = split(separator);
    switch (localeList.length) {
      case 2:
        return localeList.last.length == 4
            ? Locale.fromSubtags(
                languageCode: localeList.first,
                scriptCode: localeList.last,
              )
            : Locale(localeList.first, localeList.last);
      case 3:
        return Locale.fromSubtags(
          languageCode: localeList.first,
          scriptCode: localeList[1],
          countryCode: localeList.last,
        );
      default:
        return Locale(localeList.first);
    }
  }
}

extension StringTranslateExtension on String {
  String tr({List<String>? args, Map<String, String>? namedArgs, String? gender, BuildContext? context}) {
    return translate(this, context: context, args: args, namedArgs: namedArgs, gender: gender);
  }

  bool trExists({BuildContext? context}) => translateExists(this, context: context);
}

extension LocaleText on List<String> {
  String tr() => this.map((String e) => e.tr()).toList().join(", ");
}

extension BuildContextEasyLocalizationExtension on BuildContext {
  Locale get locale => AppLocalization.of(this)!.locale;
  Locale get deviceLocale => AppLocalization.of(this)!.deviceLocale;
  Locale? get savedLocale => AppLocalization.of(this)!.savedLocale;
  Locale? get fallbackLocale => AppLocalization.of(this)!.fallbackLocale;
  List<Locale> get supportedLocales => AppLocalization.of(this)!.supportedLocales;
  List<LocalizationsDelegate> get localizationDelegates => AppLocalization.of(this)!.delegates;

  Future<void> setTranslations(Translations? val) async => AppLocalization.of(this)!.setTranslations(val);
  Future<void> setSupportedLocales(List<Locale> val) async => AppLocalization.of(this)!.setSupportedLocales(val);
  Future<void> setLocale(Locale val) async => AppLocalization.of(this)!.setLocale(val);
  Future<void> deleteSavedLocale() => AppLocalization.of(this)!.deleteSavedLocale();
  Future<void> resetLocale() => AppLocalization.of(this)!.resetLocale();

  String tr(String key, {List<String>? args, Map<String, String>? namedArgs, String? gender}) {
    final localization = Localization.of(this);

    if (localization == null) {
      throw const LocaleNotFoundException();
    }

    return localization.tr(
      key,
      args: args,
      namedArgs: namedArgs,
      gender: gender,
    );
  }

  bool trExists(String key) {
    final localization = Localization.of(this);
    if (localization == null) {
      throw const LocaleNotFoundException();
    }
    return localization.exists(key);
  }
}
