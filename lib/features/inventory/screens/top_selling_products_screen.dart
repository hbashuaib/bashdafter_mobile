import 'package:flutter/material.dart';

import '../services/top_selling_products_service.dart';
import '../../../core/widgets/app_loading_scaffold.dart';
import '../../../core/widgets/app_refreshable_empty_state.dart';

class TopSellingProductsScreen extends StatefulWidget {
  const TopSellingProductsScreen({super.key});

  @override
  State<TopSellingProductsScreen> createState() =>
      _TopSellingProductsScreenState();
}

class _TopSellingProductsScreenState extends State<TopSellingProductsScreen> {
  final searchController = TextEditingController();
  List<dynamic> products = [];
  List<dynamic> filteredProducts = [];
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
        const SnackBar(content: Text('Failed to load top selling products')),
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
        final name = product['name'].toString().toLowerCase();

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
      return const AppLoadingScaffold(
        message: 'Loading top selling products...',
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Top Selling Products')),

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
                      const Text('Products'),

                      Text(
                        products.length.toString(),

                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),

                  Column(
                    children: [
                      const Text('Top Seller'),

                      SizedBox(
                        width: 100,

                        child: Text(
                          products.isEmpty
                              ? '-'
                              : products.first['name'].toString(),

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
                hintText: 'Search product',
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
                'Showing ${filteredProducts.length} of ${products.length} products',

                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),

          Expanded(
            child: filteredProducts.isEmpty
                ? AppRefreshableEmptyState(
                    message: 'No sales found',
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
                        final rank = product['rank'] ?? 0;

                        final currentStock =
                            double.tryParse(
                              product['current_stock'].toString(),
                            ) ??
                            0;

                        final totalSold =
                            double.tryParse(product['total_sold'].toString()) ??
                            0;

                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),

                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: getRankColor(rank),

                              child: Text(
                                '#$rank',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            title: Text(
                              product['name']?.toString() ?? 'Unknown Product',
                            ),

                            subtitle: Text(
                              'Current Stock: ${currentStock.toStringAsFixed(0)}',
                            ),

                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,

                              children: [
                                const Text(
                                  'Sold',
                                  style: TextStyle(fontSize: 12),
                                ),

                                Text(
                                  totalSold.toStringAsFixed(0),
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
