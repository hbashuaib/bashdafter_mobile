import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/reports_service.dart';
import '../models/recent_transaction_model.dart';
import '../../../core/widgets/app_loading_scaffold.dart';
import '../../../core/widgets/app_refreshable_empty_state.dart';
import '../../../core/localization/localization_extension.dart';
import '../../../core/localization/app_formatters.dart';
import '../../../core/providers/shop_provider.dart';
import '../../../core/widgets/app_search_field.dart';

class RecentTransactionsScreen extends StatefulWidget {
  const RecentTransactionsScreen({super.key});

  @override
  State<RecentTransactionsScreen> createState() =>
      _RecentTransactionsScreenState();
}

class _RecentTransactionsScreenState extends State<RecentTransactionsScreen> {
  final searchController = TextEditingController();
  List<RecentTransactionModel> transactions = [];
  List<RecentTransactionModel> filteredTransactions = [];
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
        SnackBar(content: Text(context.l10n.failedToLoadTransactions)),
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
        final customer = item.customer.toLowerCase();
        final type = item.type.toLowerCase();
        final date = item.date.toLowerCase();
        final amount = item.amount.toString().toLowerCase();

        return customer.contains(query) ||
            type.contains(query) ||
            date.contains(query) ||
            amount.contains(query);
      }).toList();
    });
  }

  String getTransactionTypeLabel(String type) {
    switch (type.toLowerCase()) {
      case 'purchase':
        return context.l10n.purchase;

      case 'payment':
        return context.l10n.payment;

      default:
        return type;
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  int get purchaseCount =>
      transactions.where((t) => t.type.toLowerCase() == 'purchase').length;

  int get paymentCount =>
      transactions.where((t) => t.type.toLowerCase() == 'payment').length;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return AppLoadingScaffold(
        message: context.l10n.loadingRecentTransactions,
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.recentTransactions)),

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
                      Text(context.l10n.transactions),

                      Text(
                        // transactions.length.toString(),
                        AppFormatters.number(context, transactions.length),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),

                  Column(
                    children: [
                      Text(context.l10n.purchases),

                      Text(
                        AppFormatters.number(context, purchaseCount),

                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  Column(
                    children: [
                      Text(context.l10n.payments),

                      Text(
                        AppFormatters.number(context, paymentCount),

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

            child: AppSearchField(
              controller: searchController,
              hintText: context.l10n.searchTransactions,

              onChanged: searchTransactions,

              onClear: () {
                searchController.clear();
                searchTransactions('');
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(12),

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
                    message: context.l10n.noTransactionsFound,
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
                        final purchase = item.type.toLowerCase() == 'purchase';

                        return Card(
                          child: ListTile(
                            title: Text(
                              item.customer.isEmpty
                                  ? context.l10n.unknownCustomer
                                  : item.customer,
                            ),

                            subtitle: Text(
                              '${getTransactionTypeLabel(item.type)} • '
                              '${AppFormatters.date(context, DateTime.parse(item.date))}',
                            ),

                            trailing: Text(
                              '${purchase ? '+' : '-'}'
                              '${AppFormatters.currency(context, item.amount.toDouble(), context.read<ShopProvider>().currency)}',

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
