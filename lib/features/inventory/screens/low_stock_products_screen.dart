import 'package:flutter/material.dart';

import '../../products/services/product_service.dart';

import 'stock_adjustment_screen.dart';

class LowStockProductsScreen extends StatefulWidget {
  const LowStockProductsScreen({super.key});

  @override
  State<LowStockProductsScreen> createState() => _LowStockProductsScreenState();
}

class _LowStockProductsScreenState extends State<LowStockProductsScreen> {
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
        const SnackBar(content: Text('Failed to load low stock products')),
      );

      setState(() {
        isLoading = false;
      });
    }
  }

  void searchProducts(String value) {
    final query = value.toLowerCase();

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Low Stock Products')),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
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
                            const Text('Low Stock'),

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
                    onChanged: searchProducts,

                    decoration: const InputDecoration(
                      hintText: 'Search product',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),

                  child: Center(
                    child: Text(
                      'Showing ${filteredProducts.length} of ${lowStockProducts.length} products',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),

                Expanded(
                  child: lowStockProducts.isEmpty
                      ? ListView(
                          children: const [
                            SizedBox(height: 150),

                            Center(child: Text('No low stock products')),
                          ],
                        )
                      : RefreshIndicator(
                          onRefresh: loadProducts,

                          child: ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),

                            padding: const EdgeInsets.only(bottom: 20),

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
                                    backgroundColor: Colors.orange.shade100,
                                    child: const Icon(
                                      Icons.warning,
                                      color: Colors.orange,
                                    ),
                                  ),
                                  title: Text(
                                    product['name']?.toString() ??
                                        'Unknown Product',
                                  ),

                                  subtitle: Text(
                                    'Current: ${(double.tryParse(product['current_stock'].toString()) ?? 0).toStringAsFixed(0)}'
                                    '\nMinimum: ${(double.tryParse(product['minimum_stock'].toString()) ?? 0).toStringAsFixed(0)}',
                                  ),

                                  trailing: const Icon(Icons.arrow_forward_ios),

                                  onTap: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => StockAdjustmentScreen(
                                          product: product,
                                        ),
                                      ),
                                    );

                                    loadProducts();
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
