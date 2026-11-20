import 'package:flutter/material.dart';

import '../services/create_customer_service.dart';
import '../../../core/localization/localization_extension.dart';

class AddCustomerScreen extends StatefulWidget {
  const AddCustomerScreen({super.key});

  @override
  State<AddCustomerScreen> createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<AddCustomerScreen> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final notesController = TextEditingController();

  bool isSaving = false;

  Future<void> saveCustomer() async {
    if (nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.customerNameRequired)),
      );

      return;
    }

    if (phoneController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.l10n.phoneNumberRequired)));

      return;
    }

    if (phoneController.text.trim().length < 7) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.enterValidPhoneNumber)),
      );

      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      await CreateCustomerService().createCustomer(
        name: nameController.text.trim(),
        phone: phoneController.text.trim(),
        address: addressController.text.trim(),
        notes: notesController.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.customerAddedSuccessfully)),
      );

      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.failedToSaveCustomer)),
      );

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
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.addCustomer)),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            TextField(
              controller: nameController,
              textCapitalization: TextCapitalization.words,
              textDirection: Directionality.of(context),
              decoration: InputDecoration(labelText: context.l10n.name),
              textInputAction: TextInputAction.next,
            ),

            const SizedBox(height: 15),

            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              autocorrect: false,
              enableSuggestions: false,
              textDirection: Directionality.of(context),
              decoration: InputDecoration(labelText: context.l10n.phone),
              textInputAction: TextInputAction.next,
            ),

            const SizedBox(height: 15),

            TextField(
              controller: addressController,
              textDirection: Directionality.of(context),
              decoration: InputDecoration(labelText: context.l10n.address),
              textInputAction: TextInputAction.next,
            ),

            const SizedBox(height: 15),

            TextField(
              controller: notesController,
              maxLines: 3,
              textDirection: Directionality.of(context),
              decoration: InputDecoration(labelText: context.l10n.notes),
              textInputAction: TextInputAction.done,

              onSubmitted: (_) {
                if (!isSaving) {
                  saveCustomer();
                }
              },
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                onPressed: isSaving ? null : saveCustomer,

                child: isSaving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(context.l10n.saveCustomer),
              ),
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
