 

import 'dart:io';

import 'package:myapp/core/helper/global_prefs.dart';
import 'package:dio/dio.dart';
import 'package:layer_kit/layer_kit.dart';
import '../../config/data/dio/dio_error_response.dart';
import '../utils/devlog.dart';

class ApiErrorHandler {
  static Future<String> getMessage(error) async {
    String? errorMessage;
    if (error is Exception) {
      try {
        if (error is DioException) {
          switch (error.type) {
            case DioExceptionType.cancel:
              errorMessage = "Request to API server was cancelled";
              break;
            case DioExceptionType.connectionTimeout:
              errorMessage = "Connection timeout with API server";
              break;
            case DioExceptionType.unknown:
              errorMessage =
                  "Connection to API server failed due to internet connection";
              break;
            case DioExceptionType.receiveTimeout:
              errorMessage = "Receive timeout in connection with API server";
              break;
            case DioExceptionType.connectionError:
              errorMessage = "Connection error with API server";
              break;
            case DioExceptionType.badCertificate:
              errorMessage = "Bad certificate from API server";
              break;
            case DioExceptionType.badResponse:
              switch (error.response!.statusCode) {
                case 404:
                  errorMessage = 'Resource not found.';
                  break;
                case 500:
                  errorMessage =
                      'Internal server error. Please try again later.';
                  break;
                case 401:
                  errorMessage =
                      'Unauthorized access. Please check your credentials.';
                  // TODO :  CLEAR SHARED_PREFS DATA AS PER YOUR NEED
                  GlobalPrefs.logout();
                  // AppRouter.context.pushReplacementNamed(LoginScreen());
                  break;
                case 503:
                  errorMessage = "Can't connect to server. Try again later.";
                  break;
                default:
                  DioErrorResponse errorResponse =
                      DioErrorResponse.fromJson(error.response?.data ?? {});
                  if (errorResponse.errors.isNotEmpty) {
                    errorMessage = errorResponse.errors.first.message;
                  } else {
                    errorMessage =
                        "Failed to load data - status code: ${error.response!.statusCode}";
                  }
              }
              break;
            case DioExceptionType.sendTimeout:
              errorMessage = "Send timeout with server";
              break;
          }
        } else if (error is FormatException) {
          errorMessage = "Data format error. Please try again.";
        } else if (error is SocketException) {
          errorMessage =
              "Network error. Please check your internet connection and try again.";
        } else {
          errorMessage = "Unexpected error occurred. Please try again.";
        }
      } on FormatException catch (e) {
        errorMessage = "Data format error: ${e.message}";
      }
    } else {
      devlogError("ERROR : $error");
      errorMessage = "Something went wrong.!";
    }
    return errorMessage;
  }
}
