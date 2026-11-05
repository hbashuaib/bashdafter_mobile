import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'edit_product_screen.dart';

class ProductDetailScreen extends StatelessWidget {
  final NumberFormat currencyFormatter = NumberFormat('#,##0.00');
  final Map<String, dynamic> product;

  ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product['name']?.toString() ?? '')),

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

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
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),

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
              subtitle: Text(
                (product['barcode'] ?? '').toString().trim().isEmpty
                    ? '-'
                    : product['barcode'].toString(),
              ),
            ),
          ),

          Card(
            child: ListTile(
              title: const Text('Description'),
              subtitle: Text(
                (product['description'] ?? '').toString().trim().isEmpty
                    ? 'No description'
                    : product['description'],
              ),
            ),
          ),

          Card(
            child: ListTile(
              title: const Text('Cost Price'),
              subtitle: Text(
                'YER ${currencyFormatter.format(double.tryParse(product['cost_price'].toString()) ?? 0)}',
              ),
            ),
          ),

          Card(
            child: ListTile(
              title: const Text('Selling Price'),
              subtitle: Text(
                'YER ${currencyFormatter.format(double.tryParse(product['selling_price'].toString()) ?? 0)}',
              ),
            ),
          ),

          Card(
            child: ListTile(
              title: const Text('Current Stock'),
              subtitle: Text(
                (double.tryParse(product['current_stock'].toString()) ?? 0)
                    .toStringAsFixed(0),
              ),
            ),
          ),

          Card(
            child: ListTile(
              title: const Text('Total Sold'),
              subtitle: Text(
                (double.tryParse(product['total_sold'].toString()) ?? 0)
                    .toStringAsFixed(0),
              ),
            ),
          ),

          Card(
            child: ListTile(
              title: const Text('Stock Adjustments'),
              subtitle: Text(
                (double.tryParse(product['total_adjustments'].toString()) ?? 0)
                    .toStringAsFixed(0),
              ),
            ),
          ),

          if ((double.tryParse(product['current_stock'].toString()) ?? 0) <=
              (double.tryParse(product['minimum_stock'].toString()) ?? 0))
            Card(
              color: Colors.red.shade50,

              child: const ListTile(
                leading: Icon(Icons.warning, color: Colors.red),

                title: Text(
                  'LOW STOCK',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                subtitle: Text('Current stock is below minimum stock level'),
              ),
            ),

          Card(
            child: ListTile(
              title: const Text('Minimum Stock'),
              subtitle: Text(
                (double.tryParse(product['minimum_stock'].toString()) ?? 0)
                    .toStringAsFixed(0),
              ),
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
              subtitle: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
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
                    color: product['is_active'] ? Colors.green : Colors.red,

                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
