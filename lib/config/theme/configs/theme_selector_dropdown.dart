 

import 'package:flutter/material.dart';
import 'package:myapp/config/theme/configs/theme_colors.dart';
import 'package:myapp/config/theme/theme.dart';
import 'package:myapp/core/constants/app_strings.dart';

class ThemeSelectorDropdown extends StatelessWidget {
  const ThemeSelectorDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return DropdownButton<ThemeColorsModel>(
      underline: SizedBox(),
      hint: Container(
        width: 4.r,
        height: 4.r,
        decoration: BoxDecoration(
          color: context.colors.primary,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black12),
        ),
      ),
      items: themeColorsOptions.asMap().entries.map((entry) {
        ThemeColorsModel theme = entry.value;

        return DropdownMenuItem<ThemeColorsModel>(
          value: theme,
          child: theme.lightPrimary == null
              ? AppString.reset.t16.build()
              : Container(
                  width: 4.r,
                  height: 4.r,
                  decoration: BoxDecoration(
                    color: theme.lightPrimary ?? Colors.grey,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black12),
                  ),
                ),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null && value.lightPrimary != null) {
          final index = themeColorsOptions.indexOf(value);
          final i = index >= 0 ? index : null;
          context.setThemeColorsIndex(i);
        } else {
          context.setThemeColorsIndex(null);
        }
      },
    );
  }
}
