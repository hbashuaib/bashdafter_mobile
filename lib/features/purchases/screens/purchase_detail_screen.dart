import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PurchaseDetailScreen extends StatelessWidget {
  final Map<String, dynamic> purchase;

  PurchaseDetailScreen({super.key, required this.purchase});

  final NumberFormat currencyFormatter = NumberFormat('#,##0.00');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Purchase Details')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              title: const Text('Purchase Date'),
              subtitle: Text(purchase['purchase_date'].toString()),
            ),
          ),

          Card(
            child: ListTile(
              title: const Text('Total Amount'),
              subtitle: Text(
                'YER ${currencyFormatter.format(double.tryParse(purchase['total_amount'].toString()) ?? 0)}',
              ),
            ),
          ),

          Card(
            child: ListTile(
              title: const Text('Notes'),
              subtitle: Text(
                (purchase['notes'] ?? '').toString().trim().isEmpty
                    ? 'No notes'
                    : purchase['notes'],
              ),
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'Items',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          ...(purchase['items'] as List).map(
            (item) => Card(
              child: ListTile(
                title: Text(item['item_name']),
                subtitle: Text(
                  '${item['quantity']} x ${currencyFormatter.format(double.tryParse(item['unit_price'].toString()) ?? 0)}',
                ),
                trailing: Text(
                  currencyFormatter.format(
                    double.tryParse(item['total_price'].toString()) ?? 0,
                  ),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
