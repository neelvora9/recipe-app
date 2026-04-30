//━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//               CREATED BY NAYAN PARMAR
//        ADVANCED LOGGER (PRETTY + TIMING)
//━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';

import '../../../defaults.dart';

class LoggingInterceptor extends InterceptorsWrapper {
  static const String green = "\x1B[32m";
  static const String red = "\x1B[31m";
  static const String yellow = "\x1B[33m";
  static const String cyan = "\x1B[36m";
  static const String reset = "\x1B[0m";

  /// Store request start time
  final Map<String, DateTime> _requestTimes = {};

  String truncate(String text) {
    if (text.length > D.apiLogDataLengthInChars) {
      return '${text.substring(0, D.apiLogDataLengthInChars)}...';
    }
    return text;
  }

  /// Pretty JSON formatter
  String prettyJson(dynamic data) {
    try {
      const encoder = JsonEncoder.withIndent('  ');
      return encoder.convert(data);
    } catch (_) {
      return data.toString();
    }
  }

  /// Unique key for request tracking
  String _getKey(RequestOptions options) {
    return "${options.method}_${options.path}_${options.hashCode}";
  }

  @override
  Future onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    if (!D.showApiReqLog) return super.onRequest(options, handler);

    final key = _getKey(options);
    _requestTimes[key] = DateTime.now();

    final data = options.data is FormData
        ? (options.data as FormData).fields
        : options.data;

    final message = StringBuffer() ..writeln("${options.path}")
      ..writeln("╔════════════════ REQUEST ➤ ════════════════")
      ..writeln("║ ➤ PATH     : ${options.path}")
      ..writeln("║ ➤ METHOD   : ${options.method}")
      ..writeln("║ ➤ QUERY    : ${options.queryParameters}")
      ..writeln("║ ➤ HEADERS  : ${options.headers}");

    if (data != null) {
      message
        ..writeln("║ ➤ BODY:")
        ..writeln(_indent(prettyJson(data)));
    }

    message.writeln("╚═══════════════════════════════════════════");

    if (D.envType.isDevelopmentWithPrint) {
      print("$yellow$message$reset");
    } else {
      log(message.toString(), name: "LOG || API REQUEST ➤");
    }

    return super.onRequest(options, handler);
  }

  @override
  Future onResponse(
      Response response, ResponseInterceptorHandler handler) async {
    if (!D.showApiResLog) return super.onResponse(response, handler);

    final key = _getKey(response.requestOptions);
    final startTime = _requestTimes.remove(key);
    final duration = startTime != null
        ? DateTime.now().difference(startTime).inMilliseconds
        : 0;

    final message = StringBuffer()
      ..writeln("${response.statusCode} :: ${response.requestOptions.path}")
      ..writeln("╔══════════════ RESPONSE ✔ ════════════════")
      ..writeln("║ ✔ PATH     : ${response.requestOptions.path}")
      ..writeln("║ ✔ STATUS   : ${response.statusCode}")
      ..writeln("║ ✔ TIME     : ${duration} ms");

    if (response.data != null) {
      message
        ..writeln("║ ✔ BODY:")
        ..writeln(_indent(prettyJson(response.data)));
    }

    message.writeln("╚═══════════════════════════════════════════");

    if (D.envType.isDevelopmentWithPrint) {
      print("$green$message$reset");
    } else {
      log(message.toString(), name: "LOG || API RESPONSE ✔");
    }

    return super.onResponse(response, handler);
  }

  @override
  Future onError(
      DioException err, ErrorInterceptorHandler handler) async {
    final key = _getKey(err.requestOptions);
    final startTime = _requestTimes.remove(key);
    final duration = startTime != null
        ? DateTime.now().difference(startTime).inMilliseconds
        : 0;

    final message = StringBuffer() ..writeln("ERROR :: ${err.requestOptions.path}")
      ..writeln("╔══════════════ ERROR ✖ ════════════════")
      ..writeln("║ ✖ PATH     : ${err.requestOptions.path}")
      ..writeln("║ ✖ STATUS   : ${err.response?.statusCode}")
      ..writeln("║ ✖ TIME     : ${duration} ms")
      ..writeln("║ ✖ MESSAGE  : ${err.message}");

    if (err.response?.data != null) {
      message
        ..writeln("║ ✖ BODY:")
        ..writeln(_indent(prettyJson(err.response?.data)));
    }

    message.writeln("╚══════════════════════════════════════════");

    if (D.envType.isDevelopmentWithPrint) {
      print("$red$message$reset");
    } else {
      log(message.toString(), name: "LOG || API ERROR ✖");
    }

    return super.onError(err, handler);
  }

  /// Indent multiline JSON nicely inside box
  String _indent(String text) {
    return text.split('\n').map((e) => "║   $e").join('\n');
  }
}