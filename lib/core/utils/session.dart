import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/dashboard_viewmodel.dart';
import '../routes/app_router.dart';

/// Clears all user state and returns to the login screen.
Future<void> performLogout(BuildContext context) async {
  final auth = context.read<AuthViewModel>();
  final dashboard = context.read<DashboardViewModel>();
  final navigator = Navigator.of(context, rootNavigator: true);
  dashboard.clear();
  await auth.logout();
  navigator.pushNamedAndRemoveUntil(AppRoutes.login, (r) => false);
}
