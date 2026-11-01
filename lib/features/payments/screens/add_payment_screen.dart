import 'package:flutter/material.dart';

import '../services/create_payment_service.dart';

class AddPaymentScreen extends StatefulWidget {
  final int customerId;

  const AddPaymentScreen({super.key, required this.customerId});

  @override
  State<AddPaymentScreen> createState() => _AddPaymentScreenState();
}

class _AddPaymentScreenState extends State<AddPaymentScreen> {
  final amountController = TextEditingController();

  final notesController = TextEditingController();

  bool isSaving = false;

  Future<void> savePayment() async {
    setState(() {
      isSaving = true;
    });

    try {
      await CreatePaymentService().createPayment(
        customerId: widget.customerId,

        amount: amountController.text,

        paymentDate: DateTime.now().toIso8601String().split('T').first,

        notes: notesController.text,
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
      appBar: AppBar(title: const Text('Add Payment')),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Amount'),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: notesController,
              decoration: const InputDecoration(labelText: 'Notes'),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: isSaving ? null : savePayment,

              child: Text(isSaving ? 'Saving...' : 'Save Payment'),
            ),
          ],
        ),
      ),
    );
  }
}
