import 'package:flutter/material.dart';

import '../services/inventory_transaction_service.dart';
import '../../../core/widgets/app_loading_scaffold.dart';
import '../../../core/widgets/app_refreshable_empty_state.dart';
import '../../../core/localization/localization_extension.dart';
import '../../../core/localization/app_formatters.dart';

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
        SnackBar(content: Text(context.l10n.failedToLoadInventoryHistory)),
      );

      setState(() {
        isLoading = false;
      });
    }
  }

  String getTransactionLabel(String type) {
    switch (type) {
      case 'OPENING':
        return context.l10n.transactionOpening;

      case 'IN':
        return context.l10n.transactionIn;

      case 'OUT':
        return context.l10n.transactionOut;

      case 'SALE':
        return context.l10n.transactionSale;

      case 'DAMAGE':
        return context.l10n.transactionDamage;

      case 'CORRECTION':
        return context.l10n.transactionCorrection;

      default:
        return type;
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
      return AppLoadingScaffold(message: context.l10n.loadingInventoryHistory);
    }

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.inventoryHistory)),

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
                hintText: context.l10n.searchInventoryHistory,
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
                '${context.l10n.showing} '
                '${AppFormatters.number(context, filteredTransactions.length)} '
                '${context.l10n.outOf} '
                '${AppFormatters.number(context, transactions.length)} '
                '${context.l10n.transactions}',

                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),

          Expanded(
            child: filteredTransactions.isEmpty
                ? AppRefreshableEmptyState(
                    message: context.l10n.noInventoryTransactionsFound,
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

                        final transactionType =
                            transaction['transaction_type']?.toString() ?? '';

                        final color = getTransactionColor(transactionType);

                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),

                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: color,

                              child: Text(
                                transactionType.isNotEmpty
                                    ? transactionType.substring(0, 1)
                                    : '?',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),

                            title: Text(
                              transaction['product_name']?.toString() ??
                                  context.l10n.unknownProduct,
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
                                    getTransactionLabel(transactionType),

                                    style: TextStyle(
                                      color: color,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),

                                Text(
                                  // quantity.toStringAsFixed(0)
                                  AppFormatters.number(context, quantity),
                                ),
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
