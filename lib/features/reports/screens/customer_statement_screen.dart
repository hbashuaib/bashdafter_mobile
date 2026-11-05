import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../services/customer_statement_service.dart';
import '../services/customer_statement_pdf_service.dart';

class CustomerStatementScreen extends StatefulWidget {
  final int customerId;

  const CustomerStatementScreen({super.key, required this.customerId});

  @override
  State<CustomerStatementScreen> createState() =>
      _CustomerStatementScreenState();
}

class _CustomerStatementScreenState extends State<CustomerStatementScreen> {
  final currencyFormatter = NumberFormat('#,##0.00');
  Map<String, dynamic>? statement;
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
        isLoading = false;
      });
    } catch (e) {
      debugPrint(e.toString());

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to load statement')));

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (statement == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Customer Statement')),

        body: const Center(child: Text('No statement available')),
      );
    }

    final transactions = statement!['transactions'] as List<dynamic>;

    return Scaffold(
      appBar: AppBar(
        title: Text(statement!['customer']?.toString() ?? 'Customer Statement'),

        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),

            onPressed: () async {
              if (!mounted) return;

              final messenger = ScaffoldMessenger.of(context);

              try {
                await CustomerStatementPdfService().generatePdf(
                  customer: statement!['customer'],
                  balance: statement!['balance'],
                  transactions: transactions,
                );

                if (!mounted) return;

                messenger.showSnackBar(
                  const SnackBar(content: Text('PDF generated successfully')),
                );
              } catch (e) {
                if (!mounted) return;

                messenger.showSnackBar(
                  const SnackBar(content: Text('Failed to generate PDF')),
                );
              }
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
              color: Colors.blue.shade50,
              child: ListTile(
                title: const Text('Current Balance'),
                trailing: Text(
                  'YER ${currencyFormatter.format(double.tryParse(statement!['balance'].toString()) ?? 0)}',

                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: RefreshIndicator(
                onRefresh: loadStatement,

                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 20),
                  itemCount: transactions.length,

                  itemBuilder: (context, index) {
                    final item = transactions[index];
                    final isPurchase = item['type'] == 'purchase';

                    return Card(
                      child: ListTile(
                        title: Text(item['date']),
                        subtitle: Text(item['type'].toString().toUpperCase()),

                        trailing: Text(
                          '${isPurchase ? '+' : '-'}YER ${currencyFormatter.format(double.tryParse(item['amount'].toString()) ?? 0)}',
                          style: TextStyle(
                            color: isPurchase ? Colors.red : Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
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
