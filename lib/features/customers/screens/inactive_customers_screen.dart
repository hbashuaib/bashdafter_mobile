import 'package:flutter/material.dart';

import '../services/inactive_customer_service.dart';
import '../models/customer_model.dart';
import '../../../core/localization/localization_extension.dart';

class InactiveCustomersScreen extends StatefulWidget {
  const InactiveCustomersScreen({super.key});

  @override
  State<InactiveCustomersScreen> createState() =>
      _InactiveCustomersScreenState();
}

class _InactiveCustomersScreenState extends State<InactiveCustomersScreen> {
  final InactiveCustomerService _service = InactiveCustomerService();
  List<CustomerModel> customers = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();

    loadCustomers();
  }

  Future<void> loadCustomers() async {
    try {
      final data = await _service.getInactiveCustomers();

      if (!mounted) return;

      setState(() {
        customers = data;
        errorMessage = null;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        errorMessage = context.l10n.failedToLoadInactiveCustomers;
        isLoading = false;
      });
    }
  }

  Future<void> showRestoreConfirmation(CustomerModel customer,) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(context.l10n.restoreCustomer),
          content: Text(
            '${context.l10n.restoreCustomerQuestion}\n\n'
            '${customer.name}',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: Text(context.l10n.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: Text(context.l10n.restore),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await restoreCustomer(customer);
    }
  }

  Future<void> restoreCustomer(CustomerModel customer,) async {
    try {
      await _service.restoreCustomer(customer.id,);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${customer.name} '
            '${context.l10n.customerRestoredSuccessfully}',
          ),
        ),
      );

      await loadCustomers();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.failedToRestoreCustomer)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (errorMessage != null) {
      return Scaffold(
        appBar: AppBar(title: Text(context.l10n.inactiveCustomers)),
        body: Center(child: Text(errorMessage!)),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.inactiveCustomers)),
      body: RefreshIndicator(
        onRefresh: loadCustomers,
        child: customers.isEmpty
            ? ListView(
                children: [
                  const SizedBox(height: 150),
                  Center(child: Text(context.l10n.noInactiveCustomers)),
                ],
              )
            : ListView.builder(
                padding: const EdgeInsets.only(bottom: 100),
                itemCount: customers.length,
                itemBuilder: (context, index) {
                  final customer = customers[index];

                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text(
                          customer.name.isNotEmpty
                              ? customer.name[0].toUpperCase()
                              : '?',
                        ),
                      ),
                      title: Text(customer.name),
                      subtitle: Text(customer.phone),
                      trailing: IconButton(
                        icon: const Icon(Icons.restore, color: Colors.green),
                        onPressed: () {
                          showRestoreConfirmation(customer);
                        },
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
