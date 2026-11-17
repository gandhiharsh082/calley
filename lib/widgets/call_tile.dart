import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/utils/text_utils.dart';
import '../models/call_model.dart';

/// One row in a list of calls (used by the list detail, call log and schedule).
class CallTile extends StatelessWidget {
  final CallModel call;
  const CallTile({super.key, required this.call});

  @override
  Widget build(BuildContext context) {
    final name = call.fullName.isEmpty ? 'Unknown' : call.fullName;
    final status = call.raw['status']?.toString();
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.primary.withAlpha(30),
            child: Text(initialOf(call.firstName.isEmpty ? name : call.firstName),
                style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
                Text(call.phone,
                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                if (call.otherPhone1.isNotEmpty)
                  Text(call.otherPhone1,
                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ),
          if (status != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary.withAlpha(25),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(status,
                  style: const TextStyle(
                      fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.w600)),
            ),
        ],
      ),
    );
  }
}
