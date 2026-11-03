import 'package:flutter/material.dart';

import '../services/product_service.dart';

import 'product_detail_screen.dart';
import 'add_product_screen.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  List<dynamic> products = [];
  List<dynamic> filteredProducts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    final data = await ProductService().getProducts();

    setState(() {
      products = data;
      filteredProducts = data;
      isLoading = false;
    });
  }

  void searchProducts(String value) {
    setState(() {
      filteredProducts = products.where((product) {
        final name = product['name'].toString().toLowerCase();

        return name.contains(value.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Products')),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddProductScreen()),
          );

          if (result == true) {
            await loadProducts();
          }
        },

        child: const Icon(Icons.add),
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),

                  child: TextField(
                    onChanged: searchProducts,

                    decoration: const InputDecoration(
                      hintText: 'Search Product',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),

                Expanded(
                  child: ListView.builder(
                    itemCount: filteredProducts.length,

                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];

                      return Card(
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                              context,

                              MaterialPageRoute(
                                builder: (_) =>
                                    ProductDetailScreen(product: product),
                              ),
                            );
                          },

                          title: Text(product['name']),

                          subtitle: Text(
                            '${product['category_name']} • ${product['unit_name']}',
                          ),

                          trailing: Text(
                            product['selling_price'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
