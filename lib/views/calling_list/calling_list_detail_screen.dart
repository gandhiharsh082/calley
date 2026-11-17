import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/utils/text_utils.dart';
import '../../models/call_model.dart';
import '../../models/calling_list_model.dart';
import '../../viewmodels/dashboard_viewmodel.dart';
import '../../widgets/loading_widget.dart';

class CallingListDetailScreen extends StatelessWidget {
  final CallingListModel list;

  const CallingListDetailScreen({super.key, required this.list});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DashboardViewModel>();
    final details = vm.details;

    Widget body;
    if (vm.isLoading) {
      body = const LoadingWidget();
    } else if (vm.error != null) {
      body = Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(vm.error!),
            TextButton(onPressed: () => vm.selectList(list), child: const Text('Retry')),
          ],
        ),
      );
    } else if (details == null) {
      body = const Center(child: Text('No data'));
    } else {
      body = Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _Summary(label: 'Pending', count: details.pending, color: AppColors.pending),
                const SizedBox(width: 8),
                _Summary(label: 'Done', count: details.called, color: AppColors.done),
                const SizedBox(width: 8),
                _Summary(label: 'Schedule', count: details.rescheduled, color: AppColors.scheduled),
              ],
            ),
          ),
          Expanded(
            child: details.calls.isEmpty
                ? const Center(child: Text('No calls in this list'))
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    itemCount: details.calls.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (_, i) => _CallTile(call: details.calls[i]),
                  ),
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(list.name)),
      body: body,
    );
  }
}

class _Summary extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  const _Summary({required this.label, required this.count, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: color.withAlpha(30),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(label, style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w600)),
            Text('$count', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          ],
        ),
      ),
    );
  }
}

class _CallTile extends StatelessWidget {
  final CallModel call;
  const _CallTile({required this.call});

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
