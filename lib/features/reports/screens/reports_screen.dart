import 'package:flutter/material.dart';

import 'customer_summary_screen.dart';
import 'top_debtors_screen.dart';
import 'recent_transactions_screen.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/localization/localization_extension.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.reports)),

      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),

        children: [
          Card(
            color: AppColors.cardTint(context, Colors.blue.shade50),

            child: Padding(
              padding: EdgeInsets.all(16),

              child: Column(
                children: [
                  Text(
                    context.l10n.reportsCenter,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  SizedBox(height: 8),

                  Text(context.l10n.customerAndFinancialReports),
                ],
              ),
            ),
          ),

          Card(
            elevation: 1,
            child: ListTile(
              leading: const Icon(Icons.people, color: Colors.blue),
              title: Text(context.l10n.customerSummary),
              trailing: const Icon(Icons.arrow_forward_ios),
              subtitle: Text(context.l10n.customerBalancesAndAccounts),

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
              title: Text(context.l10n.topDebtors),
              trailing: const Icon(Icons.arrow_forward_ios),
              subtitle: Text(context.l10n.customersWithHighestBalances),

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
              title: Text(context.l10n.recentTransactions),
              trailing: const Icon(Icons.arrow_forward_ios),
              subtitle: Text(context.l10n.latestPurchasesAndPayments),

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
