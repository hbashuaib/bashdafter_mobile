import 'package:flutter/material.dart';

import '../../products/services/product_service.dart';
import '../services/stock_adjustment_service.dart';

class StockAdjustmentScreen extends StatefulWidget {
  final Map<String, dynamic>? product;

  const StockAdjustmentScreen({super.key, this.product});

  @override
  State<StockAdjustmentScreen> createState() => _StockAdjustmentScreenState();
}

class _StockAdjustmentScreenState extends State<StockAdjustmentScreen> {
  List<dynamic> products = [];
  dynamic selectedProduct;
  String adjustmentType = 'IN';

  final quantityController = TextEditingController();
  final reasonController = TextEditingController();

  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    try {
      final data = await ProductService().getProducts();

      if (!mounted) return;

      setState(() {
        products = data;

        if (widget.product != null) {
          final matches = data.where((p) => p['id'] == widget.product!['id']);

          if (matches.isNotEmpty) {
            selectedProduct = matches.first;
          }
        }
      });
    } catch (e) {
      debugPrint(e.toString());

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to load products')));
    }
  }

  Future<void> saveAdjustment() async {
    if (selectedProduct == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a product')));

      return;
    }

    final quantity = double.tryParse(quantityController.text.trim());

    if (quantity == null || quantity <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Enter a valid quantity')));

      return;
    }

    if (reasonController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Reason is required')));

      return;
    }

    if (adjustmentType == 'OUT' || adjustmentType == 'DAMAGE') {
      final currentStock =
          double.tryParse(selectedProduct['current_stock'].toString()) ?? 0;

      if (quantity > currentStock) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Only ${currentStock.toStringAsFixed(0)} available in stock',
            ),
          ),
        );

        return;
      }
    }

    setState(() {
      isSaving = true;
    });

    try {
      await StockAdjustmentService().createAdjustment(
        productId: selectedProduct['id'],
        adjustmentType: adjustmentType,
        quantity: quantityController.text,
        reason: reasonController.text,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Stock adjustment saved successfully')),
      );

      Navigator.pop(context, true);
    } catch (e) {
      debugPrint(e.toString());

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to save stock adjustment')),
      );
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stock Adjustment')),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            DropdownButtonFormField<dynamic>(
              value: selectedProduct,
              decoration: const InputDecoration(labelText: 'Product'),

              items: products.map((product) {
                return DropdownMenuItem(
                  value: product,
                  child: Text(product['name']),
                );
              }).toList(),

              onChanged: (value) {
                setState(() {
                  selectedProduct = value;
                });
              },
            ),

            if (selectedProduct != null)
              Card(
                color: Colors.blue.shade50,

                child: ListTile(
                  leading: const Icon(Icons.inventory),
                  title: const Text('Current Stock'),
                  subtitle: Text(
                    (double.tryParse(
                              selectedProduct['current_stock'].toString(),
                            ) ??
                            0)
                        .toStringAsFixed(0),
                  ),
                ),
              ),

            const SizedBox(height: 15),

            DropdownButtonFormField<String>(
              value: adjustmentType,

              decoration: const InputDecoration(labelText: 'Adjustment Type'),

              items: const [
                DropdownMenuItem(
                  value: 'OPENING',

                  child: Text('Opening Stock'),
                ),

                DropdownMenuItem(value: 'IN', child: Text('Stock In')),
                DropdownMenuItem(value: 'OUT', child: Text('Stock Out')),
                DropdownMenuItem(value: 'DAMAGE', child: Text('Damaged Stock')),

                DropdownMenuItem(
                  value: 'CORRECTION',

                  child: Text('Correction'),
                ),
              ],

              onChanged: (value) {
                setState(() {
                  adjustmentType = value!;
                });
              },
            ),

            const SizedBox(height: 15),

            TextField(
              controller: quantityController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(labelText: 'Quantity'),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: reasonController,
              decoration: const InputDecoration(labelText: 'Reason'),
              textInputAction: TextInputAction.done,

              onSubmitted: (_) {
                if (!isSaving) {
                  saveAdjustment();
                }
              },
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                onPressed: isSaving ? null : saveAdjustment,
                child: Text(isSaving ? 'Saving...' : 'Save Adjustment'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
