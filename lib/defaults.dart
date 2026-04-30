 

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:layer_kit/layer_kit.dart';
import 'package:myapp/config/theme/configs/theme_config.dart';

import 'core/constants/layerkit_constants.dart';

enum EnvType {
  development, // normal debug and developent
  developmentWithPrint, // useful to print log in running release app
  production, // set this for play store deploy bundle
  ;

  bool get isDevelopment => this == EnvType.development;
  bool get isDevelopmentWithPrint => this == EnvType.developmentWithPrint;
  bool get isProduction => this == EnvType.production;
}

/// [D] - [Defaults]
abstract class D {
  const D._();

  static const EnvType envType = EnvType.development;
  static final bool isIOS = Platform.isIOS;
  static const bool showApiReqLog = true;
  static const bool showApiResLog = true;
  static const bool showDevLog = true;
  static const bool showDevErrorLog = true;
  static const bool removeTryCatch = false;
  static const TransitionType transitionType = TransitionType.slideLeft;

  // UI/UX Configuration
  // static final String? fontFamily = '';
  static const FontWeight fontWeight = FontWeight.w400;

  // Button Configuration
  static final double defaultAppButtonRadius = 4.r;
  static const double defaultAppButtonElevation = 4.0;


  // Shadow Configuration
  static final Color shadowColorGlobal = Colors.grey.withOpacity(0.2);
  static const int defaultElevation = 4;
  static final double defaultRadius = 4.r;
  static const double defaultBlurRadius = 4.0;
  static const double defaultSpreadRadius = 1.0;
  static const double defaultAppBarElevation = 4.0;

  // Other Settings
  static const int passwordLengthGlobal = 6;
  static const int apiLogDataLengthInChars = 5000;
  static const String defaultCurrencySymbol = RS;
}
