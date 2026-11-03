import 'package:flutter/material.dart';

import 'edit_product_screen.dart';

class ProductDetailScreen extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product['name'])),

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.edit),

        onPressed: () async {
          final result = await Navigator.push(
            context,

            MaterialPageRoute(
              builder: (_) => EditProductScreen(product: product),
            ),
          );

          if (result == true && context.mounted) {
            Navigator.pop(context, true);
          }
        },
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),

        children: [
          Card(
            child: ListTile(
              title: const Text('Category'),
              subtitle: Text(product['category_name'] ?? ''),
            ),
          ),

          Card(
            child: ListTile(
              title: const Text('Unit'),
              subtitle: Text(product['unit_name'] ?? ''),
            ),
          ),

          Card(
            child: ListTile(
              title: const Text('Barcode'),
              subtitle: Text(product['barcode'] ?? '-'),
            ),
          ),

          Card(
            child: ListTile(
              title: const Text('Description'),
              subtitle: Text(product['description'] ?? ''),
            ),
          ),

          Card(
            child: ListTile(
              title: const Text('Cost Price'),
              subtitle: Text(product['cost_price']),
            ),
          ),

          Card(
            child: ListTile(
              title: const Text('Selling Price'),
              subtitle: Text(product['selling_price']),
            ),
          ),

          Card(
            child: ListTile(
              title: const Text('Minimum Stock'),
              subtitle: Text(product['minimum_stock']),
            ),
          ),

          Card(
            child: ListTile(
              title: const Text('Has Expiry'),
              subtitle: Text(product['has_expiry'] ? 'Yes' : 'No'),
            ),
          ),

          Card(
            child: ListTile(
              title: const Text('Status'),
              subtitle: Text(product['is_active'] ? 'Active' : 'Inactive'),
            ),
          ),
        ],
      ),
    );
  }
}
