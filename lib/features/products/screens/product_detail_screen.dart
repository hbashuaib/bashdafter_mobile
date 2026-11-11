import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/storage/token_storage.dart';
import '../../auth/models/user_profile.dart';
import '../services/product_service.dart';

import 'edit_product_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final NumberFormat currencyFormatter = NumberFormat('#,##0.00');
  final ProductService _productService = ProductService();

  UserProfile? currentUser;

  @override
  void initState() {
    super.initState();
    loadCurrentUser();
  }

  Future<void> loadCurrentUser() async {
    final profile = await TokenStorage.getProfile();

    if (!mounted) return;

    setState(() {
      currentUser = profile;
    });
  }

  Future<void> deactivateProduct() async {
    final confirmed = await showDialog<bool>(
      context: context,

      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Deactivate Product'),

          content: Text(
            'Are you sure you want to deactivate ${widget.product['name']}?',
          ),

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

              child: const Text('Deactivate'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    try {
      await _productService.deleteProduct(widget.product['id']);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product deactivated successfully')),
      );

      Navigator.pop(context, true);
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to deactivate product')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product['name']?.toString() ?? ''),

        actions: [
          if (currentUser != null &&
              (currentUser!.isOwner || currentUser!.isAdmin))
            IconButton(
              icon: const Icon(Icons.delete_outline),

              onPressed: deactivateProduct,
            ),
        ],
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      floatingActionButton: currentUser != null && !currentUser!.isCashier
          ? FloatingActionButton(
              child: const Icon(Icons.edit),

              onPressed: () async {
                final result = await Navigator.push(
                  context,

                  MaterialPageRoute(
                    builder: (_) => EditProductScreen(product: widget.product),
                  ),
                );

                if (result == true && context.mounted) {
                  Navigator.pop(context, true);
                }
              },
            )
          : null,

      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),

        children: [
          Card(
            child: ListTile(
              title: const Text('Category'),
              subtitle: Text(widget.product['category_name'] ?? ''),
            ),
          ),

          Card(
            child: ListTile(
              title: const Text('Unit'),
              subtitle: Text(widget.product['unit_name'] ?? ''),
            ),
          ),

          Card(
            child: ListTile(
              title: const Text('Barcode'),
              subtitle: Text(
                (widget.product['barcode'] ?? '').toString().trim().isEmpty
                    ? '-'
                    : widget.product['barcode'].toString(),
              ),
            ),
          ),

          Card(
            child: ListTile(
              title: const Text('Description'),
              subtitle: Text(
                (widget.product['description'] ?? '').toString().trim().isEmpty
                    ? 'No description'
                    : widget.product['description'],
              ),
            ),
          ),

          Card(
            child: ListTile(
              title: const Text('Cost Price'),
              subtitle: Text(
                'YER ${currencyFormatter.format(double.tryParse(widget.product['cost_price'].toString()) ?? 0)}',
              ),
            ),
          ),

          Card(
            child: ListTile(
              title: const Text('Selling Price'),
              subtitle: Text(
                'YER ${currencyFormatter.format(double.tryParse(widget.product['selling_price'].toString()) ?? 0)}',
              ),
            ),
          ),

          Card(
            child: ListTile(
              title: const Text('Current Stock'),
              subtitle: Text(
                (double.tryParse(widget.product['current_stock'].toString()) ??
                        0)
                    .toStringAsFixed(0),
              ),
            ),
          ),

          Card(
            child: ListTile(
              title: const Text('Total Sold'),
              subtitle: Text(
                (double.tryParse(widget.product['total_sold'].toString()) ?? 0)
                    .toStringAsFixed(0),
              ),
            ),
          ),

          Card(
            child: ListTile(
              title: const Text('Stock Adjustments'),
              subtitle: Text(
                (double.tryParse(
                          widget.product['total_adjustments'].toString(),
                        ) ??
                        0)
                    .toStringAsFixed(0),
              ),
            ),
          ),

          if ((double.tryParse(widget.product['current_stock'].toString()) ??
                  0) <=
              (double.tryParse(widget.product['minimum_stock'].toString()) ??
                  0))
            Card(
              color: Colors.red.shade50,

              child: const ListTile(
                leading: Icon(Icons.warning, color: Colors.red),

                title: Text(
                  'LOW STOCK',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                subtitle: Text('Current stock is below minimum stock level'),
              ),
            ),

          Card(
            child: ListTile(
              title: const Text('Minimum Stock'),
              subtitle: Text(
                (double.tryParse(widget.product['minimum_stock'].toString()) ??
                        0)
                    .toStringAsFixed(0),
              ),
            ),
          ),

          Card(
            child: ListTile(
              title: const Text('Has Expiry'),
              subtitle: Text(widget.product['has_expiry'] ? 'Yes' : 'No'),
            ),
          ),
          if (widget.product['has_expiry'] == true)
            Card(
              child: ListTile(
                title: const Text('Expiry Date'),

                subtitle: Text(
                  widget.product['expiry_date']?.toString() ?? '-',
                ),
              ),
            ),
          if (widget.product['has_expiry'] == true &&
              widget.product['expiry_date'] != null)
            Builder(
              builder: (_) {
                final expiryDate = DateTime.parse(
                  widget.product['expiry_date'],
                );

                final remaining = expiryDate.difference(DateTime.now()).inDays;

                Color cardColor;
                Color textColor;
                String status;

                if (remaining < 0) {
                  cardColor = Colors.red.shade50;
                  textColor = Colors.red.shade900;
                  status = 'EXPIRED';
                } else if (remaining <= 30) {
                  cardColor = Colors.orange.shade50;
                  textColor = Colors.orange.shade900;
                  status = 'Expires in $remaining days';
                } else {
                  cardColor = Colors.green.shade50;
                  textColor = Colors.green.shade900;
                  status = '$remaining days remaining';
                }

                return Card(
                  color: cardColor,

                  child: ListTile(
                    leading: Icon(Icons.calendar_month, color: textColor),

                    title: Text(
                      status,
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              },
            ),

          Card(
            child: ListTile(
              title: const Text('Status'),
              subtitle: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),

                decoration: BoxDecoration(
                  color: widget.product['is_active']
                      ? Colors.green.shade100
                      : Colors.red.shade100,

                  borderRadius: BorderRadius.circular(12),
                ),

                child: Text(
                  widget.product['is_active'] ? 'Active' : 'Inactive',

                  style: TextStyle(
                    color: widget.product['is_active']
                        ? Colors.green
                        : Colors.red,

                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
