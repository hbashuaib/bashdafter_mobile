import 'package:flutter/material.dart';

import '../services/create_purchase_service.dart';
import '../services/create_purchase_item_service.dart';
import '../../products/services/product_service.dart';

class AddPurchaseScreen extends StatefulWidget {
  final int customerId;
  const AddPurchaseScreen({super.key, required this.customerId});

  @override
  State<AddPurchaseScreen> createState() => _AddPurchaseScreenState();
}

class _AddPurchaseScreenState extends State<AddPurchaseScreen> {
  final itemController = TextEditingController();
  final quantityController = TextEditingController();
  final unitPriceController = TextEditingController();
  final notesController = TextEditingController();

  bool isSaving = false;
  List<Map<String, dynamic>> purchaseItems = [];
  List<dynamic> products = [];
  dynamic selectedProduct;

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  void addItem() {
    if (selectedProduct == null) {
      return;
    }

    purchaseItems.add({
      'product_id': selectedProduct['id'],
      'item_name': selectedProduct['name'],
      'quantity': quantityController.text,
      'unit_price': unitPriceController.text,
    });

    itemController.clear();
    quantityController.clear();
    unitPriceController.clear();
    setState(() {});
  }

  Future<void> loadProducts() async {
    final data = await ProductService().getProducts();

    setState(() {
      products = data;
    });
  }

  Future<void> savePurchase() async {
    if (purchaseItems.isEmpty) {
      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      final purchaseId = await CreatePurchaseService().createPurchase(
        customerId: widget.customerId,
        notes: notesController.text,
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

      Navigator.pop(context, true);
    } catch (e) {
      debugPrint(e.toString());
    }

    if (!mounted) return;

    setState(() {
      isSaving = false;
    });
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

      body: Padding(
        padding: const EdgeInsets.all(20),

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
                  unitPriceController.text = value['selling_price'];
                });
              },
            ),

            const SizedBox(height: 15),

            TextField(
              controller: quantityController,
              keyboardType: TextInputType.number,
              onChanged: (_) {
                setState(() {});
              },

              decoration: const InputDecoration(labelText: 'Quantity'),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: unitPriceController,
              keyboardType: TextInputType.number,
              onChanged: (_) {
                setState(() {});
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
                      lineTotal.toStringAsFixed(2),

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

            ElevatedButton(onPressed: addItem, child: const Text('Add Item')),

            const SizedBox(height: 15),

            Expanded(
              child: ListView.builder(
                itemCount: purchaseItems.length,

                itemBuilder: (context, index) {
                  final item = purchaseItems[index];

                  return Card(
                    child: ListTile(
                      title: Text(item['item_name']),

                      subtitle: Text(
                        '${item['quantity']} × ${item['unit_price']}',
                      ),

                      trailing: IconButton(
                        icon: const Icon(Icons.delete),

                        onPressed: () {
                          purchaseItems.removeAt(index);
                          setState(() {});
                        },
                      ),
                    ),
                  );
                },
              ),
            ),

            TextField(
              controller: notesController,
              decoration: const InputDecoration(labelText: 'Notes'),
            ),

            const SizedBox(height: 15),

            Text(
              'Total: ${totalAmount.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: isSaving ? null : savePurchase,
              child: Text(isSaving ? 'Saving...' : 'Save Purchase'),
            ),
          ],
        ),
      ),
    );
  }
}
