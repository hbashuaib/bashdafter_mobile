import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../services/payment_service.dart';

class PaymentsScreen extends StatefulWidget {
  final int customerId;

  const PaymentsScreen({super.key, required this.customerId});

  @override
  State<PaymentsScreen> createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen> {
  final currencyFormatter = NumberFormat('#,##0.00');
  List<dynamic> payments = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadPayments();
  }

  Future<void> loadPayments() async {
    try {
      final data = await PaymentService().getPayments();

      if (!mounted) return;

      setState(() {
        payments = data
            .where((payment) => payment['customer'] == widget.customerId)
            .toList();

        isLoading = false;
      });
    } catch (e) {
      debugPrint(e.toString());

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to load payments')));

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payments')),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : payments.isEmpty
          ? const Center(child: Text('No payments found'))
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: payments.length,

              itemBuilder: (context, index) {
                final payment = payments[index];

                return Card(
                  child: ListTile(
                    title: Text(
                      'YER ${currencyFormatter.format(double.tryParse(payment['amount'].toString()) ?? 0)}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Text(payment['payment_date']),

                        if ((payment['notes'] ?? '').toString().isNotEmpty)
                          Text(payment['notes']),
                      ],
                    ),
                    trailing: Icon(Icons.payment, color: Colors.green.shade700),
                  ),
                );
              },
            ),
    );
  }
}
