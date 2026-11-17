import 'package:flutter/material.dart';

import '../../views/auth/language_screen.dart';
import '../../views/auth/login_screen.dart';
import '../../views/auth/otp_screen.dart';
import '../../views/auth/signup_screen.dart';
import '../../views/dashboard/dashboard_screen.dart';
import '../../views/splash/splash_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String language = '/language';
  static const String signup = '/signup';
  static const String otp = '/otp';
  static const String login = '/login';
  static const String dashboard = '/dashboard';
}

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final Widget page;
    switch (settings.name) {
      case AppRoutes.language:
        page = const LanguageScreen();
        break;
      case AppRoutes.signup:
        page = const SignupScreen();
        break;
      case AppRoutes.otp:
        page = const OtpScreen();
        break;
      case AppRoutes.login:
        page = const LoginScreen();
        break;
      case AppRoutes.dashboard:
        page = const DashboardScreen();
        break;
      default:
        page = const SplashScreen();
    }
    return MaterialPageRoute(builder: (_) => page, settings: settings);
  }
}
