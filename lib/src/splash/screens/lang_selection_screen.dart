 

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:layer_kit/layer_kit.dart';
import 'package:myapp/config/lang/app_localization.dart';
import 'package:myapp/config/lang/languages.dart';
import 'package:myapp/config/lang/src/lang_selector_dropdown.dart';
import 'package:myapp/config/theme/configs/theme_selector_dropdown.dart';
import 'package:myapp/config/theme/theme.dart';
import 'package:myapp/config/theme/configs/theme_config.dart';
import 'package:myapp/core/constants/app_strings.dart';

import '../../../config/lang/src/language_model.dart';
import '../../../config/routes/routes.dart';
import '../../../core/common/widgets/custom_elevated_button.dart';

class LangSelectionScreen extends StatelessWidget with BaseRoute {
  final Function(BuildContext ctx) onSelection;

  const LangSelectionScreen({
    super.key,
    required this.onSelection,
  });

  @override
  Widget get screen => this;

  @override
  AppRoutes get routeName => Routes.langSelection;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              VGap(5),
              AppString.choose_your_style_language.t32.build(fontWeight: FontWeight.w600, color: context.colors.primary),
              Spacer(),

              /// Dark Theme Toggle
              Card(
                child: Padding(
                  padding: (4.w, 1.h).paddingHV,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppString.dark_theme.title18.build(),
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
                      Expanded(child: AppString.change_theme.title18.build()),
                      const SizedBox(height: 8),
                      ThemeSelectorDropdown(),
                    ],
                  ),
                ),
              ),
              VGap.default1,

              /// Language Selector
              Card(
                child: Padding(
                  padding: (4.w, 1.h).paddingHV,
                  child: Row(
                    children: [
                      Expanded(child: AppString.change_language.title18.build()),
                      LangSelectorDropdown(),
                    ],
                  ),
                ),
              ),

              Spacer(),

              CustomElevatedButton(
                  alignment: Alignment.center,
                  padding: Gap.size10.paddingVertical,
                  onTap: () async => onSelection(context),
                  child: AppString.Continue.button.build(color: context.colors.BUTTON_TEXT, fontWeight: FontWeight.w500)),
              VGap(5),
            ],
          ),
        ),
      ),
    );
  }
}
