import 'package:flutter/material.dart';

import '../services/inventory_transaction_service.dart';
import '../../../core/widgets/app_loading_scaffold.dart';
import '../../../core/widgets/app_refreshable_empty_state.dart';

class InventoryHistoryScreen extends StatefulWidget {
  const InventoryHistoryScreen({super.key});

  @override
  State<InventoryHistoryScreen> createState() => _InventoryHistoryScreenState();
}

class _InventoryHistoryScreenState extends State<InventoryHistoryScreen> {
  final searchController = TextEditingController();
  List<dynamic> transactions = [];
  List<dynamic> filteredTransactions = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadTransactions();
  }

  Future<void> loadTransactions() async {
    try {
      final data = await InventoryTransactionService().getTransactions();

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
        const SnackBar(content: Text('Failed to load inventory history')),
      );

      setState(() {
        isLoading = false;
      });
    }
  }

  Color getTransactionColor(String transactionType) {
    switch (transactionType) {
      case 'OPENING':
        return Colors.blue;

      case 'IN':
        return Colors.green;

      case 'SALE':
      case 'OUT':
        return Colors.orange;

      case 'DAMAGE':
        return Colors.red;

      case 'CORRECTION':
        return Colors.purple;

      default:
        return Colors.grey;
    }
  }

  void searchTransactions(String value) {
    final query = value.toLowerCase().trim();

    setState(() {
      filteredTransactions = transactions.where((tx) {
        final product = (tx['product_name'] ?? '').toString().toLowerCase();
        final type = (tx['transaction_type'] ?? '').toString().toLowerCase();
        final reference = (tx['reference'] ?? '').toString().toLowerCase();

        return product.contains(query) ||
            type.contains(query) ||
            reference.contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const AppLoadingScaffold(message: 'Loading inventory history...');
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Inventory History')),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),

            child: TextField(
              controller: searchController,
              onChanged: (value) {
                searchTransactions(value);

                if (mounted) {
                  setState(() {});
                }
              },

              decoration: InputDecoration(
                hintText: 'Search product, type or reference',
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
            padding: const EdgeInsets.symmetric(horizontal: 12),

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
                    message: 'No inventory transactions found',
                    icon: Icons.history,
                    onRefresh: loadTransactions,
                  )
                : RefreshIndicator(
                    onRefresh: loadTransactions,

                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.only(bottom: 100),
                      itemCount: filteredTransactions.length,

                      itemBuilder: (context, index) {
                        final transaction = filteredTransactions[index];

                        final quantity =
                            double.tryParse(
                              transaction['quantity'].toString(),
                            ) ??
                            0;

                        final color = getTransactionColor(
                          transaction['transaction_type'],
                        );

                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),

                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: color,

                              child: Text(
                                transaction['transaction_type']
                                            ?.toString()
                                            .isNotEmpty ==
                                        true
                                    ? transaction['transaction_type']
                                          .toString()
                                          .substring(0, 1)
                                    : '?',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),

                            title: Text(
                              transaction['product_name']?.toString() ??
                                  'Unknown Product',
                            ),
                            subtitle: Text(
                              (transaction['reference'] ?? '')
                                      .toString()
                                      .trim()
                                      .isEmpty
                                  ? '-'
                                  : transaction['reference'].toString(),
                            ),

                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,

                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),

                                  decoration: BoxDecoration(
                                    color: color.withValues(alpha: 0.15),

                                    borderRadius: BorderRadius.circular(10),
                                  ),

                                  child: Text(
                                    transaction['transaction_type'].toString(),

                                    style: TextStyle(
                                      color: color,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),

                                Text(quantity.toStringAsFixed(0)),
                              ],
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
