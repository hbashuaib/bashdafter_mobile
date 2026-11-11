import 'package:flutter/material.dart';

import '../../products/screens/barcode_scanner_screen.dart';
import '../../products/services/barcode_lookup_service.dart';

import 'stock_adjustment_screen.dart';

class InventoryLookupScreen extends StatefulWidget {
  const InventoryLookupScreen({super.key});

  @override
  State<InventoryLookupScreen> createState() => _InventoryLookupScreenState();
}

class _InventoryLookupScreenState extends State<InventoryLookupScreen> {
  Map<String, dynamic>? product;

  bool isLoading = false;

  Future<void> scanBarcode() async {
    final messenger = ScaffoldMessenger.of(context);

    final barcode = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const BarcodeScannerScreen()),
    );

    if (!mounted || barcode == null) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final result = await BarcodeLookupService().findProductByBarcode(
        barcode.toString(),
      );

      if (!mounted) {
        return;
      }

      setState(() {
        product = result;
        isLoading = false;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        isLoading = false;
      });

      messenger.showSnackBar(
        const SnackBar(content: Text('Product not found')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inventory Lookup')),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,

          children: [
            ElevatedButton.icon(
              onPressed: isLoading ? null : scanBarcode,
              icon: const Icon(Icons.qr_code_scanner),
              label: const Text('Scan Product'),
            ),

            const SizedBox(height: 20),

            if (isLoading) const Center(child: CircularProgressIndicator()),

            if (product != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        product!['name'],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text('Barcode: ${product!['barcode'] ?? '-'}'),
                      Text('Stock: ${product!['current_stock']}'),
                      Text('Minimum Stock: ${product!['minimum_stock']}'),
                      Text('Selling Price: ${product!['selling_price']}'),

                      const SizedBox(height: 12),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),

                        decoration: BoxDecoration(
                          color:
                              (double.tryParse(
                                        product!['current_stock'].toString(),
                                      ) ??
                                      0) <=
                                  (double.tryParse(
                                        product!['minimum_stock'].toString(),
                                      ) ??
                                      0)
                              ? Colors.red.shade100
                              : Colors.green.shade100,
                        ),

                        child: Text(
                          (double.tryParse(
                                        product!['current_stock'].toString(),
                                      ) ??
                                      0) <=
                                  (double.tryParse(
                                        product!['minimum_stock'].toString(),
                                      ) ??
                                      0)
                              ? 'LOW STOCK'
                              : 'IN STOCK',
                        ),
                      ),

                      const SizedBox(height: 20),

                      SizedBox(
                        width: double.infinity,

                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.inventory),

                          label: const Text('Adjust Stock'),

                          onPressed: () async {
                            final messenger = ScaffoldMessenger.of(context);

                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    StockAdjustmentScreen(product: product),
                              ),
                            );

                            if (!mounted) {
                              return;
                            }

                            if (result == true && product != null) {
                              debugPrint(
                                'Current barcode: ${product?['barcode']}',
                              );

                              try {
                                final updatedProduct =
                                    await BarcodeLookupService()
                                        .findProductByBarcode(
                                          product!['barcode'],
                                        );

                                if (!mounted) {
                                  return;
                                }

                                setState(() {
                                  product = updatedProduct;
                                });

                                messenger.showSnackBar(
                                  SnackBar(
                                    behavior: SnackBarBehavior.floating,
                                    content: Text(
                                      'Stock updated. Current stock: ${updatedProduct['current_stock']}',
                                    ),
                                  ),
                                );
                              } catch (e) {
                                debugPrint('Refresh failed: $e');
                              }
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
