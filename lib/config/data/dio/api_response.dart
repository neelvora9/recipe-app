

import 'package:myapp/core/extensions/safe_parser_ext.dart';

class ApiResponse<T> {
  final bool status;
  final bool error;
  final String? message;
  final T? data;
  final dynamic rawData;

  ApiResponse({
    this.status = false,
    this.error = true,
    this.message ,
    this.data,
    this.rawData,
  });

  factory ApiResponse.fromJson(
      Map<String, Object?> json, [
        T Function(dynamic data)? fromJsonT,
        String? key,
      ]) {
    T? parsedData;

    if (json[key ?? 'data'] != null && fromJsonT != null) {
      parsedData = fromJsonT(json[key ?? 'data']);
    }

    return ApiResponse<T>(
      status: json['status'].toBoolOrNull() ?? json['success'].toBool(),
      error: json['error'].toBool(),
      message: json['message'].toStr(),
      data: parsedData,
      rawData: json,
    );
  }

  Map<String, dynamic> toJson([Map<String, dynamic> Function(T)? toJsonT]) {
    return {
      'status': status,
      'message': message,
      'data': data != null && toJsonT != null ? toJsonT(data as T) : data,
    };
  }
}
