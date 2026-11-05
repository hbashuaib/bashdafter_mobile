import 'package:flutter/material.dart';

import '../services/inventory_transaction_service.dart';

class InventoryHistoryScreen extends StatefulWidget {
  const InventoryHistoryScreen({super.key});

  @override
  State<InventoryHistoryScreen> createState() => _InventoryHistoryScreenState();
}

class _InventoryHistoryScreenState extends State<InventoryHistoryScreen> {
  List<dynamic> transactions = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadTransactions();
  }

  Future<void> loadTransactions() async {
    try {
      final data = await InventoryTransactionService().getTransactions();

      if (!mounted) return;

      setState(() {
        transactions = data;
        isLoading = false;
      });
    } catch (e) {
      debugPrint(e.toString());

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load inventory history')),
      );

      setState(() {
        isLoading = false;
      });
    }
  }

  Color getTransactionColor(String transactionType) {
    switch (transactionType) {
      case 'OPENING':
        return Colors.blue;

      case 'IN':
        return Colors.green;

      case 'SALE':
      case 'OUT':
        return Colors.orange;

      case 'DAMAGE':
        return Colors.red;

      case 'CORRECTION':
        return Colors.purple;

      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inventory History')),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : transactions.isEmpty
          ? const Center(child: Text('No inventory transactions found'))
          : RefreshIndicator(
              onRefresh: loadTransactions,

              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 30),
                itemCount: transactions.length,

                itemBuilder: (context, index) {
                  final transaction = transactions[index];

                  final color = getTransactionColor(
                    transaction['transaction_type'],
                  );

                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),

                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: color,

                        child: Text(
                          transaction['transaction_type']
                                      ?.toString()
                                      .isNotEmpty ==
                                  true
                              ? transaction['transaction_type']
                                    .toString()
                                    .substring(0, 1)
                              : '?',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),

                      title: Text(
                        transaction['product_name']?.toString() ??
                            'Unknown Product',
                      ),
                      subtitle: Text(
                        (transaction['reference'] ?? '')
                                .toString()
                                .trim()
                                .isEmpty
                            ? '-'
                            : transaction['reference'].toString(),
                      ),

                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,

                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),

                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.15),

                              borderRadius: BorderRadius.circular(10),
                            ),

                            child: Text(
                              transaction['transaction_type'].toString(),

                              style: TextStyle(
                                color: color,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          Text(
                            (double.tryParse(
                                      transaction['quantity'].toString(),
                                    ) ??
                                    0)
                                .toStringAsFixed(0),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
