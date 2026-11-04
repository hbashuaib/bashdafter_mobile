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

      setState(() {
        transactions = data;
        isLoading = false;
      });
    } catch (e) {
      debugPrint(e.toString());

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
          : ListView.builder(
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
                        transaction['transaction_type'].substring(0, 1),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),

                    title: Text(transaction['product_name']),
                    subtitle: Text(transaction['reference']),

                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [
                        Text(
                          transaction['transaction_type'],

                          style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        Text(transaction['quantity'].toString()),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
