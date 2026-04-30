

class DioErrorResponse {
  final List<DioErrorDetail> errors;

  DioErrorResponse({required this.errors});

  factory DioErrorResponse.fromJson(Map<String, dynamic> json) {
    var errorsJson = json['errors'] as List<dynamic>?;
    var errors = errorsJson != null
        ? errorsJson.map((e) => DioErrorDetail.fromJson(e)).toList()
        : <DioErrorDetail>[];
    return DioErrorResponse(errors: errors);
  }
}

class DioErrorDetail {
  final String message;

  DioErrorDetail({required this.message});

  factory DioErrorDetail.fromJson(Map<String, dynamic> json) {
    return DioErrorDetail(message: json['message']);
  }
}
