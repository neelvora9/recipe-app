import "package:flutter/material.dart";
import "configs/theme_colors.dart";

class AppColors {
  final Color primary;
  final Color secondary;
  final Color tertiary;
  final Color textColor;
  final Color background;
  final Color foreground;
  final Color border;
  final Color shimmerBase;
  final Color shimmerHighlight;
  final Color shimmerContent;

  final Color BLACK = Colors.black;
  final Color WHITE = Colors.white;
  final Color ERROR = const Color(0xFFE53935);
  final Color SUCCESS = const Color(0xFF43A047);
  final Color WARNING = const Color(0xFFFBC02D);
  final Color BUTTON_TEXT = Colors.white;

  static const Color K_PRIMARY_LIGHT = Color(0xFFFF7043); // 🍊 Orange
  static const Color K_PRIMARY_DARK = Color(0xFFFF8A65);

  AppColors._({
    required this.primary,
    required this.secondary,
    required this.tertiary,
    required this.textColor,
    required this.background,
    required this.foreground,
    required this.border,
    required this.shimmerBase,
    required this.shimmerHighlight,
    required this.shimmerContent,
  });

  /// 🌞 LIGHT THEME
  static AppColors get light => AppColors._(
    primary: themeColors.lightPrimary ?? K_PRIMARY_LIGHT,

    // 🌿 Fresh Green Accent
    secondary: themeColors.lightSecondary ?? const Color(0xFF66BB6A),

    // 🎨 Soft card/background tint
    tertiary: themeColors.lightTertiary ?? const Color(0xFFFFF3E0),

    background: const Color(0xFFFDFDFD),
    foreground: const Color(0xFF1C1C1C),

    textColor: const Color(0xFF4A4A4A),

    border: const Color(0xFFE0E0E0),

    // ✨ Shimmer (subtle & clean)
    shimmerBase: const Color(0xFFE0E0E0),
    shimmerHighlight: const Color(0xFFF5F5F5),
    shimmerContent: Colors.white.withValues(alpha: 0.8),
  );

  /// 🌙 DARK THEME
  static AppColors get dark => AppColors._(
    primary: themeColors.darkPrimary ?? K_PRIMARY_DARK,

    secondary: themeColors.darkSecondary ?? const Color(0xFF81C784),

    tertiary: themeColors.darkTertiary ?? const Color(0xFF2C2C2C),

    background: const Color(0xFF121212),
    foreground: const Color(0xFFFFFFFF),

    textColor: const Color(0xFFE0E0E0),

    border: const Color(0xFF2A2A2A),

    shimmerBase: const Color(0xFF2A2A2A),
    shimmerHighlight: const Color(0xFF3A3A3A),
    shimmerContent: Colors.white.withValues(alpha: 0.6),
  );

  static AppColors fromBrightness(Brightness brightness) =>
      brightness == Brightness.dark ? AppColors.dark : AppColors.light;
}

//
// // ignore_for_file: non_constant_identifier_names, constant_identifier_names
//
// import "package:flutter/material.dart";
//
// import "configs/theme_colors.dart";
//
// class AppColors {
//   final Color primary;
//   final Color secondary;
//   final Color tertiary;
//   final Color textColor;
//   final Color background;
//   final Color foreground;
//   final Color border;
//   final Color shimmerBase;
//   final Color shimmerHighlight;
//   final Color shimmerContent;
//
//   final Color BLACK = Colors.black;
//   final Color WHITE = Colors.white;
//   final Color ERROR = Color.fromARGB(255, 166, 4, 4);
//   final Color SUCCESS = Color.fromARGB(255, 12, 161, 161);
//   final Color WARNING = Color(0xFFC2AF6F);
//   final Color BUTTON_TEXT = Colors.white;
//   static const Color K_PRIMARY_LIGHT = Color.fromARGB(255, 49, 8, 124);
//   static const Color K_PRIMARY_DARK = Color(0xff53ADAE);
//
//   AppColors._({
//     required this.primary,
//     required this.secondary,
//     required this.tertiary,
//     required this.textColor,
//     required this.background,
//     required this.foreground,
//     required this.border,
//     required this.shimmerBase,
//     required this.shimmerHighlight,
//     required this.shimmerContent,
//   });
//
//   static AppColors get light => AppColors._(
//         primary: themeColors.lightPrimary ?? K_PRIMARY_LIGHT,
//         secondary: themeColors.lightSecondary ?? Color(0xFFB40000),
//         tertiary: themeColors.lightTertiary ?? Color(0xFFEEF4FF),
//         background: Color(0xFFFAFAFA),
//         foreground: Color(0xFF000000),
//         textColor: Color(0xFF4D5454),
//         border: Color(0xffEEEEEE).withValues(alpha: 0.6),
//         shimmerBase: Color.fromARGB(255, 225, 225, 225),
//         shimmerHighlight: Colors.grey.shade100,
//         shimmerContent: Colors.white.withValues(alpha: 0.85),
//       );
//
//   static AppColors get dark => AppColors._(
//         primary: themeColors.darkPrimary ?? K_PRIMARY_DARK,
//         secondary: themeColors.darkSecondary ?? Color.fromARGB(255, 255, 11, 11),
//         tertiary: themeColors.darkTertiary ?? Color(0xFFEEF4FF),
//         background: Color.from(alpha: 1, red: 0.047, green: 0.047, blue: 0.0),
//         foreground: Color(0xffffffff),
//         textColor: Color(0xffFDFDFD),
//         border: Color(0xffFDFDFD),
//         shimmerBase: Color.fromARGB(255, 150, 150, 150),
//         shimmerHighlight: Colors.grey.shade300,
//         shimmerContent: Colors.white.withValues(alpha: 0.7),
//       );
//
//   static AppColors fromBrightness(Brightness brightness) => brightness == Brightness.dark ? AppColors.dark : AppColors.light;
// }
