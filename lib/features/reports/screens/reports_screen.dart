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
            color: Colors.blue.shade50,

            child: const Padding(
              padding: EdgeInsets.all(16),

              child: Column(
                children: [
                  Text(
                    'Reports Center',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  SizedBox(height: 8),

                  Text('Customer and financial reports'),
                ],
              ),
            ),
          ),

          Card(
            elevation: 1,
            child: ListTile(
              leading: const Icon(Icons.people, color: Colors.blue),
              title: const Text('Customer Summary'),
              trailing: const Icon(Icons.arrow_forward_ios),
              subtitle: const Text('Customer balances and accounts'),

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
            elevation: 1,
            child: ListTile(
              leading: const Icon(
                Icons.account_balance_wallet,
                color: Colors.orange,
              ),
              title: const Text('Top Debtors'),
              trailing: const Icon(Icons.arrow_forward_ios),
              subtitle: const Text('Customers with highest balances'),

              onTap: () {
                Navigator.push(
                  context,

                  MaterialPageRoute(builder: (_) => const TopDebtorsScreen()),
                );
              },
            ),
          ),

          Card(
            elevation: 1,
            child: ListTile(
              leading: const Icon(Icons.history, color: Colors.green),
              title: const Text('Recent Transactions'),
              trailing: const Icon(Icons.arrow_forward_ios),
              subtitle: const Text('Latest purchases and payments'),

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

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
