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
    if (amountController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment amount is required')),
      );

      return;
    }

    final amount = double.tryParse(amountController.text.trim());

    if (amount == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Enter a valid amount')));

      return;
    }

    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Amount must be greater than zero')),
      );

      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      await CreatePaymentService().createPayment(
        customerId: widget.customerId,
        amount: amountController.text.trim(),
        paymentDate: DateTime.now().toIso8601String().split('T').first,
        notes: notesController.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment added successfully')),
      );

      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to save payment')));

      debugPrint(e.toString());
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
      appBar: AppBar(title: const Text('Add Payment')),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            TextField(
              controller: amountController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              textInputAction: TextInputAction.next,

              onChanged: (_) {
                setState(() {});
              },

              decoration: const InputDecoration(labelText: 'Amount'),
            ),

            const SizedBox(height: 15),

            Card(
              color: Colors.green.shade50,

              child: Padding(
                padding: const EdgeInsets.all(16),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    const Text('Payment Amount'),

                    Text(
                      amountController.text.isEmpty
                          ? '0'
                          : amountController.text,

                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: notesController,
              decoration: const InputDecoration(labelText: 'Notes'),
              textInputAction: TextInputAction.done,

              onSubmitted: (_) {
                if (!isSaving) {
                  savePayment();
                }
              },
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: isSaving ? null : savePayment,
              child: isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Save Payment'),
            ),
          ],
        ),
      ),
    );
  }
}
