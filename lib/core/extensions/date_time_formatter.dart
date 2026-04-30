 

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Extension for `DateTime` operations
extension DateTimeExtensions on DateTime? {
  /// Converts a nullable `DateTime` to a formatted string.
  String? toFormattedString({String format = 'dd MMM, yyyy'}) {
    if (this == null) return null;
    return DateFormat(format).format(this!);
  }
}

/// Extension for `String` operations
extension StringExtensions on String? {
  /// Converts a nullable string to a formatted date string.
  /// Assumes the string can be parsed into a `DateTime`.
  String? toFormattedDateString({String format = 'dd-MM-yyyy'}) {
    if (this == null) return null;
    final dateTime = DateTime.tryParse(this!);
    return dateTime?.toFormattedString(format: format);
  }

  /// Converts a nullable string to a `TimeOfDay` object.
  TimeOfDay? toTimeOfDay() {
    if (this == null) return null;
    int hh = 0;
    if (this!.endsWith('PM')) hh = 12;
    final time = this!.split(' ')[0];
    final parts = time.split(':');
    if (parts.length != 2) return null;
    return TimeOfDay(
      hour: hh + int.parse(parts[0]) % 24,
      minute: int.parse(parts[1]) % 60,
    );
  }

  /// Converts a nullable time string to a 12-hour format string using localization.
  String? to12HourFormattedTime(BuildContext context) {
    if (this == null) return null;
    final timeOfDay = this!.toTimeOfDay();
    return timeOfDay?.toFormattedString(context);
  }

  /// Converts a nullable string to a `DateTime`.
  DateTime? toDateTime() {
    if (this == null) return null;
    return DateTime.tryParse(this!);
  }
}

/// Extension for `TimeOfDay` operations
extension TimeOfDayExtensions on TimeOfDay? {
  /// Converts a nullable `TimeOfDay` to a formatted string using localization.
  String? toFormattedString(BuildContext context, {bool hrs24 = false}) {
    if (this == null) return null;
    final localizations = MaterialLocalizations.of(context);
    return localizations.formatTimeOfDay(this!, alwaysUse24HourFormat: hrs24);
  }
}
