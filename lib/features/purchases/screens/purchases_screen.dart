import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../services/purchase_service.dart';
import '../models/purchase_model.dart';
import '../../../core/widgets/app_loading_scaffold.dart';
import '../../../core/widgets/app_refreshable_empty_state.dart';
import '../../../core/localization/localization_extension.dart';
import '../../../core/localization/app_formatters.dart';
import '../../../core/providers/shop_provider.dart';

import 'purchase_detail_screen.dart';

class PurchasesScreen extends StatefulWidget {
  final int customerId;

  const PurchasesScreen({super.key, required this.customerId});

  @override
  State<PurchasesScreen> createState() => _PurchasesScreenState();
}

class _PurchasesScreenState extends State<PurchasesScreen> {
  final currencyFormatter = NumberFormat('#,##0.00');
  final searchController = TextEditingController();
  List<PurchaseModel> purchases = [];
  List<PurchaseModel> filteredPurchases = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadPurchases();
  }

  Future<void> loadPurchases() async {
    try {
      final data = await PurchaseService().getPurchases();
      final customerPurchases = data
          .where((purchase) => purchase.customer == widget.customerId)
          .toList();

      if (!mounted) return;

      setState(() {
        purchases = customerPurchases;
        filteredPurchases = customerPurchases;
        isLoading = false;
      });
    } catch (e) {
      debugPrint(e.toString());

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.failedToLoadPurchases)),
      );

      setState(() {
        isLoading = false;
      });
    }
  }

  void searchPurchases(String value) {
    final query = value.toLowerCase().trim();

    setState(() {
      filteredPurchases = purchases.where((purchase) {
        final notes = purchase.notes.toLowerCase();
        final date = purchase.purchaseDate.toLowerCase();
        final amount = purchase.totalAmount.toLowerCase();

        return notes.contains(query) ||
            date.contains(query) ||
            amount.contains(query);
      }).toList();
    });
  }

  double get averagePurchase {
    if (purchases.isEmpty) {
      return 0;
    }

    final total = purchases.fold(
      0.0,
      (sum, purchase) =>
          sum + (double.tryParse(purchase.totalAmount) ?? 0),
    );

    return total / purchases.length;
  }

  double get totalPurchasesAmount {
    return purchases.fold(
      0.0,
      (sum, purchase) =>
          sum + (double.tryParse(purchase.totalAmount) ?? 0),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return AppLoadingScaffold(message: context.l10n.loadingPurchases);
    }

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.purchases)),

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
                      Text(context.l10n.purchases),
                      Text(                        
                        AppFormatters.number(context, purchases.length),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),

                  Column(
                    children: [
                      Text(context.l10n.total),
                      Text(
                        // 'YER ${currencyFormatter.format(totalPurchasesAmount)}',
                        AppFormatters.currency(
                          context,
                          totalPurchasesAmount,
                          context.read<ShopProvider>().currency,
                        ),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),

                  Column(
                    children: [
                      Text(context.l10n.average),

                      Text(
                        // 'YER ${currencyFormatter.format(averagePurchase)}',
                        AppFormatters.currency(
                          context,
                          averagePurchase,
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

            child: TextField(
              controller: searchController,
              onChanged: (value) {
                searchPurchases(value);
                setState(() {});
              },

              decoration: InputDecoration(
                hintText: context.l10n.searchPurchases,
                prefixIcon: const Icon(Icons.search),

                suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),

                        onPressed: () {
                          searchController.clear();
                          searchPurchases('');

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
                '${filteredPurchases.length} '
                '${context.l10n.outOf} '
                '${purchases.length} '
                '${context.l10n.showingPurchases}',

                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),

          Expanded(
            child: filteredPurchases.isEmpty
                ? AppRefreshableEmptyState(
                    message: context.l10n.noPurchasesFound,
                    icon: Icons.shopping_cart_outlined,
                    onRefresh: loadPurchases,
                  )
                : RefreshIndicator(
                    onRefresh: loadPurchases,

                    child: ListView.builder(
                      padding: const EdgeInsets.only(
                        left: 8,
                        right: 8,
                        top: 8,
                        bottom: 100,
                      ),

                      itemCount: filteredPurchases.length,

                      itemBuilder: (context, index) {
                        final purchase = filteredPurchases[index];
                        final totalAmount =
                            double.tryParse(
                              purchase.totalAmount,
                            ) ??
                            0;

                        return Card(
                          child: ListTile(
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      PurchaseDetailScreen(purchase: purchase),
                                ),
                              );

                              if (mounted) {
                                loadPurchases();
                              }
                            },
                            title: Text(
                              // 'YER ${currencyFormatter.format(totalAmount)}',
                              AppFormatters.currency(
                                context,
                                totalAmount,
                                context.read<ShopProvider>().currency,
                              ),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            subtitle: Text(purchase.purchaseDate),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
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
