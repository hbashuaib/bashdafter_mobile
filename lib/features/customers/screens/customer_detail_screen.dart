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

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      customer!['name'],

                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.phone),
                      title: Text(customer!['phone']),
                    ),

                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.account_balance_wallet),
                      title: Text('Balance'),
                      trailing: Text(
                        customer!['balance'].toString(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),

                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.location_on),
                      title: Text(customer!['address']),
                    ),

                    if ((customer!['notes'] ?? '').toString().isNotEmpty)
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.note),
                        title: Text(customer!['notes']),
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Quick Actions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.add_shopping_cart),
                    label: const Text('Purchase'),

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
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.payments),
                    label: const Text('Payment'),

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
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            const Text(
              'Records',

              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            Card(
              child: ListTile(
                leading: const Icon(Icons.shopping_bag),
                title: const Text('Purchases'),
                trailing: const Icon(Icons.arrow_forward_ios),

                onTap: () {
                  Navigator.push(
                    context,

                    MaterialPageRoute(
                      builder: (_) =>
                          PurchasesScreen(customerId: widget.customerId),
                    ),
                  );
                },
              ),
            ),

            Card(
              child: ListTile(
                leading: const Icon(Icons.payments),
                title: const Text('Payments'),
                trailing: const Icon(Icons.arrow_forward_ios),

                onTap: () {
                  Navigator.push(
                    context,

                    MaterialPageRoute(
                      builder: (_) =>
                          PaymentsScreen(customerId: widget.customerId),
                    ),
                  );
                },
              ),
            ),

            Card(
              child: ListTile(
                leading: const Icon(Icons.receipt_long),
                title: const Text('Statement'),
                trailing: const Icon(Icons.arrow_forward_ios),

                onTap: () {
                  Navigator.push(
                    context,

                    MaterialPageRoute(
                      builder: (_) => CustomerStatementScreen(
                        customerId: widget.customerId,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
