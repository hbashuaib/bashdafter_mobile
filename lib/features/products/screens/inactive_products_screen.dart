import 'package:flutter/material.dart';

import '../services/inactive_product_service.dart';
import '../../../core/localization/localization_extension.dart';

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
        errorMessage = context.l10n.failedToLoadInactiveProducts;
        isLoading = false;
      });
    }
  }

  Future<void> showRestoreConfirmation(Map<String, dynamic> product) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(context.l10n.restoreProduct),
          content: Text(
            '${context.l10n.restoreProductQuestion}\n\n'
            '${product['name']}',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: Text(context.l10n.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: Text(context.l10n.restore),
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
        SnackBar(content: Text(context.l10n.productRestoredSuccessfully)),
      );

      await loadProducts();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.failedToRestoreProduct)),
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
        appBar: AppBar(title: Text(context.l10n.inactiveProducts)),
        body: Center(child: Text(errorMessage!)),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.inactiveProducts)),
      body: RefreshIndicator(
        onRefresh: loadProducts,
        child: products.isEmpty
            ? ListView(
                children: [
                  const SizedBox(height: 150),
                  Center(child: Text(context.l10n.noInactiveProducts)),
                ],
              )
            : ListView.builder(
                padding: const EdgeInsets.only(bottom: 100),
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
                      subtitle: Text(
                        (product['category_name'] ?? context.l10n.noCategory)
                            .toString(),
                      ),
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
