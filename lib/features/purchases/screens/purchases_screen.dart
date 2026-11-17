import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../services/purchase_service.dart';
import '../../../core/widgets/app_loading_scaffold.dart';
import '../../../core/widgets/app_refreshable_empty_state.dart';

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
  List<dynamic> purchases = [];
  List<dynamic> filteredPurchases = [];
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
          .where((purchase) => purchase['customer'] == widget.customerId)
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

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to load purchases')));

      setState(() {
        isLoading = false;
      });
    }
  }

  void searchPurchases(String value) {
    final query = value.toLowerCase().trim();

    setState(() {
      filteredPurchases = purchases.where((purchase) {
        final notes = (purchase['notes'] ?? '').toString().toLowerCase();
        final date = purchase['purchase_date'].toString().toLowerCase();
        final amount = purchase['total_amount'].toString().toLowerCase();

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
          sum + (double.tryParse(purchase['total_amount'].toString()) ?? 0),
    );

    return total / purchases.length;
  }

  double get totalPurchasesAmount {
    return purchases.fold(
      0.0,
      (sum, purchase) =>
          sum + (double.tryParse(purchase['total_amount'].toString()) ?? 0),
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
      return const AppLoadingScaffold(message: 'Loading purchases...');
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Purchases')),

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
                      const Text('Purchases'),
                      Text(
                        purchases.length.toString(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),

                  Column(
                    children: [
                      const Text('Total'),
                      Text(
                        'YER ${currencyFormatter.format(totalPurchasesAmount)}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),

                  Column(
                    children: [
                      const Text('Average'),

                      Text(
                        'YER ${currencyFormatter.format(averagePurchase)}',
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
                hintText: 'Search by date, notes or amount',
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
                'Showing ${filteredPurchases.length} of ${purchases.length} purchases',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),

          Expanded(
            child: filteredPurchases.isEmpty
                ? AppRefreshableEmptyState(
                    message: 'No purchases found',
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
                              purchase['total_amount'].toString(),
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
                              'YER ${currencyFormatter.format(totalAmount)}',

                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            subtitle: Text(purchase['purchase_date']),
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
