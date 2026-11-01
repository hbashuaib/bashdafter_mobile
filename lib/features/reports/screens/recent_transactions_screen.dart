import 'package:flutter/material.dart';

import '../services/reports_service.dart';

class RecentTransactionsScreen extends StatefulWidget {
  const RecentTransactionsScreen({super.key});

  @override
  State<RecentTransactionsScreen> createState() =>
      _RecentTransactionsScreenState();
}

class _RecentTransactionsScreenState extends State<RecentTransactionsScreen> {
  List<dynamic> transactions = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final data = await ReportsService().getRecentTransactions();

    setState(() {
      transactions = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recent Transactions')),

      body: transactions.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: transactions.length,

              itemBuilder: (context, index) {
                final item = transactions[index];

                final purchase = item['type'] == 'purchase';

                return Card(
                  child: ListTile(
                    title: Text(item['customer']),

                    subtitle: Text('${item['type']} • ${item['date']}'),

                    trailing: Text(
                      '${purchase ? '+' : '-'}${item['amount']}',

                      style: TextStyle(
                        color: purchase ? Colors.red : Colors.green,

                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
