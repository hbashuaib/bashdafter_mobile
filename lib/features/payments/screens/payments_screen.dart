import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/payment_service.dart';
import '../models/payment_model.dart';
import '../../../core/widgets/app_loading_scaffold.dart';
import '../../../core/widgets/app_refreshable_empty_state.dart';
import '../../../core/localization/localization_extension.dart';
import '../../../core/localization/app_formatters.dart';
import '../../../core/providers/shop_provider.dart';

import 'payment_detail_screen.dart';

class PaymentsScreen extends StatefulWidget {
  final int customerId;

  const PaymentsScreen({super.key, required this.customerId});

  @override
  State<PaymentsScreen> createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen> {
  final searchController = TextEditingController();
  List<PaymentModel> payments = [];
  List<PaymentModel> filteredPayments = [];
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
          .where((payment) => payment.customer == widget.customerId)
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

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.failedToLoadPayments)),
      );

      setState(() {
        isLoading = false;
      });
    }
  }

  void searchPayments(String value) {
    final query = value.toLowerCase().trim();

    setState(() {
      filteredPayments = payments.where((payment) {
        final amount = payment.amount.toLowerCase();
        final date = payment.paymentDate.toLowerCase();
        final notes = payment.notes.toLowerCase();

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
      (sum, payment) => sum + (double.tryParse(payment.amount) ?? 0),
    );

    return total / payments.length;
  }

  double get totalPaymentsAmount {
    return payments.fold(
      0.0,
      (sum, payment) => sum + (double.tryParse(payment.amount) ?? 0),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return AppLoadingScaffold(message: context.l10n.loadingPayments);
    }

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.payments)),

      body: Column(
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
                      Text(context.l10n.payments),
                      Text(
                        // payments.length.toString(),
                        AppFormatters.number(context, payments.length),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(context.l10n.total),
                      Text(
                        // 'YER ${currencyFormatter.format(totalPaymentsAmount)}',
                        AppFormatters.currency(
                          context,
                          totalPaymentsAmount,
                          context.read<ShopProvider>().currency,
                        ),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(context.l10n.average),

                      Text(
                        // 'YER ${currencyFormatter.format(averagePayment)}',
                        AppFormatters.currency(
                          context,
                          averagePayment,
                          context.read<ShopProvider>().currency,
                        ),
                        style: const TextStyle(fontWeight: FontWeight.bold),
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
              controller: searchController,

              onChanged: (value) {
                searchPayments(value);

                setState(() {});
              },

              decoration: InputDecoration(
                hintText: context.l10n.searchPayments,
                prefixIcon: const Icon(Icons.search),

                suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),

                        onPressed: () {
                          searchController.clear();
                          searchPayments('');
                          setState(() {});
                        },
                      )
                    : null,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Center(
              child: Text(
                '${context.l10n.showing} '
                '${AppFormatters.number(context, filteredPayments.length)} '
                '${context.l10n.outOf} '
                '${AppFormatters.number(context, payments.length)} '
                '${context.l10n.showingPayments}',

                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),

          Expanded(
            child: filteredPayments.isEmpty
                ? AppRefreshableEmptyState(
                    message: context.l10n.noPaymentsFound,
                    icon: Icons.payment_outlined,
                    onRefresh: loadPayments,
                  )
                : RefreshIndicator(
                    onRefresh: loadPayments,
                    child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 100),
                      itemCount: filteredPayments.length,

                      itemBuilder: (context, index) {
                        final payment = filteredPayments[index];
                        final amount = double.tryParse(payment.amount) ?? 0;

                        return Card(
                          child: ListTile(
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      PaymentDetailScreen(payment: payment),
                                ),
                              );

                              if (mounted) {
                                loadPayments();
                              }
                            },

                            title: Text(
                              // 'YER ${currencyFormatter.format(amount)}',
                              AppFormatters.currency(
                                context,
                                amount,
                                context.read<ShopProvider>().currency,
                              ),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [
                                Text(
                                  AppFormatters.date(
                                    context,
                                    DateTime.parse(payment.paymentDate),
                                  ),
                                ),

                                if (payment.notes.isNotEmpty)
                                  Text(payment.notes),
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

                                const Icon(Icons.arrow_forward_ios, size: 16),
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
