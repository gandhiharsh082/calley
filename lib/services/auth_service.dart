import 'package:dio/dio.dart';

import '../core/constants/api_constants.dart';
import '../core/network/api_exception.dart';
import '../core/network/dio_client.dart';
import '../models/user_model.dart';

class AuthService {
  final Dio _dio = DioClient.instance.dio;

  Future<void> register({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      await _dio.post(ApiConstants.register, data: {
        'username': username,
        'email': email,
        'password': password,
      });
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// NOTE: request body for send-otp was cut off in the docs screenshot.
  /// Assumed to be {"email": ...}. Verify and adjust.
  Future<void> sendOtp(String email) async {
    try {
      await _dio.post(ApiConstants.sendOtp, data: {'email': email});
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<void> verifyOtp({required String email, required String otp}) async {
    try {
      await _dio.post(ApiConstants.verifyOtp, data: {'email': email, 'otp': otp});
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final res = await _dio.post(ApiConstants.login, data: {
        'email': email,
        'password': password,
      });
      return UserModel.fromJson(Map<String, dynamic>.from(res.data['user']));
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}
