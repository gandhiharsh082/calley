import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';

/// Top row used by the tab screens: menu button (opens drawer) + title.
class ScreenHeader extends StatelessWidget {
  final String title;
  final List<Widget> actions;

  const ScreenHeader({super.key, required this.title, this.actions = const []});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.menu, color: AppColors.textPrimary),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const Spacer(),
          ...actions,
        ],
      ),
    );
  }
}
