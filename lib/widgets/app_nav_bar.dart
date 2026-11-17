import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';

/// Bottom bar from the Figma: 4 icons + a highlighted center "play" button.
/// The center button is an action (Start Calling), not a tab.
class AppNavBar extends StatelessWidget {
  final int currentIndex; // 0 Home, 1 Lists, 2 Call Log, 3 Schedule
  final ValueChanged<int> onTab;
  final VoidCallback onStart;

  const AppNavBar({
    super.key,
    required this.currentIndex,
    required this.onTab,
    required this.onStart,
  });

  Widget _item(int index, IconData icon, String tooltip) {
    final selected = index == currentIndex;
    return IconButton(
      tooltip: tooltip,
      onPressed: () => onTab(index),
      icon: Icon(
        icon,
        size: 26,
        color: selected ? AppColors.primary : AppColors.textPrimary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF1F6FF),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border.all(color: AppColors.primary.withAlpha(90)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _item(0, Icons.home_outlined, 'Home'),
              _item(1, Icons.badge_outlined, 'Lists'),
              Tooltip(
                message: 'Start Calling',
                child: Material(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(24),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(24),
                    onTap: onStart,
                    child: const SizedBox(
                      width: 80,
                      height: 48,
                      child: Icon(Icons.play_arrow_outlined, color: Colors.white, size: 30),
                    ),
                  ),
                ),
              ),
              _item(2, Icons.phone_callback_outlined, 'Call Log'),
              _item(3, Icons.calendar_month_outlined, 'Schedule'),
            ],
          ),
        ),
      ),
    );
  }
}
