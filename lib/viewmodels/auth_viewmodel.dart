import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/network/api_exception.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthViewModel extends ChangeNotifier {
  AuthViewModel(this._service);

  final AuthService _service;
  static const _userKey = 'logged_in_user';

  bool _isLoading = false;
  String? _error;
  UserModel? _user;
  String? _pendingEmail; // email waiting for OTP verification

  bool get isLoading => _isLoading;
  String? get error => _error;
  UserModel? get user => _user;
  String? get pendingEmail => _pendingEmail;
  bool get isLoggedIn => _user != null;

  /// Call once at app start (splash screen).
  Future<void> restoreSession() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_userKey);
    if (raw != null) {
      _user = UserModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
      notifyListeners();
    }
  }

  /// Runs an action with loading/error handling. Returns true on success.
  Future<bool> _run(Future<void> Function() action) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await action();
      return true;
    } on ApiException catch (e) {
      _error = e.message;
      return false;
    } catch (_) {
      _error = 'Something went wrong. Please try again.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Register, then send the OTP to the same email.
  Future<bool> register({
    required String username,
    required String email,
    required String password,
  }) =>
      _run(() async {
        await _service.register(username: username, email: email, password: password);
        await _service.sendOtp(email);
        _pendingEmail = email;
      });

  Future<bool> verifyOtp(String otp) => _run(() async {
        await _service.verifyOtp(email: _pendingEmail ?? '', otp: otp);
      });

  Future<bool> resendOtp() => _run(() async {
        await _service.sendOtp(_pendingEmail ?? '');
      });

  Future<bool> login({required String email, required String password}) =>
      _run(() async {
        _user = await _service.login(email: email, password: password);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_userKey, jsonEncode(_user!.toJson()));
      });

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    _user = null;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
