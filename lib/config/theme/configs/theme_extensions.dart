 

import 'package:flutter/material.dart';
import 'package:myapp/config/theme/app_colors.dart';
import 'package:myapp/config/theme/app_theme.dart';

import 'theme_controller.dart';

extension ColorPrefs on ColorScheme {
  AppColors get themeColors => AppColors.fromBrightness(brightness);
}

extension CustomContext on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  AppColors get colors => Theme.of(this).colorScheme.themeColors;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;
}

extension ThemeControllerExt on BuildContext {
  ThemeController get theme => AppTheme.of(this);
  bool get isDarkMode => theme.isDarkMode;
  ThemeMode get themeMode => theme.themeMode;
  void setThemeMode(ThemeMode mode) => theme.setThemeMode(mode);
  void toggleThemeMode() => theme.toggleThemeMode();
  void resetThemeMode() => theme.resetThemeMode();
  void setThemeColorsIndex(int? index) => theme.setThemeColorsIndex(index);
}

// extension ColorExt on Color {
//   Color brighten(int value) {
//     final color0 = this;
//
//     final red = color0.r + value;
//     final green = color0.g + value;
//     final blue = color0.b + value;
//
//     return Color.fromARGB(
//       color0.a.toInt(),
//       red.clamp(0, 255).toInt(),
//       green.clamp(0, 255).toInt(),
//       blue.clamp(0, 255).toInt(),
//     );
//   }
//
//   Color darken(int value) {
//     final color0 = this;
//
//     final red = color0.r - value;
//     final green = color0.g - value;
//     final blue = color0.b - value;
//
//     return Color.fromARGB(
//       color0.a.toInt(),
//       red.clamp(0, 255).toInt(),
//       green.clamp(0, 255).toInt(),
//       blue.clamp(0, 255).toInt(),
//     );
//   }
// }
