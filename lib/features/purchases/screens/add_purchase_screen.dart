import 'package:flutter/material.dart';

import '../services/create_purchase_service.dart';
import '../services/create_purchase_item_service.dart';

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

  Future<void> savePurchase() async {
    setState(() {
      isSaving = true;
    });

    try {
      final purchaseId = await CreatePurchaseService().createPurchase(
        customerId: widget.customerId,

        notes: notesController.text,
      );

      await CreatePurchaseItemService().createItem(
        purchaseId: purchaseId,

        itemName: itemController.text,

        quantity: quantityController.text,

        unitPrice: unitPriceController.text,
      );

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Purchase')),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            TextField(
              controller: itemController,
              decoration: const InputDecoration(labelText: 'Item Name'),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: quantityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Quantity'),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: unitPriceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Unit Price'),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: notesController,
              decoration: const InputDecoration(labelText: 'Notes'),
            ),

            const SizedBox(height: 30),

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
