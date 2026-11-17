import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants/app_colors.dart';
import '../core/utils/session.dart';
import '../core/utils/text_utils.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/dashboard_viewmodel.dart';
import '../views/profile/profile_screen.dart';
import '../views/settings/settings_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  void _soon(BuildContext context) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Coming soon')));
  }

  /// Closes the drawer, then opens [page] as a full screen.
  void _open(BuildContext context, Widget page) {
    final navigator = Navigator.of(context);
    navigator.pop();
    navigator.push(MaterialPageRoute(builder: (_) => Scaffold(body: page)));
  }

  Widget _tile(IconData icon, String label, VoidCallback onTap) => ListTile(
        dense: true,
        leading: Icon(icon, size: 22, color: AppColors.textPrimary),
        title: Text(label, style: const TextStyle(fontSize: 14)),
        onTap: onTap,
      );

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthViewModel>().user;
    final name = user?.username ?? '';

    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            InkWell(
              onTap: () => _open(context, const ProfileScreen()),
              child: Container(
                padding: const EdgeInsets.all(16),
                color: AppColors.primary,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.white,
                      child: Text(initialOf(name),
                          style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                              fontSize: 18)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(name,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16)),
                          Text(user?.email ?? '',
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: Colors.white70, fontSize: 12)),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: Colors.white70),
                  ],
                ),
              ),
            ),
            _tile(Icons.rocket_launch_outlined, 'Getting Started', () => _soon(context)),
            _tile(Icons.sync, 'Sync Data', () {
              Navigator.pop(context);
              final id = context.read<AuthViewModel>().user?.id;
              if (id != null) context.read<DashboardViewModel>().load(id);
            }),
            _tile(Icons.emoji_events_outlined, 'Gamification', () => _soon(context)),
            _tile(Icons.description_outlined, 'Send Logs', () => _soon(context)),
            _tile(Icons.settings_outlined, 'Settings',
                () => _open(context, const SettingsScreen())),
            _tile(Icons.help_outline, 'Help', () => _soon(context)),
            _tile(Icons.cancel_outlined, 'Cancel Subscription', () => _soon(context)),
            const Divider(),
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Text('App Info',
                  style: TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary)),
            ),
            _tile(Icons.info_outline, 'About Us', () => _soon(context)),
            _tile(Icons.privacy_tip_outlined, 'Privacy Policy', () => _soon(context)),
            const ListTile(
              dense: true,
              leading: Icon(Icons.verified_outlined, size: 22, color: AppColors.textPrimary),
              title: Text('Version 1.0.0', style: TextStyle(fontSize: 14)),
            ),
            _tile(Icons.share_outlined, 'Share App', () => _soon(context)),
            _tile(Icons.logout, 'Logout', () {
              Navigator.pop(context);
              performLogout(context);
            }),
          ],
        ),
      ),
    );
  }
}
