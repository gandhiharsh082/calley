import 'package:dio/dio.dart';

/// One place that turns Dio errors into messages the UI can show.
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  factory ApiException.fromDio(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException('Request timed out. Please try again.');
      case DioExceptionType.connectionError:
        return ApiException('No internet connection.');
      case DioExceptionType.badResponse:
        final data = e.response?.data;
        final msg = (data is Map && data['message'] != null)
            ? data['message'].toString()
            : 'Something went wrong (${e.response?.statusCode}).';
        return ApiException(msg, statusCode: e.response?.statusCode);
      default:
        return ApiException('Something went wrong. Please try again.');
    }
  }

  @override
  String toString() => message;
}
