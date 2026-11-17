import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../services/reports_service.dart';
import '../../../core/widgets/app_loading_scaffold.dart';
import '../../../core/widgets/app_refreshable_empty_state.dart';

class RecentTransactionsScreen extends StatefulWidget {
  const RecentTransactionsScreen({super.key});

  @override
  State<RecentTransactionsScreen> createState() =>
      _RecentTransactionsScreenState();
}

class _RecentTransactionsScreenState extends State<RecentTransactionsScreen> {
  final currencyFormatter = NumberFormat('#,##0.00');
  final searchController = TextEditingController();
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
    final query = value.toLowerCase().trim();

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
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  int get purchaseCount =>
      transactions.where((t) => t['type'] == 'purchase').length;

  int get paymentCount =>
      transactions.where((t) => t['type'] == 'payment').length;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const AppLoadingScaffold(
        message: 'Loading recent transactions...',
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Recent Transactions')),

      body: Column(
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

                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),

                  Column(
                    children: [
                      const Text('Purchases'),

                      Text(
                        purchaseCount.toString(),

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
                        paymentCount.toString(),

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
              controller: searchController,

              onChanged: (value) {
                searchTransactions(value);
                setState(() {});
              },

              decoration: InputDecoration(
                hintText: 'Search transactions',

                prefixIcon: const Icon(Icons.search),

                suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),

                        onPressed: () {
                          searchController.clear();
                          searchTransactions('');
                          setState(() {});
                        },
                      )
                    : null,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(12),

            child: Center(
              child: Text(
                'Showing ${filteredTransactions.length} of ${transactions.length} transactions',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),

          Expanded(
            child: filteredTransactions.isEmpty
                ? AppRefreshableEmptyState(
                    message: 'No transactions found',
                    icon: Icons.receipt_long_outlined,
                    onRefresh: loadData,
                  )
                : RefreshIndicator(
                    onRefresh: loadData,

                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.only(bottom: 100),
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
                                color: purchase ? Colors.red : Colors.green,
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
