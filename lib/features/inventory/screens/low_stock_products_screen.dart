import 'package:flutter/material.dart';

import '../../products/services/product_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_loading_scaffold.dart';
import '../../../core/widgets/app_refreshable_empty_state.dart';
import '../../../core/localization/localization_extension.dart';

import 'stock_adjustment_screen.dart';

class LowStockProductsScreen extends StatefulWidget {
  const LowStockProductsScreen({super.key});

  @override
  State<LowStockProductsScreen> createState() => _LowStockProductsScreenState();
}

class _LowStockProductsScreenState extends State<LowStockProductsScreen> {
  final searchController = TextEditingController();
  List<dynamic> lowStockProducts = [];
  List<dynamic> filteredProducts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    loadProducts();
  }

  Future<void> loadProducts() async {
    try {
      final products = await ProductService().getProducts();
      final lowStock = products
          .where((product) => product['is_low_stock'] == true)
          .toList();

      if (!mounted) return;

      setState(() {
        lowStockProducts = lowStock;
        filteredProducts = lowStock;
        isLoading = false;
      });
    } catch (e) {
      debugPrint(e.toString());

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.failedToLoadLowStockProducts)),
      );

      setState(() {
        isLoading = false;
      });
    }
  }

  void searchProducts(String value) {
    final query = value.toLowerCase().trim();

    setState(() {
      filteredProducts = lowStockProducts.where((product) {
        final name = product['name'].toString().toLowerCase();

        final category = (product['category_name'] ?? '')
            .toString()
            .toLowerCase();

        return name.contains(query) || category.contains(query);
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
      return AppLoadingScaffold(message: context.l10n.loadingLowStockProducts);
    }

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.lowStockProducts)),

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
                      Text(context.l10n.lowStock),

                      Text(
                        lowStockProducts.length.toString(),

                        style: const TextStyle(
                          color: Colors.orange,

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
                '${filteredProducts.length} '
                '${context.l10n.outOf} '
                '${lowStockProducts.length} '
                '${context.l10n.products}',

                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),

          Expanded(
            child: filteredProducts.isEmpty
                ? AppRefreshableEmptyState(
                    message: context.l10n.noLowStockProducts,
                    icon: Icons.warning_amber_rounded,
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

                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),

                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: AppColors.cardTint(
                                context,
                                Colors.orange.shade100,
                              ),
                              child: const Icon(
                                Icons.warning,
                                color: Colors.orange,
                              ),
                            ),
                            title: Text(
                              product['name']?.toString() ??
                                  context.l10n.unknownProduct,
                            ),

                            subtitle: Text(
                              '${context.l10n.current}: '
                              '${(double.tryParse(product['current_stock'].toString()) ?? 0).toStringAsFixed(0)}'
                              '\n${context.l10n.minimum}: '
                              '${(double.tryParse(product['minimum_stock'].toString()) ?? 0).toStringAsFixed(0)}',
                            ),

                            trailing: const Icon(Icons.arrow_forward_ios),

                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      StockAdjustmentScreen(product: product),
                                ),
                              );

                              if (!mounted) return;

                              await loadProducts();
                            },
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
