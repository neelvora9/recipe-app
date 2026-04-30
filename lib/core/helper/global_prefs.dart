 

import 'dart:convert';

import 'package:myapp/config/lang/src/lang_from_api/dummy_lang_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../config/lang/src/lang_from_api/translation_api_model.dart';
import '../constants/app_constants.dart';

enum PrefKey {
  token,
  appThemeMode,
  appThemeColorsIndex,
  language,
  langList,
  ;
}

class GlobalPrefs {
  GlobalPrefs._();

  static SharedPreferences? _sp;

  static Future<void> init() async {
    _sp = await SharedPreferences.getInstance();
  }

  /// GLOBAL VALUES
  ///

  /// TOKEN
  static set setToken(String val) => _sp?.setString(PrefKey.token.name, val);

  static String get getToken => _sp?.getString(PrefKey.token.name) ?? "";

  /// THEME
  static set setThemeMode(String? val) => val == null ? _sp?.remove(PrefKey.appThemeMode.name) : _sp?.setString(PrefKey.appThemeMode.name, val);

  static String? get getThemeMode => _sp?.getString(PrefKey.appThemeMode.name);

  /// THEME_DATA
  static set setThemeColorsIndex(int? val) => val == null ? _sp?.remove(PrefKey.appThemeColorsIndex.name) : _sp?.setInt(PrefKey.appThemeColorsIndex.name, val);

  static int? get getThemeColorsIndex => _sp?.getInt(PrefKey.appThemeColorsIndex.name);

  /// THEME_DATA
  // static set setLangList(List<String>? val) => val == null ? _sp?.remove(PrefKey.langList.name) : _sp?.setStringList(PrefKey.langList.name, val);
  // static List<String>? get getLangList => _sp?.getStringList(PrefKey.langList.name);

  /// LANGUAGE
  static set setLanguage(TranslationApiModel? val) => val == null ? _sp?.remove(PrefKey.language.name) : _sp?.setString(PrefKey.language.name, jsonEncode(val.toJson()));

  static TranslationApiModel? get getLanguage =>
      (_sp?.getString(PrefKey.language.name) ?? "").isEmpty ? null : TranslationApiModel.fromJson(jsonDecode(_sp?.getString(PrefKey.language.name) ?? "{}"));

  static remove(PrefKey key) => _sp?.remove(key.name);

// setString
  static setString(PrefKey key, String val) => _sp?.setString(key.name, val);

  static String getString(PrefKey key) => _sp?.getString(key.name) ?? "";

  // setBool
  static setBool(PrefKey key, bool val) => _sp?.setBool(key.name, val);

  static bool getBool(PrefKey key) => _sp?.getBool(key.name) ?? false;

  ///
  ///

  static bool get isTokenAvailable {
    final String token = getToken;
    return token.isNotEmpty && token.trim() != "";
  }

  static bool logout() {
    try {
      _sp!.remove(PrefKey.token.name);
      return true;
    } catch (e) {
      return false;
    }
  }
}
