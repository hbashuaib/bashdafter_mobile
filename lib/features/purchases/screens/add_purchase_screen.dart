import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../services/create_purchase_service.dart';
import '../services/create_purchase_item_service.dart';
import '../../products/services/product_service.dart';
import '../../products/services/barcode_lookup_service.dart';
import '../../products/screens/barcode_scanner_screen.dart';

class AddPurchaseScreen extends StatefulWidget {
  final int customerId;

  const AddPurchaseScreen({super.key, required this.customerId});

  @override
  State<AddPurchaseScreen> createState() => _AddPurchaseScreenState();
}

class _AddPurchaseScreenState extends State<AddPurchaseScreen> {
  final quantityController = TextEditingController();
  final unitPriceController = TextEditingController();
  final notesController = TextEditingController();
  final currencyFormatter = NumberFormat('#,##0.00');

  final FocusNode quantityFocusNode = FocusNode();

  bool isSaving = false;
  List<Map<String, dynamic>> purchaseItems = [];
  List<dynamic> products = [];
  dynamic selectedProduct;

  @override
  void initState() {
    super.initState();
    loadProducts();
    quantityController.text = '1';
  }

  @override
  void dispose() {
    quantityFocusNode.dispose();

    quantityController.dispose();
    unitPriceController.dispose();
    notesController.dispose();

    super.dispose();
  }

  Future<void> loadProducts() async {
    try {
      final data = await ProductService().getProducts();

      if (!mounted) return;

      setState(() {
        products = data;
      });
    } catch (e) {
      debugPrint(e.toString());

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to load products')));
    }
  }

  void addItem() {
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

    final unitPrice = double.tryParse(unitPriceController.text.trim());

    if (unitPrice == null || unitPrice <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Enter a valid unit price')));

      return;
    }

    final exists = purchaseItems.any(
      (item) => item['product_id'] == selectedProduct['id'],
    );

    if (exists) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Product already added')));

      return;
    }

    final currentStock =
        double.tryParse(selectedProduct['current_stock'].toString()) ?? 0;

    if (quantity > currentStock) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Only $currentStock available in stock')),
      );

      return;
    }

    purchaseItems.add({
      'product_id': selectedProduct['id'],
      'item_name': selectedProduct['name'],
      'quantity': quantityController.text.trim(),
      'unit_price': unitPriceController.text.trim(),
    });

    setState(() {
      quantityController.text = '1';
      unitPriceController.text = '';
      selectedProduct = null;
    });

    FocusScope.of(context).unfocus();
  }

  Future<void> savePurchase() async {
    if (purchaseItems.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Add at least one item')));

      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      final purchaseId = await CreatePurchaseService().createPurchase(
        customerId: widget.customerId,
        notes: notesController.text.trim(),
      );

      for (final item in purchaseItems) {
        await CreatePurchaseItemService().createItem(
          purchaseId: purchaseId,
          productId: item['product_id'],
          itemName: item['item_name'],
          quantity: item['quantity'],
          unitPrice: item['unit_price'],
        );
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Purchase saved successfully')),
      );

      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to save purchase')));

      debugPrint(e.toString());
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  double get totalAmount {
    double total = 0;

    for (final item in purchaseItems) {
      final quantity = double.tryParse(item['quantity'].toString()) ?? 0;
      final unitPrice = double.tryParse(item['unit_price'].toString()) ?? 0;
      total += quantity * unitPrice;
    }

    return total;
  }

  double get lineTotal {
    final quantity = double.tryParse(quantityController.text) ?? 0;
    final price = double.tryParse(unitPriceController.text) ?? 0;
    return quantity * price;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Purchase')),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,

          children: [
            SizedBox(
              width: double.infinity,

              child: ElevatedButton.icon(
                icon: const Icon(Icons.qr_code_scanner),
                label: const Text('Scan Product Barcode'),

                onPressed: () async {
                  final messenger = ScaffoldMessenger.of(context);

                  final barcode = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const BarcodeScannerScreen(),
                    ),
                  );

                  if (!mounted) {
                    return;
                  }

                  if (barcode == null) {
                    return;
                  }

                  try {
                    final product = await BarcodeLookupService()
                        .findProductByBarcode(barcode.toString());
                    final selected = products.firstWhere(
                      (p) => p['id'] == product['id'],
                      orElse: () => product,
                    );

                    if (!mounted) {
                      return;
                    }

                    setState(() {
                      selectedProduct = selected;
                      quantityController.text = '1';

                      unitPriceController.text = selected['selling_price']
                          .toString();
                    });

                    quantityFocusNode.requestFocus();

                    if (!mounted) {
                      return;
                    }

                    messenger.showSnackBar(
                      SnackBar(content: Text(product['name'])),
                    );
                  } catch (_) {
                    if (!mounted) {
                      return;
                    }

                    messenger.showSnackBar(
                      const SnackBar(content: Text('Product not found')),
                    );
                  }
                },
              ),
            ),

            const SizedBox(height: 15),

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
                  unitPriceController.text = value['selling_price'].toString();
                });
              },
            ),

            const SizedBox(height: 15),

            TextField(
              focusNode: quantityFocusNode,
              controller: quantityController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              textInputAction: TextInputAction.next,
              onSubmitted: (_) {
                addItem();
              },
              decoration: const InputDecoration(labelText: 'Quantity'),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: unitPriceController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),

              textInputAction: TextInputAction.done,

              onChanged: (_) {
                setState(() {});
              },

              onSubmitted: (_) {
                addItem();
              },

              decoration: const InputDecoration(labelText: 'Unit Price'),
            ),

            const SizedBox(height: 15),

            Card(
              color: Colors.green.shade50,

              child: Padding(
                padding: const EdgeInsets.all(16),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    const Text('Line Total'),

                    Text(
                      currencyFormatter.format(lineTotal),

                      style: const TextStyle(
                        fontSize: 18,

                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: addItem,
                icon: const Icon(Icons.add),
                label: const Text('Add Item'),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              'Purchase Items',
              style: Theme.of(context).textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            if (purchaseItems.isEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Center(
                    child: Text(
                      'No items added yet',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ),
                ),
              )
            else
              ...purchaseItems.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;

                final quantity =
                    double.tryParse(item['quantity'].toString()) ?? 0;

                final unitPrice =
                    double.tryParse(item['unit_price'].toString()) ?? 0;

                final total = quantity * unitPrice;

                return Card(
                  margin: const EdgeInsets.only(bottom: 10),

                  child: ListTile(
                    title: Text(
                      item['item_name'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),

                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Quantity: ${quantity.toStringAsFixed(0)}'),
                        Text(
                          'Unit Price: ${currencyFormatter.format(unitPrice)}',
                        ),
                      ],
                    ),

                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,

                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            currencyFormatter.format(total),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),

                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),

                          onPressed: () {
                            purchaseItems.removeAt(index);

                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }),

            TextField(
              controller: notesController,
              decoration: const InputDecoration(labelText: 'Notes'),
            ),

            const SizedBox(height: 15),

            Card(
              color: Colors.blue.shade50,

              child: Padding(
                padding: const EdgeInsets.all(16),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    const Text(
                      'Purchase Total',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),

                    Text(
                      currencyFormatter.format(totalAmount),

                      style: const TextStyle(
                        fontSize: 20,

                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                onPressed: isSaving ? null : savePurchase,
                child: isSaving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Save Purchase'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
