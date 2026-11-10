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
  List<dynamic> filteredTransactions = [];
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
        filteredTransactions = List<dynamic>.from(data['transactions']);
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

  void searchTransactions(String value) {
    final query = value.toLowerCase();

    setState(() {
      filteredTransactions = (statement!['transactions'] as List<dynamic>)
          .where((item) {
            final type = item['type'].toString().toLowerCase();
            final date = item['date'].toString().toLowerCase();
            final amount = item['amount'].toString().toLowerCase();

            return type.contains(query) ||
                date.contains(query) ||
                amount.contains(query);
          })
          .toList();
    });
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

              child: Padding(
                padding: const EdgeInsets.all(16),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,

                  children: [
                    Column(
                      children: [
                        const Text('Transactions'),

                        Text(
                          transactions.length.toString(),

                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),

                    Column(
                      children: [
                        const Text('Balance'),

                        Text(
                          'YER ${currencyFormatter.format(double.tryParse(statement!['balance'].toString()) ?? 0)}',

                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              onChanged: searchTransactions,

              decoration: const InputDecoration(
                hintText: 'Search transactions',

                prefixIcon: Icon(Icons.search),
              ),
            ),

            const SizedBox(height: 12),

            Center(
              child: Text(
                'Showing ${filteredTransactions.length} of ${transactions.length} transactions',

                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 12),

            Expanded(
              child: RefreshIndicator(
                onRefresh: loadStatement,

                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 20),
                  itemCount: filteredTransactions.length,

                  itemBuilder: (context, index) {
                    final item = filteredTransactions[index];
                    final isPurchase = item['type'] == 'purchase';

                    return Card(
                      child: ListTile(
                        title: Text(item['type'].toString().toUpperCase()),
                        subtitle: Text(item['date']),

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
