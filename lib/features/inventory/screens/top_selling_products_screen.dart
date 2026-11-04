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

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    try {
      final data = await TopSellingProductsService().getProducts();

      setState(() {
        products = data;
        isLoading = false;
      });
    } catch (e) {
      debugPrint(e.toString());

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Top Selling Products')),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : products.isEmpty
          ? const Center(child: Text('No sales found'))
          : RefreshIndicator(
              onRefresh: loadProducts,

              child: ListView.builder(
                itemCount: products.length,

                itemBuilder: (context, index) {
                  final product = products[index];

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

                      title: Text(product['name']),

                      subtitle: Text(
                        'Current Stock: ${product['current_stock']}',
                      ),

                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,

                        children: [
                          const Text('Sold', style: TextStyle(fontSize: 12)),

                          Text(
                            product['total_sold'].toString(),
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
    );
  }
}
