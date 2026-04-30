//━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//               CREATED BY NAYAN PARMAR
//          UPGRADED DEV LOGGER (DEVTOOLS READY)
//━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'dart:convert';
import 'dart:developer' as dev;

import '../../../defaults.dart';

String _truncateData(String data, int? limit) {
  if (limit == null) return data;
  return data.length > limit ? '${data.substring(0, limit)}...' : data;
}

/// Pretty JSON formatter
String _pretty(dynamic data) {
  try {
    const encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(data);
  } catch (_) {
    return data.toString();
  }
}

/// Indent for better console UI
String _indent(String text) {
  return text.split('\n').map((e) => "  $e").join('\n');
}

/// ✅ SAME FUNCTION NAME (no breaking changes)
void devlog(
  String msg, {
  String? name,
  int? limit,
}) {
  if (!D.showDevLog) return;

  final logName = name ?? "LOG || INFO";

  final buffer = StringBuffer()
    ..writeln("${_truncateData(msg, 30)}")
    ..writeln("╔══════════════ $logName ══════════════")
    ..writeln("║ 👉 $msg");
  buffer.writeln("╚═══════════════════════════════════════");

  if (D.envType.isDevelopmentWithPrint) {
    print(buffer.toString());
  } else {
    dev.log(
      buffer.toString(),
      name: logName,
    );
  }
}

/// ✅ SAME FUNCTION NAME (no breaking changes)
void devlogError(
  String error, {
  StackTrace? stackTrace,
}) {
  if (!D.showDevErrorLog) return;

  final buffer = StringBuffer()
    ..writeln("╔══════════════ ERROR ❌ ══════════════")
    ..writeln("║ ❌ $error");

  if (stackTrace != null) {
    buffer
      ..writeln("║ STACKTRACE:")
      ..writeln(_indent(stackTrace.toString()));
  }

  buffer.writeln("╚═══════════════════════════════════════");

  if (D.envType.isDevelopmentWithPrint) {
    print(buffer.toString());
  } else {
    dev.log(
      buffer.toString(),
      name: "LOG || ERROR",
      error: error,
      stackTrace: stackTrace,
    );
  }
}
