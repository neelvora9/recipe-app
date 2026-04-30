 

import 'package:flutter/material.dart';
import 'package:myapp/core/helper/global_prefs.dart';
import 'package:myapp/core/utils/devlog.dart';

 

import 'package:flutter/material.dart';
import 'package:myapp/core/helper/global_prefs.dart';
import 'package:myapp/core/utils/devlog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/helper/logger.dart';
import 'configs/theme_controller.dart';

class AppTheme extends StatelessWidget {
  final Widget child;

  const AppTheme({super.key, required this.child});

  static Future<void> init() async {
    await ThemeController.init();
    logger.debug("Theme Initialized");
  }

  static ThemeController of(BuildContext context) => _AppThemeProvider.of(context);

  @override
  Widget build(BuildContext context) {
    logger.debug("Build");
    return _AppThemeProvider(child: child, state: ThemeController());
  }

  static AppLogger logger = AppLogger(name: '🎨 App Theme');
}

class _AppThemeProvider extends InheritedNotifier<ThemeController> {
  final ThemeController state;

  _AppThemeProvider({
    Key? key,
    required this.state,
    required Widget child,
  }) : super(key: key, notifier: state, child: child) {
    AppTheme.logger.debug('Init provider');
  }

  static ThemeController of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<_AppThemeProvider>();
    assert(provider != null, 'No AppThemeProvider found in context');
    return provider!.notifier!;
  }
}
