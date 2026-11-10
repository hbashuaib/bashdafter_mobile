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
  List<dynamic> filteredTransactions = [];
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
        filteredTransactions = data;
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

  void searchTransactions(String value) {
    final query = value.toLowerCase();

    setState(() {
      filteredTransactions = transactions.where((item) {
        final customer = item['customer'].toString().toLowerCase();
        final type = item['type'].toString().toLowerCase();
        final date = item['date'].toString().toLowerCase();
        final amount = item['amount'].toString().toLowerCase();

        return customer.contains(query) ||
            type.contains(query) ||
            date.contains(query) ||
            amount.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recent Transactions')),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Card(
                  margin: const EdgeInsets.all(12),

                  child: Padding(
                    padding: const EdgeInsets.all(12),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,

                      children: [
                        Column(
                          children: [
                            const Text('Transactions'),

                            Text(
                              transactions.length.toString(),

                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        Column(
                          children: [
                            const Text('Purchases'),

                            Text(
                              transactions
                                  .where((t) => t['type'] == 'purchase')
                                  .length
                                  .toString(),

                              style: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        Column(
                          children: [
                            const Text('Payments'),

                            Text(
                              transactions
                                  .where((t) => t['type'] == 'payment')
                                  .length
                                  .toString(),

                              style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(12),

                  child: TextField(
                    onChanged: searchTransactions,

                    decoration: const InputDecoration(
                      hintText: 'Search transactions',

                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),

                Center(
                  child: Text(
                    'Showing ${filteredTransactions.length} of ${transactions.length} transactions',

                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),

                Expanded(
                  child: transactions.isEmpty
                      ? ListView(
                          children: const [
                            SizedBox(height: 150),

                            Center(child: Text('No transactions found')),
                          ],
                        )
                      : RefreshIndicator(
                          onRefresh: loadData,

                          child: ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.only(bottom: 20),
                            itemCount: filteredTransactions.length,

                            itemBuilder: (context, index) {
                              final item = filteredTransactions[index];
                              final purchase = item['type'] == 'purchase';

                              return Card(
                                child: ListTile(
                                  title: Text(
                                    item['customer']?.toString() ??
                                        'Unknown Customer',
                                  ),

                                  subtitle: Text(
                                    '${item['type'].toString().toUpperCase()} • ${item['date']}',
                                  ),

                                  trailing: Text(
                                    '${purchase ? '+' : '-'}YER ${currencyFormatter.format(double.tryParse(item['amount'].toString()) ?? 0)}',

                                    style: TextStyle(
                                      color: purchase
                                          ? Colors.red
                                          : Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                ),
              ],
            ),
    );
  }
}
