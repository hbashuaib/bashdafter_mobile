import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:provider/provider.dart';

import '../services/customer_statement_service.dart';
import '../services/customer_statement_pdf_service.dart';
import '../models/customer_statement_model.dart';
import '../models/customer_statement_transaction_model.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_loading_scaffold.dart';
import '../../../core/widgets/app_refreshable_empty_state.dart';
import '../../../core/localization/localization_extension.dart';
import '../../../core/localization/app_formatters.dart';
import '../../../core/providers/shop_provider.dart';
import '../../../core/utils/whatsapp_receipt_builder.dart';
import '../../../core/widgets/app_search_field.dart';

class CustomerStatementScreen extends StatefulWidget {
  final int customerId;

  const CustomerStatementScreen({super.key, required this.customerId});

  @override
  State<CustomerStatementScreen> createState() =>
      _CustomerStatementScreenState();
}

class _CustomerStatementScreenState extends State<CustomerStatementScreen> {
  final searchController = TextEditingController();
  CustomerStatementModel? statement;
  List<CustomerStatementTransactionModel> filteredTransactions = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadStatement();
  }

  Future<void> loadStatement() async {
    try {
      setState(() {
        isLoading = true;
      });

      final data = await CustomerStatementService().getStatement(
        widget.customerId,
      );

      if (!mounted) return;

      setState(() {
        statement = data;
        filteredTransactions = List.from(data.transactions);
        isLoading = false;
      });
    } catch (e) {
      debugPrint(e.toString());

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.failedToLoadStatement)),
      );

      setState(() {
        isLoading = false;
      });
    }
  }

  void searchTransactions(String value) {
    if (statement == null) {
      return;
    }

    final query = value.toLowerCase().trim();

    setState(() {
      filteredTransactions = statement!.transactions.where((item) {
        final type = item.type.toLowerCase();
        final date = item.date.toLowerCase();
        final amount = item.amount.toString().toLowerCase();

        return type.contains(query) ||
            date.contains(query) ||
            amount.contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return AppLoadingScaffold(message: context.l10n.loadingStatement);
    }

    if (statement == null) {
      return Scaffold(
        appBar: AppBar(title: Text(context.l10n.customerStatement)),

        body: AppRefreshableEmptyState(
          message: context.l10n.noStatementAvailable,
          icon: Icons.receipt_long_outlined,
          onRefresh: loadStatement,
        ),
      );
    }

    final balance = statement!.balance.toDouble();
    final transactions = statement!.transactions;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          statement!.customer.isEmpty
              ? context.l10n.customerStatement
              : statement!.customer,
        ),

        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),

            onPressed: () async {
              if (!mounted) return;

              final messenger = ScaffoldMessenger.of(context);
              final pdfSuccessText = context.l10n.pdfGeneratedSuccessfully;
              final pdfFailedText = context.l10n.failedToGeneratePdf;

              try {
                await CustomerStatementPdfService().generatePdf(
                  context: context,
                  customer: statement!.customer,
                  balance: statement!.balance,
                  transactions: transactions,
                );

                if (!mounted) return;

                messenger.showSnackBar(SnackBar(content: Text(pdfSuccessText)));
              } catch (e) {
                debugPrint('PDF ERROR: $e');

                if (!mounted) return;

                messenger.showSnackBar(
                  SnackBar(content: Text('$pdfFailedText\n$e')),
                );
              }
            },
          ),

          IconButton(
            icon: const Icon(Icons.share),

            onPressed: () {
              SharePlus.instance.share(
                ShareParams(
                  text: WhatsAppReceiptBuilder.customerStatement(
                    context,
                    statement!,
                    statement!.transactions,
                  ),
                ),
              );
            },
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Card(
              color: AppColors.cardTint(
                context,
                balance > 0 ? Colors.red.shade50 : Colors.green.shade50,
              ),

              child: Padding(
                padding: const EdgeInsets.all(16),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,

                  children: [
                    Column(
                      children: [
                        Text(context.l10n.transactions),

                        Text(
                          // transactions.length.toString(),
                          AppFormatters.number(context, transactions.length),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),

                    Column(
                      children: [
                        Text(context.l10n.balance),

                        Text(
                          // 'YER ${currencyFormatter.format(balance)}',
                          AppFormatters.currency(
                            context,
                            balance,
                            context.read<ShopProvider>().currency,
                          ),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,

                            color: statement!.balance > 0
                                ? Colors.red
                                : Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            AppSearchField(
              controller: searchController,
              hintText: context.l10n.searchTransactions,

              onChanged: searchTransactions,

              onClear: () {
                searchController.clear();
                searchTransactions('');
              },
            ),

            const SizedBox(height: 12),

            Center(
              child: Text(
                '${context.l10n.showing} '
                '${AppFormatters.number(context, filteredTransactions.length)} '
                '${context.l10n.outOf} '
                '${AppFormatters.number(context, transactions.length)} '
                '${context.l10n.transactions}',

                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 12),

            Expanded(
              child: RefreshIndicator(
                onRefresh: loadStatement,

                child: filteredTransactions.isEmpty
                    ? AppRefreshableEmptyState(
                        message: context.l10n.noTransactionsFound,
                        icon: Icons.receipt_long_outlined,
                        onRefresh: loadStatement,
                      )
                    : ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.only(bottom: 100),
                        itemCount: filteredTransactions.length,

                        itemBuilder: (context, index) {
                          final item = filteredTransactions[index];
                          final runningBalance = item.runningBalance.toDouble();
                          final isPurchase = item.type == 'purchase';

                          return Card(
                            child: ListTile(
                              title: Text(
                                isPurchase
                                    ? context.l10n.purchaseType
                                    : context.l10n.paymentType,
                              ),
                              subtitle: Text(
                                AppFormatters.date(
                                  context,
                                  DateTime.parse(item.date),
                                ),
                              ),

                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,

                                children: [
                                  Text(
                                    '${isPurchase ? '+' : '-'}'
                                    '${AppFormatters.currency(context, item.amount.toDouble(), context.read<ShopProvider>().currency)}',
                                    style: TextStyle(
                                      color: isPurchase
                                          ? Colors.red
                                          : Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  Text(
                                    '${context.l10n.runningBalance}: '
                                    '${AppFormatters.currency(context, runningBalance, context.read<ShopProvider>().currency)}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: runningBalance > 0
                                          ? Colors.red
                                          : Colors.green,
                                    ),
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
      ),
    );
  }
}
