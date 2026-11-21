import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/create_payment_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/localization/localization_extension.dart';
import '../../../core/localization/app_formatters.dart';
import '../../../core/providers/shop_provider.dart';

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
        SnackBar(content: Text(context.l10n.paymentAmountRequired)),
      );

      return;
    }

    final amount = double.tryParse(amountController.text.trim());

    if (amount == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(context.l10n.enterValidAmount)));

      return;
    }

    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.amountMustBeGreaterThanZero)),
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
        SnackBar(content: Text(context.l10n.paymentAddedSuccessfully)),
      );

      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.l10n.failedToSavePayment)));

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
  void dispose() {
    amountController.dispose();
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.addPayment)),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            TextField(
              controller: amountController,
              textDirection: Directionality.of(context),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              autocorrect: false,
              enableSuggestions: false,
              textInputAction: TextInputAction.next,

              onChanged: (_) {
                setState(() {});
              },

              decoration: InputDecoration(labelText: context.l10n.amount),
            ),

            const SizedBox(height: 15),

            Card(
              color: AppColors.cardTint(context, Colors.green.shade50),

              child: Padding(
                padding: const EdgeInsets.all(16),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    Text(context.l10n.paymentPreview),

                    Text(
                      AppFormatters.currency(
                        context,
                        double.tryParse(amountController.text) ?? 0,
                        context.read<ShopProvider>().currency,
                      ),

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
              textDirection: Directionality.of(context),
              decoration: InputDecoration(labelText: context.l10n.notes),
              textInputAction: TextInputAction.done,

              onSubmitted: (_) {
                if (!isSaving) {
                  savePayment();
                }
              },
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
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
                    : Text(context.l10n.savePayment),
              ),
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
