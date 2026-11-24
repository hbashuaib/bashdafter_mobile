import 'package:flutter/material.dart';

import '../services/top_selling_products_service.dart';
import '../models/top_selling_product_model.dart';
import '../../../core/widgets/app_loading_scaffold.dart';
import '../../../core/widgets/app_refreshable_empty_state.dart';
import '../../../core/localization/localization_extension.dart';
import '../../../core/localization/app_formatters.dart';

class TopSellingProductsScreen extends StatefulWidget {
  const TopSellingProductsScreen({super.key});

  @override
  State<TopSellingProductsScreen> createState() =>
      _TopSellingProductsScreenState();
}

class _TopSellingProductsScreenState extends State<TopSellingProductsScreen> {
  final searchController = TextEditingController();
  List<TopSellingProductModel> products = [];
  List<TopSellingProductModel> filteredProducts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    try {
      final data = await TopSellingProductsService().getProducts();

      if (!mounted) return;

      setState(() {
        products = data;
        filteredProducts = data;
        isLoading = false;
      });
    } catch (e) {
      debugPrint(e.toString());

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.failedToLoadTopSellingProducts)),
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

  void searchProducts(String value) {
    final query = value.toLowerCase().trim();

    setState(() {
      filteredProducts = products.where((product) {
        final name = product.name.toLowerCase();

        return name.contains(query);
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
      return AppLoadingScaffold(
        message: context.l10n.loadingTopSellingProducts,
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.topSellingProducts)),

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
                      Text(context.l10n.products),

                      Text(
                        // products.length.toString(),
                        AppFormatters.number(context, products.length),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),

                  Column(
                    children: [
                      Text(context.l10n.topSeller),

                      SizedBox(
                        width: 100,

                        child: Text(
                          products.isEmpty ? '-' : products.first.name,

                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
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
                searchProducts(value);
                setState(() {});
              },

              decoration: InputDecoration(
                hintText: context.l10n.searchProduct,
                prefixIcon: const Icon(Icons.search),

                suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),

                        onPressed: () {
                          searchController.clear();
                          searchProducts('');
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
                '${AppFormatters.number(context, filteredProducts.length)} '
                '${context.l10n.outOf} '
                '${AppFormatters.number(context, products.length)} '
                '${context.l10n.products}',

                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),

          Expanded(
            child: filteredProducts.isEmpty
                ? AppRefreshableEmptyState(
                    message: context.l10n.noSalesFound,
                    icon: Icons.leaderboard_outlined,
                    onRefresh: loadProducts,
                  )
                : RefreshIndicator(
                    onRefresh: loadProducts,

                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.only(bottom: 100),

                      itemCount: filteredProducts.length,

                      itemBuilder: (context, index) {
                        final product = filteredProducts[index];
                        final rank = product.rank;
                        final currentStock = product.currentStock.toDouble();
                        final totalSold = product.totalSold.toDouble();

                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),

                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: getRankColor(rank),

                              child: Text(
                                '#${AppFormatters.number(context, rank)}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            title: Text(
                              product.name.isEmpty
                                  ? context.l10n.unknownProduct
                                  : product.name,
                            ),

                            subtitle: Text(
                              '${context.l10n.currentStock}: '
                              '${
                              // currentStock.toStringAsFixed(0)
                              AppFormatters.number(context, currentStock)}',
                            ),

                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,

                              children: [
                                Text(
                                  context.l10n.sold,
                                  style: const TextStyle(fontSize: 12),
                                ),

                                Text(
                                  // totalSold.toStringAsFixed(0),
                                  AppFormatters.number(context, totalSold),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
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
