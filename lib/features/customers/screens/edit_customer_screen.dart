import 'package:flutter/material.dart';

import '../services/update_customer_service.dart';

class EditCustomerScreen extends StatefulWidget {
  final Map<String, dynamic> customer;

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

    nameController = TextEditingController(text: widget.customer['name']);

    phoneController = TextEditingController(text: widget.customer['phone']);

    addressController = TextEditingController(text: widget.customer['address']);

    notesController = TextEditingController(text: widget.customer['notes']);

    isActive = widget.customer['is_active'];
  }

  Future<void> saveChanges() async {
    setState(() {
      isSaving = true;
    });

    try {
      await UpdateCustomerService().updateCustomer(
        customerId: widget.customer['id'],

        name: nameController.text,

        phone: phoneController.text,

        address: addressController.text,

        notes: notesController.text,

        isActive: isActive,
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
      appBar: AppBar(title: const Text('Edit Customer')),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: ListView(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: 'Phone'),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: addressController,
              decoration: const InputDecoration(labelText: 'Address'),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: notesController,
              decoration: const InputDecoration(labelText: 'Notes'),
            ),

            const SizedBox(height: 15),

            SwitchListTile(
              title: const Text('Active'),

              value: isActive,

              onChanged: (value) {
                setState(() {
                  isActive = value;
                });
              },
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: isSaving ? null : saveChanges,

              child: Text(isSaving ? 'Saving...' : 'Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
