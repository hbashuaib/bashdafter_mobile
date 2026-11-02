import 'package:flutter/material.dart';

import '../services/customer_detail_service.dart';
import '../services/update_customer_service.dart';
import '../../purchases/screens/purchases_screen.dart';
import '../../payments/screens/payments_screen.dart';
import '../../reports/screens/customer_statement_screen.dart';
import '../../payments/screens/add_payment_screen.dart';
import '../../purchases/screens/add_purchase_screen.dart';
import 'edit_customer_screen.dart';

class CustomerDetailScreen extends StatefulWidget {
  final int customerId;

  const CustomerDetailScreen({super.key, required this.customerId});

  @override
  State<CustomerDetailScreen> createState() => _CustomerDetailScreenState();
}

class _CustomerDetailScreenState extends State<CustomerDetailScreen> {
  Map<String, dynamic>? customer;

  @override
  void initState() {
    super.initState();
    loadCustomer();
  }

  Future<void> loadCustomer() async {
    final data = await CustomerDetailService().getCustomer(widget.customerId);

    setState(() {
      customer = data;
    });
  }

  Future<void> deactivateCustomer() async {
    final balance = double.tryParse(customer!['balance'].toString()) ?? 0;

    if (balance != 0) {
      showDialog(
        context: context,

        builder: (_) {
          return AlertDialog(
            title: const Text('Cannot Deactivate'),

            content: const Text(
              'Customer balance must be zero before deactivation.',
            ),

            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },

                child: const Text('OK'),
              ),
            ],
          );
        },
      );

      return;
    }

    final confirm = await showDialog<bool>(
      context: context,

      builder: (_) {
        return AlertDialog(
          title: const Text('Deactivate Customer'),
          content: Text('Deactivate ${customer!['name']} ?'),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },

              child: const Text('Cancel'),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },

              child: const Text('Deactivate'),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    await UpdateCustomerService().updateCustomer(
      customerId: customer!['id'],
      name: customer!['name'],
      phone: customer!['phone'],
      address: customer!['address'],
      notes: customer!['notes'],
      isActive: false,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Customer deactivated successfully')),
    );

    Navigator.pop(context);
  }

  Future<void> reactivateCustomer() async {
    await UpdateCustomerService().updateCustomer(
      customerId: customer!['id'],
      name: customer!['name'],
      phone: customer!['phone'],
      address: customer!['address'],
      notes: customer!['notes'],
      isActive: true,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Customer reactivated successfully')),
    );

    loadCustomer();
  }

  @override
  Widget build(BuildContext context) {
    if (customer == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(customer!['name']),

        actions: [
          IconButton(
            icon: const Icon(Icons.edit),

            onPressed: () async {
              final result = await Navigator.push(
                context,

                MaterialPageRoute(
                  builder: (_) => EditCustomerScreen(customer: customer!),
                ),
              );

              if (result == true) {
                loadCustomer();
              }
            },
          ),

          IconButton(
            icon: Icon(
              customer!['is_active'] ? Icons.person_off : Icons.person,
            ),

            onPressed: customer!['is_active']
                ? deactivateCustomer
                : reactivateCustomer,
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text('Phone: ${customer!['phone']}'),
            const SizedBox(height: 10),
            Text('Balance: ${customer!['balance']}'),
            const SizedBox(height: 10),
            Text('Address: ${customer!['address']}'),
            const SizedBox(height: 10),
            Text('Notes: ${customer!['notes']}'),
            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,

                  MaterialPageRoute(
                    builder: (_) =>
                        PurchasesScreen(customerId: widget.customerId),
                  ),
                );
              },

              child: const Text('Purchases'),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,

                  MaterialPageRoute(
                    builder: (_) =>
                        PaymentsScreen(customerId: widget.customerId),
                  ),
                );
              },

              child: const Text('Payments'),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,

                  MaterialPageRoute(
                    builder: (_) =>
                        CustomerStatementScreen(customerId: widget.customerId),
                  ),
                );
              },

              child: const Text('Statement'),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,

                  MaterialPageRoute(
                    builder: (_) =>
                        AddPaymentScreen(customerId: widget.customerId),
                  ),
                );

                if (result == true) {
                  loadCustomer();
                }
              },

              child: const Text('Add Payment'),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,

                  MaterialPageRoute(
                    builder: (_) =>
                        AddPurchaseScreen(customerId: widget.customerId),
                  ),
                );

                if (result == true) {
                  loadCustomer();
                }
              },

              child: const Text('Add Purchase'),
            ),
          ],
        ),
      ),
    );
  }
}
