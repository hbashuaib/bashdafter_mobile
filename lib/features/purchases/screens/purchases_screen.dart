import 'package:flutter/material.dart';

import '../services/purchase_service.dart';

class PurchasesScreen extends StatefulWidget {
  final int customerId;

  const PurchasesScreen({super.key, required this.customerId});

  @override
  State<PurchasesScreen> createState() => _PurchasesScreenState();
}

class _PurchasesScreenState extends State<PurchasesScreen> {
  List<dynamic> purchases = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadPurchases();
  }

  Future<void> loadPurchases() async {
    final data = await PurchaseService().getPurchases();

    setState(() {
      purchases = data
          .where((purchase) => purchase['customer'] == widget.customerId)
          .toList();

      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Purchases')),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: purchases.length,

              itemBuilder: (context, index) {
                final purchase = purchases[index];

                return Card(
                  child: ExpansionTile(
                    title: Text('YER ${purchase['total_amount']}'),

                    subtitle: Text(purchase['purchase_date']),

                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),

                        child: Text(purchase['notes'] ?? ''),
                      ),

                      ...(purchase['items'] as List).map(
                        (item) => ListTile(
                          title: Text(item['item_name']),
                          subtitle: Text(
                            '${item['quantity']} x ${item['unit_price']}',
                          ),
                          trailing: Text(item['total_price']),
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
