import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../services/product_service.dart';
import '../../../core/storage/token_storage.dart';
import '../../auth/models/user_profile.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_loading_scaffold.dart';
import '../../../core/widgets/app_refreshable_empty_state.dart';

import 'product_detail_screen.dart';
import 'add_product_screen.dart';
import 'inactive_products_screen.dart';
import 'barcode_scanner_screen.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final currencyFormatter = NumberFormat('#,##0.00');
  final searchController = TextEditingController();
  List<dynamic> products = [];
  List<dynamic> filteredProducts = [];
  bool isLoading = true;
  String activeFilter = 'All';
  String searchQuery = '';
  UserProfile? currentUser;

  int get totalProducts => products.length;
  int get activeProducts =>
      products.where((p) => p['is_active'] == true).length;
  int get inactiveProducts =>
      products.where((p) => p['is_active'] == false).length;

  @override
  void initState() {
    super.initState();
    loadProducts();
    loadCurrentUser();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> loadProducts() async {
    try {
      final data = await ProductService().getProducts();

      if (!mounted) return;

      setState(() {
        products = data;
        isLoading = false;
      });

      applyFilters();
    } catch (e) {
      debugPrint(e.toString());

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to load products')));

      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> loadCurrentUser() async {
    final profile = await TokenStorage.getProfile();

    if (!mounted) return;

    setState(() {
      currentUser = profile;
    });
  }

  void applyFilters() {
    final query = searchQuery.toLowerCase().trim();

    setState(() {
      filteredProducts = products.where((product) {
        final name = product['name'].toString().toLowerCase();

        final category = product['category_name'].toString().toLowerCase();

        final barcode = (product['barcode'] ?? '').toString().toLowerCase();

        final matchesSearch =
            name.contains(query) ||
            category.contains(query) ||
            barcode.contains(query);

        final matchesFilter = activeFilter == 'All'
            ? true
            : activeFilter == 'Active'
            ? product['is_active'] == true
            : product['is_active'] == false;

        return matchesSearch && matchesFilter;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const AppLoadingScaffold(message: 'Loading products...');
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),

        actions: [
          if (currentUser != null &&
              (currentUser!.isOwner || currentUser!.isAdmin))
            IconButton(
              icon: const Icon(Icons.restore_from_trash),

              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const InactiveProductsScreen(),
                  ),
                );

                loadProducts();
              },
            ),
        ],
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      floatingActionButton: currentUser != null && !currentUser!.isCashier
          ? FloatingActionButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddProductScreen()),
                );

                if (result == true) {
                  await loadProducts();
                }
              },

              child: const Icon(Icons.add),
            )
          : null,

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),

            child: Card(
              color: AppColors.cardTint(context, Colors.blue.shade50),

              child: Padding(
                padding: const EdgeInsets.all(12),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,

                  children: [
                    Column(
                      children: [
                        const Text('Total'),
                        Text(
                          totalProducts.toString(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),

                    Column(
                      children: [
                        const Text('Active'),
                        Text(
                          activeProducts.toString(),
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    Column(
                      children: [
                        const Text('Inactive'),
                        Text(
                          inactiveProducts.toString(),
                          style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(12),

            child: TextField(
              controller: searchController,
              onChanged: (value) {
                searchQuery = value;
                applyFilters();
              },

              decoration: InputDecoration(
                hintText: 'Search by name, category, or barcode',
                prefixIcon: const Icon(Icons.search),

                suffixIcon: IconButton(
                  icon: const Icon(Icons.qr_code_scanner),

                  onPressed: () async {
                    final messenger = ScaffoldMessenger.of(context);

                    final barcode = await Navigator.push(
                      context,

                      MaterialPageRoute(
                        builder: (_) => const BarcodeScannerScreen(),
                      ),
                    );

                    if (!mounted || barcode == null) {
                      return;
                    }

                    searchController.text = barcode.toString();
                    searchQuery = barcode.toString();
                    applyFilters();

                    if (filteredProducts.isEmpty) {
                      messenger.showSnackBar(
                        const SnackBar(content: Text('Product not found')),
                      );
                    }
                  },
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,

              children: [
                FilterChip(
                  label: const Text('All'),
                  selected: activeFilter == 'All',

                  onSelected: (_) {
                    activeFilter = 'All';
                    applyFilters();
                  },
                ),

                FilterChip(
                  label: const Text('Active'),
                  selected: activeFilter == 'Active',

                  onSelected: (_) {
                    activeFilter = 'Active';
                    applyFilters();
                  },
                ),

                FilterChip(
                  label: const Text('Inactive'),
                  selected: activeFilter == 'Inactive',

                  onSelected: (_) {
                    activeFilter = 'Inactive';
                    applyFilters();
                  },
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(12),

            child: Center(
              child: Text(
                'Showing ${filteredProducts.length} of ${products.length} products',

                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),

          Expanded(
            child: RefreshIndicator(
              onRefresh: loadProducts,

              child: filteredProducts.isEmpty
                  ? AppRefreshableEmptyState(
                      message: 'No products found',
                      icon: Icons.inventory_2_outlined,
                      onRefresh: loadProducts,
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 90),
                      itemCount: filteredProducts.length,
                      itemBuilder: (context, index) {
                        final product = filteredProducts[index];

                        return Card(
                          child: ListTile(
                            onTap: () async {
                              final result = await Navigator.push(
                                context,

                                MaterialPageRoute(
                                  builder: (_) =>
                                      ProductDetailScreen(product: product),
                                ),
                              );

                              if (result == true) {
                                activeFilter = 'All';
                                await loadProducts();
                              }
                            },

                            title: Text(product['name']),

                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [
                                Text(
                                  '${product['category_name']} • ${product['unit_name']}',
                                ),

                                if ((product['barcode'] ?? '')
                                    .toString()
                                    .trim()
                                    .isNotEmpty)
                                  Text(
                                    'Barcode: ${product['barcode']}',
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                      fontSize: 12,
                                    ),
                                  ),
                              ],
                            ),

                            trailing: Text(
                              'YER ${currencyFormatter.format(double.tryParse(product['selling_price'].toString()) ?? 0)}',

                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
