import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../services/purchase_service.dart';

class PurchasesScreen extends StatefulWidget {
  final int customerId;

  const PurchasesScreen({super.key, required this.customerId});

  @override
  State<PurchasesScreen> createState() => _PurchasesScreenState();
}

class _PurchasesScreenState extends State<PurchasesScreen> {
  final currencyFormatter = NumberFormat('#,##0.00');
  List<dynamic> purchases = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadPurchases();
  }

  Future<void> loadPurchases() async {
    try {
      final data = await PurchaseService().getPurchases();

      if (!mounted) return;

      setState(() {
        purchases = data
            .where((purchase) => purchase['customer'] == widget.customerId)
            .toList();

        isLoading = false;
      });
    } catch (e) {
      debugPrint(e.toString());

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to load purchases')));

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Purchases')),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : purchases.isEmpty
          ? const Center(child: Text('No purchases found'))
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: purchases.length,

              itemBuilder: (context, index) {
                final purchase = purchases[index];

                return Card(
                  child: ExpansionTile(
                    title: Text(
                      'YER ${currencyFormatter.format(double.tryParse(purchase['total_amount'].toString()) ?? 0)}',

                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),

                    subtitle: Text(purchase['purchase_date']),

                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),

                        child: Text(
                          (purchase['notes'] ?? '').toString().trim().isEmpty
                              ? 'No notes'
                              : purchase['notes'],
                        ),
                      ),

                      ...(purchase['items'] as List).map(
                        (item) => ListTile(
                          title: Text(item['item_name']),
                          subtitle: Text(
                            '${item['quantity']} x ${currencyFormatter.format(double.tryParse(item['unit_price'].toString()) ?? 0)}',
                          ),
                          trailing: Text(
                            currencyFormatter.format(
                              double.tryParse(item['total_price'].toString()) ??
                                  0,
                            ),

                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
