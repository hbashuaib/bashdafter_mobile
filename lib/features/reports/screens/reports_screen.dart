import 'package:flutter/material.dart';

import 'customer_summary_screen.dart';
import 'top_debtors_screen.dart';
import 'recent_transactions_screen.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reports')),

      body: ListView(
        padding: const EdgeInsets.all(20),

        children: [
          Card(
            child: ListTile(
              title: const Text('Customer Summary'),

              trailing: const Icon(Icons.arrow_forward_ios),

              onTap: () {
                Navigator.push(
                  context,

                  MaterialPageRoute(
                    builder: (_) => const CustomerSummaryScreen(),
                  ),
                );
              },
            ),
          ),

          Card(
            child: ListTile(
              title: const Text('Top Debtors'),

              trailing: const Icon(Icons.arrow_forward_ios),

              onTap: () {
                Navigator.push(
                  context,

                  MaterialPageRoute(builder: (_) => const TopDebtorsScreen()),
                );
              },
            ),
          ),

          Card(
            child: ListTile(
              title: const Text('Recent Transactions'),

              trailing: const Icon(Icons.arrow_forward_ios),

              onTap: () {
                Navigator.push(
                  context,

                  MaterialPageRoute(
                    builder: (_) => const RecentTransactionsScreen(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
