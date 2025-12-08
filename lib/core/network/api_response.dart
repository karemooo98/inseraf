import 'package:dio/dio.dart';

class ApiResponse<T> {
  const ApiResponse({
    required this.success,
    this.data,
    this.message,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse<T>(
      success: json['success'] as bool? ?? true,
      data: json['data'] as T?,
      message: json['message']?.toString(),
    );
  }

  factory ApiResponse.fromResponse(Response<dynamic> response) {
    final dynamic body = response.data;
    if (body is Map<String, dynamic>) {
      return ApiResponse<T>(
        success: body['success'] as bool? ?? true,
        data: body['data'] as T?,
        message: body['message']?.toString(),
      );
    }
    return ApiResponse<T>(success: true, data: body as T?);
  }

  final bool success;
  final T? data;
  final String? message;
}

