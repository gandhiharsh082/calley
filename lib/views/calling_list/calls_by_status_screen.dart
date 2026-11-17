import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/dashboard_viewmodel.dart';
import '../../widgets/call_tile.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/screen_header.dart';

/// Shows the calls of the selected list that have the given status.
/// Used for "Call Log" (status: called) and "Schedule" (status: rescheduled).
class CallsByStatusScreen extends StatelessWidget {
  final String title;
  final String status;

  const CallsByStatusScreen({super.key, required this.title, required this.status});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DashboardViewModel>();
    final calls = vm.details?.calls
            .where((c) => c.raw['status']?.toString() == status)
            .toList() ??
        [];

    Widget body;
    if (vm.isLoading && vm.details == null) {
      body = const LoadingWidget();
    } else if (calls.isEmpty) {
      body = Center(child: Text('No ${title.toLowerCase()} entries yet'));
    } else {
      body = ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: calls.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (_, i) => CallTile(call: calls[i]),
      );
    }

    return SafeArea(
      child: Column(
        children: [
          ScreenHeader(title: title),
          Expanded(child: body),
        ],
      ),
    );
  }
}
