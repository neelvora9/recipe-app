 

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myapp/config/theme/atoms/typography.dart';
import 'package:myapp/config/theme/theme.dart';
import 'package:myapp/config/theme/configs/theme_config.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? ctr;
  final String? labelText;
  final TextInputType inputType;
  final double radius;
  final bool canValidate;
  final int? lines;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool obsecuredText;
  final String? hintText;
  final bool? readOnly;
  final bool? autoFocus;
  final int? maxLength;
  final TextCapitalization? capitalization;
  final bool tapOutsideDismiss;
  final List<TextInputFormatter>? inputFormatters;
  final EdgeInsetsGeometry? contentPadding;
  final Function(String)? onChanged;
  final double? fontSize;
  final String? Function(String?)? validator;
  final VoidCallback? onTap;

  const CustomTextField(
      {super.key,
      this.ctr,
      this.inputType = TextInputType.text,
      this.lines,
      this.radius = 15,
      this.canValidate = true,
      this.labelText,
      this.suffixIcon,
      this.prefixIcon,
      this.obsecuredText = false,
      this.hintText,
      this.readOnly,
      this.maxLength,
      this.capitalization,
      this.tapOutsideDismiss = false,
      this.inputFormatters,
      this.contentPadding,
      this.onChanged,
      this.fontSize,
      this.validator,
      this.onTap,
      this.autoFocus});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: ctr,
      maxLines: lines,
      keyboardType: inputType,
      maxLength: maxLength,
      obscureText: obsecuredText,
      // cursorColor: AppColors.theme,
      autofocus: autoFocus ?? false,
      readOnly: readOnly ?? false,
      inputFormatters: inputFormatters,
      textCapitalization: capitalization ?? TextCapitalization.words,
      onTap: onTap,
      onChanged: onChanged,
      onTapOutside: (_) {
        if (tapOutsideDismiss) {
          FocusScope.of(context).unfocus();
        }
      },
      validator: canValidate
          ? validator ??
              (value) {
                if (value!.trim() == "" || value.isEmpty) {
                  return "$labelText field required*";
                }
                return null;
              }
          : (_) {
              return null;
            },
      style: AppTextLevel.regular14.textStyle,
      decoration: customInputDecoration(
          context: context,
          radius: radius,
          labelText: labelText,
          hintText: hintText,
          fontSize: fontSize,
          contentPadding: contentPadding,
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon),
    );
  }
}

InputDecoration customInputDecoration({
  required BuildContext context,
  double radius = 15,
  String? labelText,
  String? hintText,
  double? fontSize,
  EdgeInsetsGeometry? contentPadding,
  Widget? suffixIcon,
  Widget? prefixIcon,
}) {
  return InputDecoration(
    counterText: "",
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius),
      borderSide: const BorderSide(color: Colors.grey),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius),
      borderSide: const BorderSide(color: Colors.redAccent),
    ),
    suffixIcon: suffixIcon,
    prefixIcon: prefixIcon,
    hintText: hintText,
    hintStyle: AppTextLevel.regular14.textStyle.copyWith(fontWeight: FontWeight.w300),
    labelText: labelText,
    labelStyle: AppTextLevel.regular14.textStyle.copyWith(fontWeight: FontWeight.w300),
    errorStyle: AppTextLevel.regular14.textStyle.copyWith(color: context.colors.WHITE),
    contentPadding: contentPadding ?? EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius),
      // borderSide: const BorderSide(color: AppColors.theme),
    ),
  );
}
