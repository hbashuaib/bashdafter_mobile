import 'package:flutter/material.dart';

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
  Map<String, dynamic>? statement;

  @override
  void initState() {
    super.initState();
    loadStatement();
  }

  Future<void> loadStatement() async {
    final data = await CustomerStatementService().getStatement(
      widget.customerId,
    );

    setState(() {
      statement = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (statement == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final transactions = statement!['transactions'] as List<dynamic>;

    return Scaffold(
      appBar: AppBar(
        title: Text(statement!['customer']),

        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),

            onPressed: () async {
              await CustomerStatementPdfService().generatePdf(
                customer: statement!['customer'],
                balance: statement!['balance'],
                transactions: transactions,
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
              child: ListTile(
                title: const Text('Current Balance'),
                trailing: Text(statement!['balance'].toString()),
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                itemCount: transactions.length,

                itemBuilder: (context, index) {
                  final item = transactions[index];
                  final isPurchase = item['type'] == 'purchase';

                  return Card(
                    child: ListTile(
                      title: Text(item['date']),
                      subtitle: Text(item['type']),

                      trailing: Text(
                        '${isPurchase ? '+' : '-'}${item['amount']}',
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
          ],
        ),
      ),
    );
  }
}
