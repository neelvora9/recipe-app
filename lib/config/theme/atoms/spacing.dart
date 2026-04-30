 

import 'package:flutter/material.dart';
import 'package:myapp/config/theme/configs/theme_config.dart';

final class VGap extends StatelessWidget {
  const VGap(this.size);

  final double size;

  static VGap get default1 => VGap(1);

  static Widget static(double val) => SizedBox(height: val);

  @override
  Widget build(BuildContext context) => SizedBox(height: size.h);
}

final class HGap extends StatelessWidget {
  const HGap(this.size);

  final double size;

  static VGap get default6 => VGap(6);

  static Widget static(double val) => SizedBox(width: val);

  @override
  Widget build(BuildContext context) => SizedBox(width: size.w);
}
