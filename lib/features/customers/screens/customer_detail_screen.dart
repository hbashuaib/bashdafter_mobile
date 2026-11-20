import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../services/customer_detail_service.dart';
import '../services/update_customer_service.dart';
import '../../purchases/screens/purchases_screen.dart';
import '../../payments/screens/payments_screen.dart';
import '../../reports/screens/customer_statement_screen.dart';
import '../../payments/screens/add_payment_screen.dart';
import '../../purchases/screens/add_purchase_screen.dart';
import '../../../core/storage/token_storage.dart';
import '../../auth/models/user_profile.dart';
import '../../../core/localization/localization_extension.dart';

import 'edit_customer_screen.dart';

class CustomerDetailScreen extends StatefulWidget {
  final int customerId;

  const CustomerDetailScreen({super.key, required this.customerId});

  @override
  State<CustomerDetailScreen> createState() => _CustomerDetailScreenState();
}

class _CustomerDetailScreenState extends State<CustomerDetailScreen> {
  final currencyFormatter = NumberFormat('#,##0.00');
  Map<String, dynamic>? customer;
  UserProfile? currentUser;

  @override
  void initState() {
    super.initState();
    loadCustomer();
    loadCurrentUser();
  }

  Future<void> loadCustomer() async {
    try {
      final data = await CustomerDetailService().getCustomer(widget.customerId);

      if (!mounted) return;

      setState(() {
        customer = data;
      });
    } catch (e) {
      debugPrint(e.toString());

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.failedToLoadCustomer)),
      );
    }
  }

  Future<void> loadCurrentUser() async {
    final profile = await TokenStorage.getProfile();

    if (!mounted) return;

    setState(() {
      currentUser = profile;
    });
  }

  Future<void> deactivateCustomer() async {
    final balance = double.tryParse(customer!['balance'].toString()) ?? 0;

    if (balance != 0) {
      showDialog(
        context: context,

        builder: (_) {
          return AlertDialog(
            title: Text(context.l10n.cannotDeactivate),

            content: Text(context.l10n.customerBalanceMustBeZero),

            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },

                child: Text(context.l10n.ok),
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
          title: Text(context.l10n.deactivateCustomer),
          content: Text(
            '${context.l10n.deactivateCustomerQuestion}\n\n${customer!['name']}',
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },

              child: Text(context.l10n.cancel),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },

              child: Text(context.l10n.deactivate),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    try {
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
        SnackBar(content: Text(context.l10n.customerDeactivatedSuccessfully)),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.failedToDeactivateCustomer)),
      );
    }
  }

  Future<void> reactivateCustomer() async {
    try {
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
        SnackBar(content: Text(context.l10n.customerReactivatedSuccessfully)),
      );

      loadCustomer();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.failedToReactivateCustomer)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final customerBalance =
        double.tryParse(customer?['balance']?.toString() ?? '0') ?? 0;

    final hasBalance = customerBalance > 0;

    if (customer == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(customer!['name']),

        actions: [
          if (currentUser != null && !currentUser!.isCashier)
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

          if (currentUser != null &&
              (currentUser!.isOwner || currentUser!.isAdmin))
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
                      title: Text(context.l10n.balance),
                      trailing: Text(
                        currencyFormatter.format(customerBalance),

                        style: TextStyle(
                          fontWeight: FontWeight.bold,

                          color: hasBalance ? Colors.orange : Colors.green,
                        ),
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

            Text(
              context.l10n.quickActions,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.add_shopping_cart),
                    label: Text(context.l10n.purchase),

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
                    label: Text(context.l10n.payment),

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

            Text(
              context.l10n.records,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            Card(
              child: ListTile(
                leading: const Icon(Icons.shopping_bag),
                title: Text(context.l10n.purchases),
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
                title: Text(context.l10n.payments),
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
                title: Text(context.l10n.statement),
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

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
