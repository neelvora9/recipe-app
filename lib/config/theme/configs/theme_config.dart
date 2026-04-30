 

import 'dart:math';

import 'package:flutter/material.dart';

class ThemeConfig {
  const ThemeConfig._();

  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double blockSizeHorizontal;
  static late double blockSizeVertical;
  static late double _safeAreaHorizontal;
  static late double _safeAreaVertical;
  static late double safeBlockHorizontal;
  static late double safeBlockVertical;

  bool get isMobile => screenWidth < 768;

  bool get isTablet => screenWidth >= 768 && screenWidth < 1200;

  bool get isDesktop => screenWidth >= 1200;

  bool get isPortrait => _mediaQueryData.orientation == Orientation.portrait;

  bool get isLandscape => _mediaQueryData.orientation == Orientation.landscape;

  EdgeInsets get horizontalBodyPadding {
    return EdgeInsets.symmetric(
        horizontal: value(16, tablet: 100, desktop: 200));
  }

  double get gutterSmall => value(8, tablet: 16, desktop: 24);

  double get gutterMedium => value(16, tablet: 24, desktop: 32);

  double get gutterLarge => value(24, tablet: 32, desktop: 48);

  T value<T>(T mobile, {required T? tablet, required T? desktop}) {
    if (isMobile) return mobile;
    if (isTablet) return tablet ?? mobile;
    return desktop ?? mobile;
  }

  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;

    _safeAreaHorizontal =
        _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    _safeAreaVertical =
        _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;
    safeBlockHorizontal = (screenWidth - _safeAreaHorizontal) / 100;
    safeBlockVertical = (screenHeight - _safeAreaVertical) / 100;
  }
}

extension SizeConfigExtension on num {
  double get w => this * ThemeConfig.blockSizeHorizontal;

  double get h => this * ThemeConfig.blockSizeVertical;

  @Deprecated("Use 'sp' for font sizes instead of 't' for better scaling across devices.")
  double get t {
    final aspectRatio = ThemeConfig.screenWidth / ThemeConfig.screenHeight;
    final diagonalSize = sqrt(
        ThemeConfig.screenWidth * ThemeConfig.screenWidth +
            ThemeConfig.screenHeight *
                ThemeConfig
                    .screenHeight); // Calculating diagonal size of the screen
    final scaleFactor = diagonalSize / 100;
    final adjustedScale = scaleFactor * (aspectRatio > 1.5 ? 0.7 : 1);
    return this * adjustedScale;
  }

  double get sp {
    const baseWidth = 375.0;

    final scale =
    (ThemeConfig.screenWidth / baseWidth).clamp(0.85, 1.3);

    const globalFontFactor = 0.92;

    return this * scale * globalFontFactor;
  }

  double get r {
    final averageBlockSize =
        (ThemeConfig.blockSizeHorizontal + ThemeConfig.blockSizeVertical) / 2;
    return this * averageBlockSize;
  }
}
