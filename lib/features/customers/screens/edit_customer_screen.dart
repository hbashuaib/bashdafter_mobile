import 'package:flutter/material.dart';

import '../services/update_customer_service.dart';
import '../models/customer_model.dart';
import '../../../core/localization/localization_extension.dart';
import '../../../core/widgets/app_form_field_helper.dart';

class EditCustomerScreen extends StatefulWidget {
  final CustomerModel customer;
  const EditCustomerScreen({super.key, required this.customer});

  @override
  State<EditCustomerScreen> createState() => _EditCustomerScreenState();
}

class _EditCustomerScreenState extends State<EditCustomerScreen> {
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController addressController;
  late TextEditingController notesController;

  bool isActive = true;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.customer.name);
    phoneController = TextEditingController(text: widget.customer.phone);
    addressController = TextEditingController(text: widget.customer.address);
    notesController = TextEditingController(text: widget.customer.notes);
    isActive = widget.customer.isActive;
  }

  Future<void> saveChanges() async {
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
      await UpdateCustomerService().updateCustomer(
        customerId: widget.customer.id,
        name: nameController.text.trim(),
        phone: phoneController.text.trim(),
        address: addressController.text.trim(),
        notes: notesController.text.trim(),
        isActive: isActive,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.customerUpdatedSuccessfully)),
      );

      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.failedToUpdateCustomer)),
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
      appBar: AppBar(title: Text(context.l10n.editCustomer)),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            TextField(
              controller: nameController,
              textDirection: Directionality.of(context),
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              decoration: AppFormFieldHelper.decoration(
                context: context,
                label: context.l10n.name,
                required: true,
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: phoneController,
              textDirection: TextDirection.ltr,
              keyboardType: TextInputType.phone,
              autocorrect: false,
              enableSuggestions: false,
              textInputAction: TextInputAction.next,
              decoration: AppFormFieldHelper.decoration(
                context: context,
                label: context.l10n.phone,
                required: true,
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: addressController,
              textDirection: Directionality.of(context),
              textInputAction: TextInputAction.next,
              decoration: AppFormFieldHelper.decoration(
                context: context,
                label: context.l10n.address,
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: notesController,
              textDirection: Directionality.of(context),
              maxLines: 3,
              textInputAction: TextInputAction.done,

              onSubmitted: (_) {
                if (!isSaving) {
                  saveChanges();
                }
              },

              decoration: AppFormFieldHelper.decoration(
                context: context,
                label: context.l10n.notes,
              ),
            ),

            const SizedBox(height: 15),

            SwitchListTile(
              title: Text(context.l10n.activeStatus),

              value: isActive,

              onChanged: (value) {
                setState(() {
                  isActive = value;
                });
              },
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                onPressed: isSaving ? null : saveChanges,

                child: isSaving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(context.l10n.saveChanges),
              ),
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
