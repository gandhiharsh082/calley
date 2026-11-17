import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/dashboard_viewmodel.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/screen_header.dart';
import 'calling_list_detail_screen.dart';

class CallingListScreen extends StatelessWidget {
  const CallingListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DashboardViewModel>();
    final userId = context.watch<AuthViewModel>().user?.id ?? '';

    Widget body;
    if (vm.isLoading && vm.lists.isEmpty) {
      body = const LoadingWidget();
    } else if (vm.error != null && vm.lists.isEmpty) {
      body = Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(vm.error!),
            TextButton(onPressed: () => vm.load(userId), child: const Text('Retry')),
          ],
        ),
      );
    } else if (vm.lists.isEmpty) {
      body = const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'No calling lists yet.\nUpload numbers from https://app.getcalley.com and refresh.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    } else {
      body = ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: vm.lists.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, i) {
          final list = vm.lists[i];
          final selected = list.id == vm.selected?.id;
          return InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              vm.selectList(list);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => CallingListDetailScreen(list: list)),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: selected ? AppColors.primary : AppColors.border,
                  width: selected ? 1.5 : 1,
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.list_alt, color: AppColors.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(list.name,
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                        Text('${list.agents.length} agents',
                            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: AppColors.textSecondary),
                ],
              ),
            ),
          );
        },
      );
    }

    return SafeArea(
      child: Column(
        children: [
          ScreenHeader(
            title: 'Calling Lists',
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: vm.isLoading ? null : () => vm.load(userId),
              ),
            ],
          ),
          Expanded(child: body),
        ],
      ),
    );
  }
}
