
import 'dart:math' as math;

import 'package:flutter/material.dart';


extension ColorIntensity on Color {
  /// Blends this color toward white by [amount].
  /// 0.0 = original color, 1.0 = pure white.
  Color withOpacityLike(double amount) {
    assert(amount >= 0.0 && amount <= 1.0, 'amount must be between 0 and 1');
    return Color.fromARGB(
      255,
      (red + (255 - red) * (1 - amount)).round(),
      (green + (255 - green) * (1 - amount)).round(),
      (blue + (255 - blue) * (1 - amount)).round(),
    );
  }

  /// Returns "#RRGGBB" (or "#AARRGGBB" when [includeAlpha] is true).
  String toHexString({bool includeHash = true, bool includeAlpha = false}) {
    final a = includeAlpha ? alpha.toRadixString(16).padLeft(2, '0') : '';
    final r = red.toRadixString(16).padLeft(2, '0');
    final g = green.toRadixString(16).padLeft(2, '0');
    final b = blue.toRadixString(16).padLeft(2, '0');
    return '${includeHash ? '#' : ''}$a$r$g$b'.toUpperCase();
  }

  /// Parses a hex string (with or without `#`, 6 or 8 chars) into a [Color].
  static Color fromHex(String hex) {
    final clean = hex.replaceAll('#', '');
    final padded = clean.length == 6 ? 'FF$clean' : clean;
    return Color(int.parse(padded, radix: 16));
  }
}


extension GetInvertedColor on Color {
  Color get inverted {
    final r = 255 - red;
    final g = 255 - green;
    final b = 255 - blue;
    return Color.fromARGB((opacity * 255).round(), r, g, b);
  }
}

extension GetMaterialColor on Color {
  MaterialColor get mapped {
    Map<int, Color> colorMap = {
      50: withOpacity(0.05),
      100: withOpacity(0.1),
      200: withOpacity(0.2),
      300: withOpacity(0.3),
      400: withOpacity(0.4),
      500: withOpacity(0.5),
      600: withOpacity(0.6),
      700: withOpacity(0.7),
      800: withOpacity(0.9),
      900: withOpacity(1),
    };

    return MaterialColor(this.value, colorMap);
  }
}
