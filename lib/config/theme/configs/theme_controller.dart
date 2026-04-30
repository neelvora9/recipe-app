 

import 'package:flutter/material.dart';
import 'package:myapp/config/theme/app_theme.dart';
import 'package:myapp/config/theme/configs/theme_colors.dart';
import 'package:myapp/core/helper/global_prefs.dart';
import 'package:myapp/core/utils/devlog.dart';

class ThemeController extends ChangeNotifier {
  ThemeController._internal();

  factory ThemeController() => _instance;
  static final ThemeController _instance = ThemeController._internal();

  ThemeMode get getSystemThemeMode => _deviceThemeMode;
  static late ThemeMode _deviceThemeMode;

  ThemeMode get themeMode => _themeMode;
  static ThemeMode _themeMode = ThemeMode.system;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  ThemeData get currentTheme {
    if (isDarkMode)
      return ThemeData.dark().copyWith(primaryColor: themeColors.darkPrimary);
    else
      return ThemeData.light().copyWith(primaryColor: themeColors.lightPrimary);
  }

  static Future<void> init() async {
    final storedTheme = GlobalPrefs.getThemeMode;
    _deviceThemeMode = WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light;

    if (storedTheme != null) {
      _themeMode = ThemeMode.values.firstWhere(
        (e) => e.name == storedTheme,
        orElse: () => ThemeMode.system,
      );
      AppTheme.logger("Loaded saved theme mode: $_themeMode");
    } else {
      _themeMode = ThemeMode.system;
      devlog("No saved theme, using system: $_themeMode");
    }

    /// THEME COLORS
    final storedThemeColorsIndex = GlobalPrefs.getThemeColorsIndex;
    if (storedThemeColorsIndex != null) {
      themeColors = themeColorsOptions[storedThemeColorsIndex];
      AppTheme.logger("Loaded saved theme colors index: $storedThemeColorsIndex");
    } else {
      AppTheme.logger("No saved theme colors index, using default initial theme colors");
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    AppTheme.logger("Theme mode set to: $_themeMode");
    notifyListeners();
    GlobalPrefs.setThemeMode = _themeMode.name;
    AppTheme.logger("Theme mode saved: ${mode.name}");
  }

  Future<void> toggleThemeMode() async {
    if (_themeMode == ThemeMode.dark) {
      await setThemeMode(ThemeMode.light);
    } else {
      await setThemeMode(ThemeMode.dark);
    }
  }

  Future<void> resetThemeMode() async {
    _themeMode = ThemeMode.system;
    notifyListeners();
    AppTheme.logger("Theme mode reset to system: $_themeMode");
    GlobalPrefs.setThemeMode = _themeMode.name;
    AppTheme.logger("Theme mode saved: ${_themeMode.name}");
  }

  Future<void> deleteSavedThemeMode() async {
    GlobalPrefs.setThemeMode = null;
    AppTheme.logger("Saved theme mode deleted");
  }

  /// THEME COLORS
  /// use [apiThemeColors] if you fetch colors from api;
  Future<void> setThemeColorsIndex(int? index) async {
    GlobalPrefs.setThemeColorsIndex = index;
    if (index == null) {
      themeColors = ThemeColorsModel();
      AppTheme.logger("Theme Colors index removed");
    } else {
      themeColors = themeColorsOptions[index];
      AppTheme.logger("Theme Colors index saved: ${index}");
    }
    notifyListeners();
  }
}
