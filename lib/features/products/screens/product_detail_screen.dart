import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/storage/token_storage.dart';
import '../../auth/models/user_profile.dart';
import '../services/product_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/localization/localization_extension.dart';
import '../../../core/localization/app_formatters.dart';
import '../../../core/providers/shop_provider.dart';

import 'edit_product_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
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
          title: Text(context.l10n.deactivateProduct),

          content: Text(
            '${context.l10n.deactivateProductQuestion}\n\n'
            '${widget.product['name']}',
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

              child: Text(context.l10n.deactivate),
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
        SnackBar(content: Text(context.l10n.productDeactivatedSuccessfully)),
      );

      Navigator.pop(context, true);
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.failedToDeactivateProduct)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentStock =
        double.tryParse(widget.product['current_stock'].toString()) ?? 0;

    final minimumStock =
        double.tryParse(widget.product['minimum_stock'].toString()) ?? 0;

    final isLowStock = currentStock <= minimumStock;

    final costPrice =
        double.tryParse(widget.product['cost_price'].toString()) ?? 0;

    final sellingPrice =
        double.tryParse(widget.product['selling_price'].toString()) ?? 0;

    final totalSold =
        double.tryParse(widget.product['total_sold'].toString()) ?? 0;

    final totalAdjustments =
        double.tryParse(widget.product['total_adjustments'].toString()) ?? 0;

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
              title: Text(context.l10n.category),
              subtitle: Text(widget.product['category_name'] ?? ''),
            ),
          ),

          Card(
            child: ListTile(
              title: Text(context.l10n.unit),
              subtitle: Text(widget.product['unit_name'] ?? ''),
            ),
          ),

          Card(
            child: ListTile(
              title: Text(context.l10n.barcodeLabel),
              subtitle: Text(
                (widget.product['barcode'] ?? '').toString().trim().isEmpty
                    ? '-'
                    : widget.product['barcode'].toString(),
              ),
            ),
          ),

          Card(
            child: ListTile(
              title: Text(context.l10n.description),
              subtitle: Text(
                (widget.product['description'] ?? '').toString().trim().isEmpty
                    ? context.l10n.noDescription
                    : widget.product['description'],
              ),
            ),
          ),

          Card(
            child: ListTile(
              title: Text(context.l10n.costPrice),
              subtitle: Text(
                // 'YER ${currencyFormatter.format(costPrice)}'
                AppFormatters.currency(
                  context,
                  costPrice,
                  context.read<ShopProvider>().currency,
                ),
              ),
            ),
          ),

          Card(
            child: ListTile(
              title: Text(context.l10n.sellingPrice),
              subtitle: Text(
                // 'YER ${currencyFormatter.format(sellingPrice)}'
                AppFormatters.currency(
                  context,
                  sellingPrice,
                  context.read<ShopProvider>().currency,
                ),
              ),
            ),
          ),

          Card(
            child: ListTile(
              title: Text(context.l10n.currentStock),
              subtitle: Text(
                // currentStock.toStringAsFixed(0)
                AppFormatters.number(context, currentStock),
              ),
            ),
          ),

          Card(
            child: ListTile(
              title: Text(context.l10n.totalSold),
              subtitle: Text(
                // totalSold.toStringAsFixed(0)
                AppFormatters.number(context, totalSold),
              ),
            ),
          ),

          Card(
            child: ListTile(
              title: Text(context.l10n.stockAdjustments),
              subtitle: Text(
                // totalAdjustments.toStringAsFixed(0)
                AppFormatters.number(context, totalAdjustments),
              ),
            ),
          ),

          if (isLowStock)
            Card(
              color: AppColors.cardTint(context, Colors.red.shade50),

              child: ListTile(
                leading: Icon(Icons.warning, color: Colors.red),

                title: Text(
                  context.l10n.lowStockStatus,
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                subtitle: Text(context.l10n.currentStockBelowMinimum),
              ),
            ),

          Card(
            child: ListTile(
              title: Text(context.l10n.minimumStock),
              subtitle: Text(
                // minimumStock.toStringAsFixed(0)
                AppFormatters.number(context, minimumStock),
              ),
            ),
          ),

          Card(
            child: ListTile(
              title: Text(context.l10n.hasExpiry),
              subtitle: Text(
                widget.product['has_expiry']
                    ? context.l10n.yes
                    : context.l10n.no,
              ),
            ),
          ),
          if (widget.product['has_expiry'] == true)
            Card(
              child: ListTile(
                title: Text(context.l10n.expiryDate),

                subtitle: Text(
                  widget.product['expiry_date'] == null
                      ? '-'
                      : AppFormatters.date(
                          context,
                          DateTime.parse(widget.product['expiry_date']),
                        ),
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
                  status = context.l10n.expired;
                } else if (remaining <= 30) {
                  cardColor = Colors.orange.shade50;
                  textColor = Colors.orange.shade900;
                  status =
                      '${context.l10n.expiresIn} '
                      '${AppFormatters.number(context, remaining)} '
                      '${context.l10n.daysRemaining}';
                } else {
                  cardColor = Colors.green.shade50;
                  textColor = Colors.green.shade900;
                  status =
                      '${AppFormatters.number(context, remaining)} '
                      '${context.l10n.daysRemaining}';
                }

                return Card(
                  color: AppColors.cardTint(context, cardColor),

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
              title: Text(context.l10n.status),
              subtitle: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),

                decoration: BoxDecoration(
                  color: AppColors.cardTint(
                    context,
                    widget.product['is_active']
                        ? Colors.green.shade100
                        : Colors.red.shade100,
                  ),

                  borderRadius: BorderRadius.circular(12),
                ),

                child: Text(
                  widget.product['is_active']
                      ? context.l10n.active
                      : context.l10n.inactive,

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
