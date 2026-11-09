import 'package:flutter/material.dart';

import '../services/inactive_product_service.dart';

class InactiveProductsScreen extends StatefulWidget {
  const InactiveProductsScreen({super.key});

  @override
  State<InactiveProductsScreen> createState() => _InactiveProductsScreenState();
}

class _InactiveProductsScreenState extends State<InactiveProductsScreen> {
  final InactiveProductService _service = InactiveProductService();

  List<dynamic> products = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();

    loadProducts();
  }

  Future<void> loadProducts() async {
    try {
      final data = await _service.getInactiveProducts();

      if (!mounted) return;

      setState(() {
        products = data;
        errorMessage = null;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        errorMessage = 'Failed to load inactive products';
        isLoading = false;
      });
    }
  }

  Future<void> showRestoreConfirmation(Map<String, dynamic> product) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Restore Product'),
          content: Text('Are you sure you want to restore ${product['name']}?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Restore'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await restoreProduct(product);
    }
  }

  Future<void> restoreProduct(Map<String, dynamic> product) async {
    try {
      await _service.restoreProduct(product['id']);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${product['name']} restored successfully')),
      );

      await loadProducts();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to restore product')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (errorMessage != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Inactive Products')),
        body: Center(child: Text(errorMessage!)),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Inactive Products')),
      body: RefreshIndicator(
        onRefresh: loadProducts,
        child: products.isEmpty
            ? ListView(
                children: const [
                  SizedBox(height: 150),
                  Center(child: Text('No inactive products')),
                ],
              )
            : ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];

                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text(
                          product['name'].toString().isNotEmpty
                              ? product['name'].toString()[0].toUpperCase()
                              : '?',
                        ),
                      ),
                      title: Text(product['name'].toString()),
                      subtitle: Text(product['category_name'].toString()),
                      trailing: IconButton(
                        icon: const Icon(Icons.restore, color: Colors.green),
                        onPressed: () {
                          showRestoreConfirmation(product);
                        },
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
