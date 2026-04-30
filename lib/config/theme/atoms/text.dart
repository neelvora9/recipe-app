 

import "package:flutter/material.dart";
import "package:myapp/config/lang/app_localization.dart";

import "package:myapp/config/theme/atoms/typography.dart";
import "package:myapp/core/constants/app_strings.dart";

class AppText {
  final AppString text;
  final AppTextLevel level;

  AppText(this.text, this.level);

  Text build({
    Key? key,
    Color? color,
    String? fontFamily,
    double? fontSize,
    FontWeight? fontWeight,
    bool? isUnderLine,
    TextStyle? style,
    TextAlign? textAlign,
    TextDirection? textDirection,
    Locale? locale,
    bool? softWrap,
    TextOverflow? overflow,
    double? textScaleFactor,
    int? maxLines,
    String? semanticsLabel,
    TextWidthBasis? textWidthBasis,
    TextHeightBehavior? textHeightBehavior,
    Color? selectionColor,
    StrutStyle? strutStyle,
  }) {
    final defaultStyle = level.textStyle;
    final combinedStyle = defaultStyle.merge(style).copyWith(
          color: color,
          fontSize: fontSize,
          fontWeight: fontWeight,
          decoration: isUnderLine == true ? TextDecoration.underline : null,
          decorationColor: color,
          fontFamily: fontFamily,
        );

    return Text(
      text.isCustom ? text.value : text.value.tr(args: text.args, namedArgs: text.namedArgs),
      key: key,
      style: combinedStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      textScaleFactor: textScaleFactor,
      maxLines: maxLines,
      semanticsLabel: semanticsLabel,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
      selectionColor: selectionColor,
      strutStyle: strutStyle,
    );
  }
}

extension StringTextExtensions on AppString {
  @Deprecated("Use t64.")
  AppText get titleX => AppText(this, AppTextLevel.titleX64);

  @Deprecated("Use t32.")
  AppText get title32 => AppText(this, AppTextLevel.title32);

  @Deprecated("Use t24.")
  AppText get title24 => AppText(this, AppTextLevel.title24);

  @Deprecated("Use t18.")
  AppText get title18 => AppText(this, AppTextLevel.title18);

  @Deprecated("Use t16.")
  AppText get regular16 => AppText(this, AppTextLevel.regular16);

  @Deprecated("Use t14.")
  AppText get regular14 => AppText(this, AppTextLevel.regular14);

  @Deprecated("Use t13.")
  AppText get small13 => AppText(this, AppTextLevel.small13);

  @Deprecated("Use t12.")
  AppText get tiny12 => AppText(this, AppTextLevel.tiny12);

  AppText get t64 => AppText(this, AppTextLevel.titleX64);

  AppText get t32 => AppText(this, AppTextLevel.title32);

  AppText get t24 => AppText(this, AppTextLevel.title24);

  AppText get t18 => AppText(this, AppTextLevel.title18);

  AppText get t16 => AppText(this, AppTextLevel.regular16);

  AppText get t14 => AppText(this, AppTextLevel.regular14);

  AppText get t13 => AppText(this, AppTextLevel.small13);

  AppText get t12 => AppText(this, AppTextLevel.tiny12);

  AppText get t10 => AppText(this, AppTextLevel.xtiny10);

  AppText get appbar => AppText(this, AppTextLevel.regular16);

  AppText get button => AppText(this, AppTextLevel.regular14);
}
