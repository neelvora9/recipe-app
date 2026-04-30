 

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:layer_kit/layer_kit.dart';
import 'package:myapp/config/lang/app_localization.dart';
import 'package:myapp/config/lang/languages.dart';
import 'package:myapp/config/lang/src/lang_from_api/dummy_lang_api.dart';
import 'package:myapp/config/theme/theme.dart';
import 'package:myapp/config/theme/configs/theme_config.dart';
import 'package:myapp/core/callbacks/callbacks.dart';
import 'package:myapp/core/helper/loader.dart';
import 'package:myapp/core/utils/devlog.dart';
import 'package:myapp/src/splash/screens/lang_selection_screen.dart';

import '../../../config/routes/routes.dart';
import '../../../core/helper/global_prefs.dart';
import '../../../core/helper/notifier_widget.dart';
import '../../../core/helper/safe_state_abstract.dart';
import '../../home/datasource/model/repo/home_repo.dart';
import '../../home/screens/home_screen.dart';

class SplashScreen extends StatefulWidget with BaseRoute {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();

  @override
  Widget get screen => this;

  @override
  AppRoutes get routeName => Routes.splash;
}

class _SplashScreenState extends SafeState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () async {
      var langs = await DummyLangApi.fetchLanguages();
      if (langs.isNotEmpty) {
        final supportedLocales = langs.map((e) => e.code.toLocale()).toList();
        languages = langs;
        context.setSupportedLocales(supportedLocales);
      }

      /// TOKEN BASED LOGIN

      devlog("context.savedLocale : ${context.savedLocale}");

      // if (context.savedLocale == null) {
      //   context.pushNamedAndRemoveUntil(LangSelectionScreen(onSelection: (ctx) async => redirect(ctx)), (route) => false);
      //   return;
      // } else {
        await safeRun(
          "lang selection else",
          () {
            if (context.savedLocale != null) {
              final savedTranslations = GlobalPrefs.getLanguage;
              if (savedTranslations != null) {
                context.setTranslations(savedTranslations.translations);
                context.setLocale(savedTranslations.code.toLocale());
              }
            }
          },
        );
        redirect(context);
      // }
    });
  }

  void redirect(BuildContext context) {
    final isToken = GlobalPrefs.isTokenAvailable;

    // if (isToken) {
      context.pushNamedAndRemoveUntil(HomeScreen(), (route) => false);
    // } else {
    //   context.pushNamedAndRemoveUntil(LoginScreen(), (route) => false);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      body: SizedBox(
        width: 100.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.flutter_dash, size: 30.w),
          ],
        ),
      ),
    );
  }
}
