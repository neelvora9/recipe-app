 

// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:myapp/config/theme/configs/theme_config.dart';

// extension TypographyExt on TextTheme {
//   TextStyle get titleX64 => TextStyle(fontSize: 64, fontWeight: FontWeight.w500, package: "");
//   TextStyle get title32 => TextStyle(fontSize: 32, fontWeight: FontWeight.w500, package: "");
//   TextStyle get title24 => TextStyle(fontSize: 24, fontWeight: FontWeight.w500, package: "");
//   TextStyle get title18 => TextStyle(fontSize: 18, fontWeight: FontWeight.w500, package: "");
//   TextStyle get regular16 => TextStyle(fontSize: 16, fontWeight: FontWeight.w400, package: "");
//   TextStyle get regular14 => TextStyle(fontSize: 14, fontWeight: FontWeight.w400, package: "");
//   TextStyle get small13 => TextStyle(fontSize: 13, fontWeight: FontWeight.w400, package: "");
//   TextStyle get tiny12 => TextStyle(fontSize: 12, fontWeight: FontWeight.w400, package: "");
// }

enum AppTextLevel {
  titleX64,
  title32,
  title24,
  title18,
  regular16,
  regular14,
  small13,
  tiny12,
  xtiny10,
  ;

  TextStyle get textStyle => switch (this) {
        AppTextLevel.titleX64 => TextStyle(fontSize: 64.sp, fontWeight: FontWeight.w500),
        AppTextLevel.title32 => TextStyle(fontSize: 32.sp, fontWeight: FontWeight.w500),
        AppTextLevel.title24 => TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w500),
        AppTextLevel.title18 => TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500),
        AppTextLevel.regular16 => TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400),
        AppTextLevel.regular14 => TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400),
        AppTextLevel.small13 => TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w400),
        AppTextLevel.tiny12 => TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w400),
        AppTextLevel.xtiny10 => TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w400),
      };
}
