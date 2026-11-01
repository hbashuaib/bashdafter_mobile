import 'package:flutter/material.dart';

import '../services/reports_service.dart';

class TopDebtorsScreen extends StatefulWidget {
  const TopDebtorsScreen({super.key});

  @override
  State<TopDebtorsScreen> createState() => _TopDebtorsScreenState();
}

class _TopDebtorsScreenState extends State<TopDebtorsScreen> {
  List<dynamic> debtors = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final data = await ReportsService().getTopDebtors();

    setState(() {
      debtors = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Top Debtors')),

      body: debtors.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: debtors.length,

              itemBuilder: (context, index) {
                final debtor = debtors[index];

                return Card(
                  child: ListTile(
                    leading: CircleAvatar(child: Text('${index + 1}')),

                    title: Text(debtor['name']),

                    trailing: Text(debtor['balance'].toString()),
                  ),
                );
              },
            ),
    );
  }
}
