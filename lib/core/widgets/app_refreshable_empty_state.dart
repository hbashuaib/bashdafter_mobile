import 'package:flutter/material.dart';

import 'app_empty_state.dart';

class AppRefreshableEmptyState extends StatelessWidget {
  final String message;
  final IconData icon;
  final Future<void> Function() onRefresh;

  const AppRefreshableEmptyState({
    super.key,
    required this.message,
    required this.onRefresh,
    this.icon = Icons.inbox_outlined,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,

      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),

        children: [
          const SizedBox(height: 120),

          AppEmptyState(message: message, icon: icon),
        ],
      ),
    );
  }
}
