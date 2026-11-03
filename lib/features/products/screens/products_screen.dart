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
  String activeFilter = 'All';

  int get totalProducts => products.length;
  int get activeProducts =>
      products.where((p) => p['is_active'] == true).length;
  int get inactiveProducts =>
      products.where((p) => p['is_active'] == false).length;

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    final data = await ProductService().getProducts();

    setState(() {
      products = data;
      isLoading = false;
    });

    applyFilter(activeFilter);
  }

  void searchProducts(String value) {
    setState(() {
      filteredProducts = products.where((product) {
        final name = product['name'].toString().toLowerCase();

        return name.contains(value.toLowerCase());
      }).toList();
    });
  }

  void applyFilter(String filter) {
    setState(() {
      activeFilter = filter;

      if (filter == 'All') {
        filteredProducts = products;
      } else if (filter == 'Active') {
        filteredProducts = products
            .where((p) => p['is_active'] == true)
            .toList();
      } else {
        filteredProducts = products
            .where((p) => p['is_active'] == false)
            .toList();
      }
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

                  child: Card(
                    color: Colors.blue.shade50,

                    child: Padding(
                      padding: const EdgeInsets.all(12),

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,

                        children: [
                          Column(
                            children: [
                              const Text('Total'),
                              Text(
                                totalProducts.toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),

                          Column(
                            children: [
                              const Text('Active'),
                              Text(
                                activeProducts.toString(),
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),

                          Column(
                            children: [
                              const Text('Inactive'),
                              Text(
                                inactiveProducts.toString(),
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

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

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                    children: [
                      FilterChip(
                        label: const Text('All'),
                        selected: activeFilter == 'All',

                        onSelected: (_) {
                          applyFilter('All');
                        },
                      ),

                      FilterChip(
                        label: const Text('Active'),
                        selected: activeFilter == 'Active',

                        onSelected: (_) {
                          applyFilter('Active');
                        },
                      ),

                      FilterChip(
                        label: const Text('Inactive'),
                        selected: activeFilter == 'Inactive',

                        onSelected: (_) {
                          applyFilter('Inactive');
                        },
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: ListView.builder(
                    itemCount: filteredProducts.length,

                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];

                      return Card(
                        child: ListTile(
                          onTap: () async {
                            final result = await Navigator.push(
                              context,

                              MaterialPageRoute(
                                builder: (_) =>
                                    ProductDetailScreen(product: product),
                              ),
                            );

                            if (result == true) {
                              activeFilter = 'All';
                              await loadProducts();
                            }
                          },

                          title: Text(product['name']),

                          subtitle: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '${product['category_name']} • ${product['unit_name']}',
                                ),
                              ),

                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),

                                decoration: BoxDecoration(
                                  color: product['is_active']
                                      ? Colors.green.shade100
                                      : Colors.red.shade100,

                                  borderRadius: BorderRadius.circular(12),
                                ),

                                child: Text(
                                  product['is_active'] ? 'Active' : 'Inactive',

                                  style: TextStyle(
                                    color: product['is_active']
                                        ? Colors.green
                                        : Colors.red,

                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
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
