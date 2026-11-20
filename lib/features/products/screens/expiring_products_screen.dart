import 'package:flutter/material.dart';

import '../services/expiring_products_service.dart';
import '../../../core/localization/localization_extension.dart';

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
      appBar: AppBar(title: Text(context.l10n.expiringProducts)),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : products.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 48),
                  const SizedBox(height: 12),
                  Text(context.l10n.noExpiringProducts),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.only(bottom: 100),
              itemCount: products.length,

              itemBuilder: (context, index) {
                final product = products[index];
                final expiryDate = DateTime.tryParse(
                  product['expiry_date'].toString(),
                );

                if (expiryDate == null) {
                  return const SizedBox.shrink();
                }
                
                final today = DateTime.now();

                final days =
                    DateTime(expiryDate.year, expiryDate.month, expiryDate.day)
                        .difference(
                          DateTime(today.year, today.month, today.day),
                        )
                        .inDays;

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
                    subtitle: Text(
                      '${context.l10n.expiryDate}: '
                      '${product['expiry_date']}',
                    ),

                    trailing: Text(
                      days < 0
                          ? context.l10n.expired
                          : '$days ${context.l10n.days}',
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
