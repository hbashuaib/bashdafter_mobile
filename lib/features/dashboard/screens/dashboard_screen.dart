import 'package:flutter/material.dart';

import '../../../core/storage/token_storage.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() =>
      _DashboardScreenState();
}

class _DashboardScreenState
    extends State<DashboardScreen> {

  String token = '';

  @override
  void initState() {
    super.initState();
    loadToken();
  }

  Future<void> loadToken() async {

    final access =
        await TokenStorage.getAccessToken();

    setState(() {
      token = access ?? 'No Token';
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dashboard',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          token,
        ),
      ),
    );
  }
}