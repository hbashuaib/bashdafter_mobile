import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../services/payment_service.dart';

import 'payment_detail_screen.dart';

class PaymentsScreen extends StatefulWidget {
  final int customerId;

  const PaymentsScreen({super.key, required this.customerId});

  @override
  State<PaymentsScreen> createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen> {
  final currencyFormatter = NumberFormat('#,##0.00');
  List<dynamic> payments = [];
  List<dynamic> filteredPayments = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadPayments();
  }

  Future<void> loadPayments() async {
    try {
      final data = await PaymentService().getPayments();
      final customerPayments = data
          .where((payment) => payment['customer'] == widget.customerId)
          .toList();

      if (!mounted) return;

      setState(() {
        payments = customerPayments;
        filteredPayments = customerPayments;
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

  void searchPayments(String value) {
    final query = value.toLowerCase();

    setState(() {
      filteredPayments = payments.where((payment) {
        final amount = payment['amount'].toString().toLowerCase();
        final date = payment['payment_date'].toString().toLowerCase();
        final notes = (payment['notes'] ?? '').toString().toLowerCase();

        return amount.contains(query) ||
            date.contains(query) ||
            notes.contains(query);
      }).toList();
    });
  }

  double get averagePayment {
    if (payments.isEmpty) {
      return 0;
    }

    final total = payments.fold(
      0.0,
      (sum, payment) =>
          sum + (double.tryParse(payment['amount'].toString()) ?? 0),
    );

    return total / payments.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payments')),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Card(
                  margin: const EdgeInsets.all(12),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            const Text('Payments'),
                            Text(
                              payments.length.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            const Text('Total'),
                            Text(
                              'YER ${currencyFormatter.format(payments.fold(0.0, (sum, payment) => sum + (double.tryParse(payment['amount'].toString()) ?? 0)))}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            const Text('Average'),

                            Text(
                              'YER ${currencyFormatter.format(averagePayment)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    onChanged: searchPayments,
                    decoration: const InputDecoration(
                      hintText: 'Search by date, notes or amount',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Center(
                    child: Text(
                      'Showing ${filteredPayments.length} of ${payments.length} payments',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),

                Expanded(
                  child: payments.isEmpty
                      ? ListView(
                          children: const [
                            SizedBox(height: 150),
                            Center(child: Text('No payments found')),
                          ],
                        )
                      : RefreshIndicator(
                          onRefresh: loadPayments,
                          child: ListView.builder(
                            padding: const EdgeInsets.all(8),
                            itemCount: filteredPayments.length,

                            itemBuilder: (context, index) {
                              final payment = filteredPayments[index];

                              return Card(
                                child: ListTile(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => PaymentDetailScreen(
                                          payment: payment,
                                        ),
                                      ),
                                    );
                                  },

                                  title: Text(
                                    'YER ${currencyFormatter.format(double.tryParse(payment['amount'].toString()) ?? 0)}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,

                                    children: [
                                      Text(payment['payment_date']),

                                      if ((payment['notes'] ?? '')
                                          .toString()
                                          .isNotEmpty)
                                        Text(payment['notes']),
                                    ],
                                  ),

                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,

                                    children: [
                                      Icon(
                                        Icons.payment,
                                        color: Colors.green.shade700,
                                      ),

                                      const SizedBox(width: 8),

                                      const Icon(
                                        Icons.arrow_forward_ios,
                                        size: 16,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                ),
              ],
            ),
    );
  }
}
