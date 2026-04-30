 

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myapp/config/theme/theme.dart';
import 'package:myapp/core/constants/app_strings.dart';
import 'package:myapp/core/extensions/color_ext.dart';
import "package:toastification/toastification.dart";

import '../../config/theme/app_colors.dart';
import "../../config/theme/atoms/text.dart";

Future<bool?> showFlutterToast(String msg, {Color? textColor, Color? color}) {
  return Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_SHORT,
    fontSize: 1.55.t,
    backgroundColor: color ?? AppColors.light.primary.mapped.shade200,
    textColor: textColor ?? Colors.black,
    gravity: ToastGravity.BOTTOM,
  );
}

showSnackbar(String msg, {ToastificationType? type, Color? textColor, Color? color, Color? handleColor}) {
  toastification.dismissAll(delayForAnimation: false);
  toastification.show(
    description: AppString.custom(msg).t16.build(
          textAlign: TextAlign.start,
          maxLines: 20,
          fontSize: 16.sp,
          color: textColor ?? Colors.white,
          fontWeight: FontWeight.w500,
        ),
    style: ToastificationStyle.minimal,
    backgroundColor: color ?? Colors.grey.shade800,
    foregroundColor: Colors.white,
    borderSide: BorderSide(color: color ?? Colors.grey.shade800),
    primaryColor: type != null ? null : handleColor ?? AppColors.light.primary,
    alignment: Alignment.bottomCenter,
    autoCloseDuration: Duration(milliseconds: 1500),
    type: type,
    showProgressBar: false,
    margin: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0),
    padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 5),
    showIcon: type != null,
  );
}
