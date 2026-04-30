 

import 'package:flutter/material.dart';

extension RadiusExt on double {
  BorderRadius get borderRadiusCircular => BorderRadius.circular(this);
  BorderRadius get borderRadiusTop => BorderRadius.vertical(top: Radius.circular(this));
  BorderRadius get borderRadiusBottom => BorderRadius.vertical(bottom: Radius.circular(this));
  BorderRadius get borderRadiusLeft => BorderRadius.horizontal(left: Radius.circular(this));
  BorderRadius get borderRadiusRight => BorderRadius.horizontal(right: Radius.circular(this));
}

// final class RadiusSize {
//   const RadiusSize._();
//
//   static const double scale = 1;
//
//   static double get zero => 0;
//   static double get xsmall4 => scale * 4;
//   static double get small8 => scale * 8;
//   static double get medium16 => scale * 16;
//   static double get medium20 => scale * 20;
//   static double get medium24 => scale * 24;
//   static double get medium28 => scale * 28;
//   static double get big44 => scale * 44;
//   static double custom(double val) => scale * val;
// }
