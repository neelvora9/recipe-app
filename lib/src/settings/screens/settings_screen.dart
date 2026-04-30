 

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:layer_kit/layer_kit.dart';
import 'package:myapp/config/lang/languages.dart';
import 'package:myapp/config/lang/src/lang_selector_dropdown.dart';
import 'package:myapp/config/theme/app_colors.dart';
import 'package:myapp/config/theme/atoms/text.dart';
import 'package:myapp/config/theme/theme.dart';
import 'package:myapp/core/callbacks/callbacks.dart';
import 'package:myapp/core/constants/app_strings.dart';
import 'package:myapp/core/network/network_checker_widget.dart';
import 'package:myapp/config/lang/app_localization.dart';
import 'package:myapp/config/routes/routes.dart';
import 'package:myapp/core/utils/devlog.dart';
import 'package:myapp/di_container.dart';

import '../../../config/lang/src/lang_from_api/dummy_lang_api.dart';
import '../../../config/lang/src/language_model.dart';
import '../../../config/theme/app_theme.dart';
import '../../../config/theme/configs/theme_colors.dart';
import '../../../config/theme/configs/theme_selector_dropdown.dart';
import '../../../core/helper/global_prefs.dart';
import '../../../core/helper/loader.dart';
import '../../../core/helper/notifier_widget.dart';

class SettingScreen extends StatefulWidget with BaseRoute {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();

  @override
  Widget get screen => this;

  @override
  Routes get routeName => Routes.settings;
}

class _SettingScreenState extends State<SettingScreen> {
  ValueNotifier<int>? counterState;

  @override
  Widget build(BuildContext context) {
    devlog("main build method of screen");
    return NetworkCheckerWidget(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            /// Dark Theme Toggle
            Card(
              child: Padding(
                padding: (4.w, 1.h).paddingHV,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppString.dark_theme.t18.build(),
                    CupertinoSwitch(
                      value: context.isDarkMode,
                      activeTrackColor: context.colors.primary,
                      onChanged: (value) {
                        context.toggleThemeMode();
                      },
                    ),
                  ],
                ),
              ),
            ),
            VGap.default1,

            /// Theme Selector
            Card(
              child: Padding(
                padding: (4.w, 1.h).paddingHV,
                child: Row(
                  children: [
                    Expanded(child: AppString.change_theme.t18.build()),
                    const SizedBox(height: 8),
                    ThemeSelectorDropdown(),
                  ],
                ),
              ),
            ),
            VGap.default1,
            Text("Note : Theme changes will be applied after you restart the app."),
            VGap.default1,

            /// Language Selector
            Card(
              child: Padding(
                padding: (4.w, 1.h).paddingHV,
                child: Row(
                  children: [
                    Expanded(child: AppString.change_language.t18.build()),
                    LangSelectorDropdown(),
                  ],
                ),
              ),
            ),
            VGap.default1,

            /// NOTIFIER WIDGET EXAMPLE
            Card(
              child: Column(
                children: [
                  VGap(2),
                  AppString.custom("This is just basic Notifier Widget Example").regular16.build(),
                  NotifierWidget<bool>(
                    initialValue: true,
                    builder: (context, state) {
                      devlog("build of Boolean NotifierWidget");
                      return ElevatedButton(
                        onPressed: () => state.value = !state.value,
                        child: AppString.custom('Click Value : ${state.value.toString().toUpperCase()}').regular16.build(color: state.value ? context.colors.primary : context.colors.foreground),
                      );
                    },
                  ),
                  VGap(2),
                ],
              ),
            ),

            /// NOTIFIER WIDGET EXAMPLE WITH COUNTER
            Card(
              child: Column(
                children: [
                  VGap(2),
                  AppString.notifier_widget_example_with_counter.t16.build(),
                  VGap(1),
                  NotifierWidget<int>(
                    initialValue: 0,
                    onInit: (notifier) => counterState = notifier,
                    builder: (context, state) {
                      devlog("build of Counter NotifierWidget");
                      return Card(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () => state.value--,
                              icon: const Icon(Icons.remove),
                            ),
                            AppString.custom('${state.value}').t14.build().paddingSymmetric(horizontal: 1.5.w),
                            IconButton(
                              onPressed: () => state.value++,
                              icon: const Icon(Icons.add),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  VGap(1),
                  ElevatedButton(
                    onPressed: () => counterState?.value -= 1,
                    child: AppString.custom("Decrease : Outside NotifierWidget").t16.build(),
                  ),
                  VGap(1),
                  ElevatedButton(
                    onPressed: () => counterState?.value = 0,
                    child: AppString.custom("Reset : Outside NotifierWidget").t16.build(),
                  ),
                  VGap(1),
                  ElevatedButton(
                    onPressed: () => counterState?.value += 1,
                    child: AppString.custom("Increase : Outside NotifierWidget").t16.build(),
                  ),
                  VGap(1),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
