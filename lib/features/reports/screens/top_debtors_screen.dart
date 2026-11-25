import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/reports_service.dart';
import '../models/top_debtor_model.dart';
import '../../../core/widgets/app_loading_scaffold.dart';
import '../../../core/widgets/app_refreshable_empty_state.dart';
import '../../../core/localization/localization_extension.dart';
import '../../../core/localization/app_formatters.dart';
import '../../../core/providers/shop_provider.dart';
import '../../../core/widgets/app_search_field.dart';

class TopDebtorsScreen extends StatefulWidget {
  const TopDebtorsScreen({super.key});

  @override
  State<TopDebtorsScreen> createState() => _TopDebtorsScreenState();
}

class _TopDebtorsScreenState extends State<TopDebtorsScreen> {
  final searchController = TextEditingController();
  List<TopDebtorModel> debtors = [];
  List<TopDebtorModel> filteredDebtors = [];
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

      final data = await ReportsService().getTopDebtors();

      if (!mounted) return;

      setState(() {
        debtors = data;
        filteredDebtors = data;
        isLoading = false;
      });
    } catch (e) {
      debugPrint(e.toString());

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.failedToLoadTopDebtors)),
      );

      setState(() {
        isLoading = false;
      });
    }
  }

  Color getRankColor(int rank) {
    if (rank == 1) {
      return Colors.amber;
    }

    if (rank == 2) {
      return Colors.grey;
    }

    if (rank == 3) {
      return Colors.orange;
    }

    return Colors.blue;
  }

  void searchDebtors(String value) {
    final query = value.toLowerCase().trim();

    setState(() {
      filteredDebtors = debtors.where((debtor) {
        final name = debtor.name.toLowerCase();
        final balance = debtor.balance.toString().toLowerCase();
        return name.contains(query) || balance.contains(query);
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
      return AppLoadingScaffold(message: context.l10n.loadingTopDebtors);
    }

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.topDebtors)),

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
                      Text(context.l10n.debtors),

                      Text(
                        // debtors.length.toString(),
                        AppFormatters.number(context, debtors.length),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),

                  Column(
                    children: [
                      Text(context.l10n.highestDebt),

                      Text(
                        debtors.isEmpty
                            ? AppFormatters.currency(
                                context,
                                0,
                                context.read<ShopProvider>().currency,
                              )
                            : AppFormatters.currency(
                                context,
                                debtors.first.balance.toDouble(),
                                context.read<ShopProvider>().currency,
                              ),

                        style: const TextStyle(fontWeight: FontWeight.bold),
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
              hintText: context.l10n.searchDebtor,

              onChanged: searchDebtors,

              onClear: () {
                searchController.clear();
                searchDebtors('');
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(12),

            child: Center(
              child: Text(
                '${context.l10n.showing} '
                '${AppFormatters.number(context, filteredDebtors.length)} '
                '${context.l10n.outOf} '
                '${AppFormatters.number(context, debtors.length)} '
                '${context.l10n.debtors}',

                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),

          Expanded(
            child: filteredDebtors.isEmpty
                ? AppRefreshableEmptyState(
                    message: context.l10n.noDebtorsFound,
                    icon: Icons.account_balance_wallet_outlined,
                    onRefresh: loadData,
                  )
                : RefreshIndicator(
                    onRefresh: loadData,

                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.only(bottom: 100),
                      itemCount: filteredDebtors.length,

                      itemBuilder: (context, index) {
                        final debtor = filteredDebtors[index];
                        final rank = debtor.rank;

                        final balance = debtor.balance.toDouble();

                        return Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: getRankColor(rank),

                              child: Text(
                                AppFormatters.number(context, rank),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            title: Text(
                              debtor.name.isEmpty
                                  ? context.l10n.unknownCustomer
                                  : debtor.name,
                            ),

                            trailing: Text(
                              // 'YER ${currencyFormatter.format(balance)}',
                              AppFormatters.currency(
                                context,
                                balance,
                                context.read<ShopProvider>().currency,
                              ),
                              style: const TextStyle(
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
