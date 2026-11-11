import 'package:flutter/material.dart';

import '../services/expiring_products_service.dart';

class ExpiringProductsScreen extends StatefulWidget {
  const ExpiringProductsScreen({super.key});

  @override
  State<ExpiringProductsScreen> createState() => _ExpiringProductsScreenState();
}

class _ExpiringProductsScreenState extends State<ExpiringProductsScreen> {
  List<dynamic> products = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    try {
      final data = await ExpiringProductsService().getExpiringProducts();

      if (!mounted) {
        return;
      }

      setState(() {
        products = data;
        isLoading = false;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Expiring Products')),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : products.isEmpty
          ? const Center(child: Text('No expiring products'))
          : ListView.builder(
              itemCount: products.length,

              itemBuilder: (context, index) {
                final product = products[index];
                final expiryDate = DateTime.parse(product['expiry_date']);
                final days = expiryDate.difference(DateTime.now()).inDays;

                Color color;

                if (days < 0) {
                  color = Colors.red;
                } else if (days <= 30) {
                  color = Colors.orange;
                } else {
                  color = Colors.green;
                }

                return Card(
                  child: ListTile(
                    leading: Icon(Icons.calendar_month, color: color),
                    title: Text(product['name']),
                    subtitle: Text('Expiry: ${product['expiry_date']}'),

                    trailing: Text(
                      days < 0 ? 'Expired' : '$days days',
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
