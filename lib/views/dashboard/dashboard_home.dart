import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/utils/text_utils.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/dashboard_viewmodel.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/screen_header.dart';
import '../calling_list/calling_list_detail_screen.dart';

class DashboardHome extends StatelessWidget {
  const DashboardHome({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthViewModel>();
    final vm = context.watch<DashboardViewModel>();
    final userId = auth.user?.id ?? '';

    return SafeArea(
      child: Column(
        children: [
          const ScreenHeader(title: 'Dashboard'),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => vm.load(userId),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                children: [
                  // _ProfileCard(name: auth.user?.username ?? ''),
                  const SizedBox(height: 16),
                  if (vm.isLoading && vm.lists.isEmpty)
                    const SizedBox(height: 200, child: LoadingWidget())
                  else if (vm.error != null && vm.lists.isEmpty)
                    _MessageCard(
                      icon: Icons.error_outline,
                      text: vm.error!,
                      actionLabel: 'Retry',
                      onAction: () => vm.load(userId),
                    )
                  else if (vm.lists.isEmpty)
                    const _MessageCard(
                      icon: Icons.upload_file_outlined,
                      text:
                          'LOAD NUMBER TO CALL\n\nVisit https://app.getcalley.com to upload the numbers you wish to call, then pull down to refresh.',
                    )
                  else ...[
                    if (vm.isLoading) const LinearProgressIndicator(),
                    _ListSelector(vm: vm, userId: userId),
                    const SizedBox(height: 16),
                    _StatsCard(vm: vm),
                    const SizedBox(height: 16),
                    CustomButton(
                      text: 'Start Calling Now',
                      onPressed: vm.selected == null
                          ? null
                          : () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => CallingListDetailScreen(list: vm.selected!),
                                ),
                              ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final String name;
  const _ProfileCard({required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: Colors.white,
            child: Text(initialOf(name),
                style: const TextStyle(
                    color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 20)),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Hello $name', style: const TextStyle(color: Colors.white70, fontSize: 12)),
              const Text('Welcome to Calley!',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
            ],
          ),
        ],
      ),
    );
  }
}

class _ListSelector extends StatelessWidget {
  final DashboardViewModel vm;
  final String userId;
  const _ListSelector({required this.vm, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Select Calling List',
                    style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                DropdownButtonHideUnderline(
                  child: DropdownButton(
                    isExpanded: true,
                    value: vm.selected,
                    items: vm.lists
                        .map((l) => DropdownMenuItem(value: l, child: Text(l.name)))
                        .toList(),
                    onChanged: (l) {
                      if (l != null) vm.selectList(l);
                    },
                  ),
                ),
              ],
            ),
          ),
          TextButton.icon(
            onPressed: vm.isLoading ? null : () => vm.load(userId),
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text('Refresh'),
          ),
        ],
      ),
    );
  }
}

class _StatsCard extends StatelessWidget {
  final DashboardViewModel vm;
  const _StatsCard({required this.vm});

  @override
  Widget build(BuildContext context) {
    final d = vm.details;
    final pending = d?.pending ?? 0;
    final done = d?.called ?? 0;
    final scheduled = d?.rescheduled ?? 0;
    final total = vm.total;

    PieChartSectionData section(int value, Color color) => PieChartSectionData(
          value: value.toDouble(),
          color: color,
          radius: 26,
          showTitle: false,
        );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(15), blurRadius: 12)],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(vm.selected?.name ?? '',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              ),
              Text('$total CALLS',
                  style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.primary)),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    startDegreeOffset: -90,
                    centerSpaceRadius: 62,
                    sectionsSpace: total == 0 ? 0 : 3,
                    sections: total == 0
                        ? [section(1, AppColors.border)]
                        : [
                            section(done, AppColors.done),
                            section(pending, AppColors.pending),
                            section(scheduled, AppColors.scheduled),
                          ],
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('$total',
                        style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
                    const Text('Total calls',
                        style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _StatTile(label: 'Pending', count: pending, color: AppColors.pending),
              const SizedBox(width: 8),
              _StatTile(label: 'Done', count: done, color: AppColors.done),
              const SizedBox(width: 8),
              _StatTile(label: 'Schedule', count: scheduled, color: AppColors.scheduled),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  const _StatTile({required this.label, required this.count, required this.color});

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
            const SizedBox(height: 2),
            Text('$count', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            const Text('Calls', style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}

class _MessageCard extends StatelessWidget {
  final IconData icon;
  final String text;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _MessageCard({required this.icon, required this.text, this.actionLabel, this.onAction});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Icon(icon, size: 40, color: AppColors.primary),
          const SizedBox(height: 12),
          Text(text, textAlign: TextAlign.center, style: const TextStyle(fontSize: 13)),
          if (actionLabel != null) ...[
            const SizedBox(height: 12),
            TextButton(onPressed: onAction, child: Text(actionLabel!)),
          ],
        ],
      ),
    );
  }
}
