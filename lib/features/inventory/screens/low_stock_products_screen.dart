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

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    loadProducts();
  }

  Future<void> loadProducts() async {
    try {
      final products = await ProductService().getProducts();

      if (!mounted) return;

      setState(() {
        lowStockProducts = products
            .where((product) => product['is_low_stock'] == true)
            .toList();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Low Stock Products')),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : lowStockProducts.isEmpty
          ? const Center(child: Text('No low stock products'))
          : RefreshIndicator(
              onRefresh: loadProducts,

              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 20),
                itemCount: lowStockProducts.length,

                itemBuilder: (context, index) {
                  final product = lowStockProducts[index];

                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),

                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.orange.shade100,
                        child: const Icon(Icons.warning, color: Colors.orange),
                      ),
                      title: Text(
                        product['name']?.toString() ?? 'Unknown Product',
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
                            builder: (_) =>
                                StockAdjustmentScreen(product: product),
                          ),
                        );

                        loadProducts();
                      },
                    ),
                  );
                },
              ),
            ),
    );
  }
}
