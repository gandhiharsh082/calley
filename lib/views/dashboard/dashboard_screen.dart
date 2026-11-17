import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/dashboard_viewmodel.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/app_nav_bar.dart';
import '../calling_list/calling_list_detail_screen.dart';
import '../calling_list/calling_list_screen.dart';
import '../calling_list/calls_by_status_screen.dart';
import 'dashboard_home.dart';

/// Main shell: drawer + Figma-style bottom bar + four tabs.
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _index = 0;

  @override
  void initState() {
    super.initState();
    // Load after the first frame so notifyListeners() doesn't run during build.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = context.read<AuthViewModel>().user;
      if (user != null) context.read<DashboardViewModel>().load(user.id);
    });
  }

  void _startCalling() {
    final list = context.read<DashboardViewModel>().selected;
    if (list == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No calling list to start. Upload numbers first.')),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CallingListDetailScreen(list: list)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      body: IndexedStack(
        index: _index,
        children: const [
          DashboardHome(),
          CallingListScreen(),
          CallsByStatusScreen(title: 'Call Log', status: 'called'),
          CallsByStatusScreen(title: 'Schedule', status: 'rescheduled'),
        ],
      ),
      bottomNavigationBar: AppNavBar(
        currentIndex: _index,
        onTab: (i) => setState(() => _index = i),
        onStart: _startCalling,
      ),
    );
  }
}
