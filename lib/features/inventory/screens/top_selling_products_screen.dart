import 'package:flutter/material.dart';

import '../services/top_selling_products_service.dart';

class TopSellingProductsScreen extends StatefulWidget {
  const TopSellingProductsScreen({super.key});

  @override
  State<TopSellingProductsScreen> createState() =>
      _TopSellingProductsScreenState();
}

class _TopSellingProductsScreenState extends State<TopSellingProductsScreen> {
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

  Color getRankColor(int index) {
    if (index == 0) {
      return Colors.amber;
    }

    if (index == 1) {
      return Colors.grey;
    }

    if (index == 2) {
      return Colors.orange;
    }

    return Colors.blue;
  }

  void searchProducts(String value) {
    final query = value.toLowerCase();

    setState(() {
      filteredProducts = products.where((product) {
        final name = product['name'].toString().toLowerCase();

        return name.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Top Selling Products')),

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
                            const Text('Products'),

                            Text(
                              products.length.toString(),

                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
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
                      'Showing ${filteredProducts.length} of ${products.length} products',

                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),

                Expanded(
                  child: products.isEmpty
                      ? ListView(
                          children: const [
                            SizedBox(height: 150),

                            Center(child: Text('No sales found')),
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
                                    backgroundColor: getRankColor(index),

                                    child: Text(
                                      '#${index + 1}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),

                                  title: Text(
                                    product['name']?.toString() ??
                                        'Unknown Product',
                                  ),

                                  subtitle: Text(
                                    'Current Stock: ${(double.tryParse(product['current_stock'].toString()) ?? 0).toStringAsFixed(0)}',
                                  ),

                                  trailing: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,

                                    children: [
                                      const Text(
                                        'Sold',
                                        style: TextStyle(fontSize: 12),
                                      ),

                                      Text(
                                        (double.tryParse(
                                                  product['total_sold']
                                                      .toString(),
                                                ) ??
                                                0)
                                            .toStringAsFixed(0),
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
