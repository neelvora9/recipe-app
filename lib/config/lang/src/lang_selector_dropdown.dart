 

import 'package:flutter/material.dart';
import 'package:myapp/config/lang/app_localization.dart';
import 'package:myapp/config/lang/languages.dart';
import 'package:myapp/config/theme/theme.dart';
import 'package:myapp/core/constants/app_strings.dart';

import '../../../core/callbacks/callbacks.dart';
import '../../../core/helper/global_prefs.dart';
import '../../../core/helper/loader.dart';
import 'lang_from_api/dummy_lang_api.dart';
import 'language_model.dart';

class LangSelectorDropdown extends StatelessWidget {
  const LangSelectorDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    List<LanguageModel> langs = List.from(languages);
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: langs.where((element) => element.code == context.locale.languageCode).firstOrNull?.code,
        hint: AppString.custom("Select").regular16.build(),
        items: langs
            .map((lang) => DropdownMenuItem(
                  value: lang.code,
                  child: AppString.custom("${lang.image} ${lang.displayName}").regular16.build(),
                ))
            .toList(),
        onChanged: (value) async => await safeRun(
           "lang selection dropdown",
           () async {
            if (value != null) {
              /// REMOVE THIS IF YOU DONT HAVE LANGUAGES FROM API
              {
                showLoader(context);
                final langRes = await DummyLangApi.fetchTranslations(value);
                hideLoader();
                GlobalPrefs.setLanguage = langRes;
                context.setTranslations(langRes?.translations);
              }
              context.setLocale(value.toLocale());
            }
          },
        ),
      ),
    );
  }
}
