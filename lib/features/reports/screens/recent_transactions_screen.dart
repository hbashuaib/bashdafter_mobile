import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../services/reports_service.dart';

class RecentTransactionsScreen extends StatefulWidget {
  const RecentTransactionsScreen({super.key});

  @override
  State<RecentTransactionsScreen> createState() =>
      _RecentTransactionsScreenState();
}

class _RecentTransactionsScreenState extends State<RecentTransactionsScreen> {
  final currencyFormatter = NumberFormat('#,##0.00');
  List<dynamic> transactions = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      setState(() {
        isLoading = true;
      });

      final data = await ReportsService().getRecentTransactions();

      if (!mounted) return;

      setState(() {
        transactions = data;
        isLoading = false;
      });
    } catch (e) {
      debugPrint(e.toString());

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load transactions')),
      );

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recent Transactions')),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : transactions.isEmpty
          ? const Center(child: Text('No transactions found'))
          : RefreshIndicator(
              onRefresh: loadData,

              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 20),
                itemCount: transactions.length,

                itemBuilder: (context, index) {
                  final item = transactions[index];

                  final purchase = item['type'] == 'purchase';

                  return Card(
                    child: ListTile(
                      title: Text(
                        item['customer']?.toString() ?? 'Unknown Customer',
                      ),

                      subtitle: Text(
                        '${item['type'].toString().toUpperCase()} • ${item['date']}',
                      ),

                      trailing: Text(
                        '${purchase ? '+' : '-'}YER ${currencyFormatter.format(double.tryParse(item['amount'].toString()) ?? 0)}',

                        style: TextStyle(
                          color: purchase ? Colors.red : Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
