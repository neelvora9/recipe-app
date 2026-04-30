 

import 'package:flutter/material.dart';
import 'package:myapp/config/theme/theme.dart';

ThemeColorsModel themeColors = ThemeColorsModel();

/// use [apiThemeColors] when you fetch colors from api for dynamic UI
ThemeColorsModel apiThemeColors = ThemeColorsModel(
  lightPrimary: const Color.fromARGB(255, 49, 8, 124),
  lightSecondary: const Color(0xFFB40000),
  lightTertiary: const Color(0xFFEEF4FF),
  darkPrimary: const Color(0xFF53ADAE),
  darkSecondary: const Color.fromARGB(255, 255, 11, 11),
  darkTertiary: const Color(0xFFEEF4FF),
);

final List<ThemeColorsModel> themeColorsOptions = [
  ThemeColorsModel(
    lightPrimary: Color(0xFF7F3DFF),
    lightSecondary: Color(0xFFCCC1FF),
    lightTertiary: Color(0xFFE8DEF8),
    darkPrimary: Color(0xFFBB86FC),
    darkSecondary: Color(0xFF3700B3),
    darkTertiary: Color(0xFF6200EE),
  ),
  ThemeColorsModel(
    lightPrimary: Color(0xFF0A84FF),
    lightSecondary: Color(0xFF5AC8FA),
    lightTertiary: Color(0xFFD0F0FD),
    darkPrimary: Color(0xFF0A84FF),
    darkSecondary: Color(0xFF64D2FF),
    darkTertiary: Color(0xFF409CFF),
  ),
  ThemeColorsModel(
    lightPrimary: Color(0xFF34C759),
    lightSecondary: Color(0xFF32D74B),
    lightTertiary: Color(0xFFD9FDD3),
    darkPrimary: Color(0xFF30D158),
    darkSecondary: Color(0xFF64ED85),
    darkTertiary: Color(0xFF248A3D),
  ),
  ThemeColorsModel(
    lightPrimary: Color(0xFFFF9500),
    lightSecondary: Color(0xFFFFD60A),
    lightTertiary: Color(0xFFFFF4CC),
    darkPrimary: Color(0xFFFF9F0A),
    darkSecondary: Color(0xFFFFB340),
    darkTertiary: Color(0xFFDA7900),
  ),
  ThemeColorsModel(
    lightPrimary: Color(0xFFFF3B30),
    lightSecondary: Color(0xFFFF453A),
    lightTertiary: Color(0xFFFFDAD4),
    darkPrimary: Color(0xFFFF453A),
    darkSecondary: Color(0xFFFF6961),
    darkTertiary: Color(0xFFB3261E),
  ),
  ThemeColorsModel(
    lightPrimary: Color(0xFF5E5CE6),
    lightSecondary: Color(0xFF8E8DFF),
    lightTertiary: Color(0xFFE0E0FF),
    darkPrimary: Color(0xFF5E5CE6),
    darkSecondary: Color(0xFF7D7BFF),
    darkTertiary: Color(0xFF3C3ACB),
  ),
  ThemeColorsModel(),
];

class ThemeColorsModel {
  ThemeColorsModel({
    this.lightTertiary,
    this.lightSecondary,
    this.lightPrimary,
    this.darkTertiary,
    this.darkSecondary,
    this.darkPrimary,
  });

  Color? lightTertiary;
  Color? lightSecondary;
  Color? lightPrimary;
  Color? darkTertiary;
  Color? darkSecondary;
  Color? darkPrimary;

  ThemeColorsModel.fromJson(Map<String, dynamic> json)
      : lightTertiary = colorFromHex(json['light_tertiary']?.toString() ?? ''),
        lightSecondary = colorFromHex(json['light_secondary']?.toString() ?? ''),
        lightPrimary = colorFromHex(json['light_primary']?.toString() ?? ''),
        darkTertiary = colorFromHex(json['dark_tertiary']?.toString() ?? ''),
        darkSecondary = colorFromHex(json['dark_secondary']?.toString() ?? ''),
        darkPrimary = colorFromHex(json['dark_primary']?.toString() ?? '');

  static Color? colorFromHex(String hexColor) {
    try {
      final buffer = StringBuffer();
      if (hexColor.length == 6 || hexColor.length == 7) buffer.write('ff');
      buffer.write(hexColor.replaceFirst('#', ''));
      return Color(int.parse(buffer.toString(), radix: 16));
    } catch (e) {
      return null;
    }
  }

  static String colorToHex(Color color) {
    final red = (color.r * 255).toInt().toRadixString(16).substring(2);
    final green = (color.g * 255).toInt().toRadixString(16).substring(2);
    final blue = (color.b * 255).toInt().toRadixString(16).substring(2);

    return '#$red$green$blue';
  }
}
