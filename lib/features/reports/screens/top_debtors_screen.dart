import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../services/reports_service.dart';

class TopDebtorsScreen extends StatefulWidget {
  const TopDebtorsScreen({super.key});

  @override
  State<TopDebtorsScreen> createState() => _TopDebtorsScreenState();
}

class _TopDebtorsScreenState extends State<TopDebtorsScreen> {
  final currencyFormatter = NumberFormat('#,##0.00');
  List<dynamic> debtors = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      setState(() {
        isLoading = true;
      });

      final data = await ReportsService().getTopDebtors();

      if (!mounted) return;

      setState(() {
        debtors = data;
        isLoading = false;
      });
    } catch (e) {
      debugPrint(e.toString());

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load top debtors')),
      );

      setState(() {
        isLoading = false;
      });
    }
  }

  Color getRankColor(int index) {
    if (index == 0) {
      return Colors.amber;
    }

    if (index == 1) {
      return Colors.grey;
    }

    if (index == 2) {
      return Colors.orange;
    }

    return Colors.blue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Top Debtors')),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : debtors.isEmpty
          ? const Center(child: Text('No debtors found'))
          : RefreshIndicator(
              onRefresh: loadData,

              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 20),
                itemCount: debtors.length,

                itemBuilder: (context, index) {
                  final debtor = debtors[index];

                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: getRankColor(index),

                        child: Text(
                          '${index + 1}',

                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      title: Text(
                        debtor['name']?.toString() ?? 'Unknown Customer',
                      ),

                      trailing: Text(
                        'YER ${currencyFormatter.format(double.tryParse(debtor['balance'].toString()) ?? 0)}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
