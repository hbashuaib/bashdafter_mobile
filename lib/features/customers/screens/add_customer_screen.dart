import 'package:flutter/material.dart';

import '../services/create_customer_service.dart';

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
    setState(() {
      isSaving = true;
    });

    try {
      await CreateCustomerService().createCustomer(
        name: nameController.text,

        phone: phoneController.text,

        address: addressController.text,

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
      appBar: AppBar(title: const Text('Add Customer')),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
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

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: isSaving ? null : saveCustomer,

              child: Text(isSaving ? 'Saving...' : 'Save Customer'),
            ),
          ],
        ),
      ),
    );
  }
}
