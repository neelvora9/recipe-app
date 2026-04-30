 

import 'package:flutter/material.dart';
import 'package:myapp/config/theme/configs/theme_config.dart';

final class Gap {
  const Gap._();

  static const double scale = 1;

  static double get zero => 0;
  static double get size2 => scale * 2;
  static double get size4 => scale * 4;
  static double get size6 => scale * 6;
  static double get size8 => scale * 8;
  static double get size10 => scale * 10;
  static double get size12 => scale * 12;
  static double get size16 => scale * 16;
  static double get size18 => scale * 18;
  static double get size20 => scale * 20;
  static double get size24 => scale * 24;
  static double get size32 => scale * 32;
  static double get size40 => scale * 40;
  static double get size66 => scale * 66;
  static double get size80 => scale * 80;
  static double custom(double val) => scale * val;
  static const double infinity = double.infinity;
}

extension PaddingX on double {
  EdgeInsetsGeometry get paddingAll => EdgeInsets.all(this);
  EdgeInsetsGeometry get paddingHorizontal => EdgeInsets.symmetric(horizontal: this);
  EdgeInsetsGeometry get paddingVertical => EdgeInsets.symmetric(vertical: this);
  EdgeInsetsGeometry get paddingBottom => EdgeInsets.only(bottom: this);
  EdgeInsetsGeometry get paddingTop => EdgeInsets.only(top: this);
  EdgeInsetsGeometry get paddingLeft => EdgeInsets.only(left: this);
  EdgeInsetsGeometry get paddingRight => EdgeInsets.only(right: this);
}

extension PaddingXZ on (double, double) {
  EdgeInsetsGeometry get paddingHV => EdgeInsets.symmetric(horizontal: this.$1, vertical: this.$2);
}

extension PaddingWXYZ on (double, double, double, double) {
  EdgeInsetsGeometry get paddingLTRB => EdgeInsets.fromLTRB(this.$1, this.$2, this.$3, this.$4);
}
