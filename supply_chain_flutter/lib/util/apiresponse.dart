

class ApiResponse {
  String? message;
  Map<String, dynamic>? data;
  bool success;

  ApiResponse({
    this.message,
    this.data,
    this.success = false,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      message: json['message'] as String?,
      data: json['data'] as Map<String, dynamic>?,
      success: json['success'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': data,
      'success': success,
    };
  }

  void setData(String key, dynamic value) {
    data ??= <String, dynamic>{};
    data![key] = value;
  }
}
