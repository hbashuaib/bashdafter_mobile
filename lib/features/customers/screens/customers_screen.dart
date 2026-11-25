import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/customer_service.dart';
import '../models/customer_model.dart';
import '../../../core/storage/token_storage.dart';
import '../../auth/models/user_profile.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_loading_scaffold.dart';
import '../../../core/widgets/app_refreshable_empty_state.dart';
import '../../../core/localization/localization_extension.dart';
import '../../../core/localization/app_formatters.dart';
import '../../../core/providers/shop_provider.dart';
import '../../../core/widgets/app_search_field.dart';

import 'customer_detail_screen.dart';
import 'add_customer_screen.dart';
import 'inactive_customers_screen.dart';

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({super.key});

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  final searchController = TextEditingController();
  List<CustomerModel> customers = [];
  List<CustomerModel> filteredCustomers = [];
  bool isLoading = true;
  String currentFilter = 'active';
  String searchQuery = '';
  UserProfile? currentUser;

  @override
  void initState() {
    super.initState();
    loadCustomers();
    loadCurrentUser();
  }

  void applyFilters() {
    final query = searchQuery.toLowerCase().trim();

    setState(() {
      filteredCustomers = customers.where((customer) {
        final name = customer.name.toLowerCase();
        final phone = customer.phone.toLowerCase();
        final matchesSearch = name.contains(query) || phone.contains(query);

        final matchesFilter = currentFilter == 'all'
            ? true
            : currentFilter == 'active'
            ? customer.isActive
            : !customer.isActive;

        return matchesSearch && matchesFilter;
      }).toList();
    });
  }

  Future<void> loadCustomers() async {
    try {
      final data = await CustomerService().getCustomers();

      if (!mounted) return;

      setState(() {
        customers = data;
        isLoading = false;
      });

      applyFilters();
    } catch (e) {
      debugPrint(e.toString());

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.failedToLoadCustomers)),
      );

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

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return AppLoadingScaffold(message: context.l10n.loadingCustomers);
    }

    return Scaffold(
      floatingActionButton: currentUser != null && !currentUser!.isCashier
          ? FloatingActionButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddCustomerScreen()),
                );

                if (result == true) {
                  loadCustomers();
                }
              },
              child: const Icon(Icons.add),
            )
          : null,

      appBar: AppBar(
        title: Text(context.l10n.customers),

        actions: [
          if (currentUser != null &&
              (currentUser!.isOwner || currentUser!.isAdmin))
            IconButton(
              icon: const Icon(Icons.restore_from_trash),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const InactiveCustomersScreen(),
                  ),
                );

                loadCustomers();
              },
            ),
        ],
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),

            child: Center(
              child: Text(
                '${context.l10n.showing} '
                '${AppFormatters.number(context, filteredCustomers.length)} '
                '${context.l10n.outOf} '
                '${AppFormatters.number(context, customers.length)} '
                '${context.l10n.showingCustomers}',

                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(12),

            child: AppSearchField(
              controller: searchController,
              hintText: context.l10n.searchCustomers,

              onChanged: (value) {
                searchQuery = value;
                applyFilters();
              },

              onClear: () {
                searchController.clear();
                searchQuery = '';
                applyFilters();
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),

            child: Wrap(
              spacing: 8,

              children: [
                ChoiceChip(
                  label: Text(context.l10n.all),
                  selected: currentFilter == 'all',

                  onSelected: (_) {
                    currentFilter = 'all';
                    applyFilters();
                  },
                ),

                ChoiceChip(
                  label: Text(context.l10n.active),
                  selected: currentFilter == 'active',

                  onSelected: (_) {
                    currentFilter = 'active';
                    applyFilters();
                  },
                ),

                ChoiceChip(
                  label: Text(context.l10n.inactive),
                  selected: currentFilter == 'inactive',

                  onSelected: (_) {
                    currentFilter = 'inactive';
                    applyFilters();
                  },
                ),
              ],
            ),
          ),

          Expanded(
            child: RefreshIndicator(
              onRefresh: loadCustomers,

              child: filteredCustomers.isEmpty
                  ? AppRefreshableEmptyState(
                      message: context.l10n.noCustomersFound,
                      icon: Icons.people_outline,
                      onRefresh: loadCustomers,
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.only(bottom: 100),

                      itemCount: filteredCustomers.length,

                      itemBuilder: (context, index) {
                        final customer = filteredCustomers[index];

                        return Card(
                          child: ListTile(
                            onTap: () async {
                              await Navigator.push(
                                context,

                                MaterialPageRoute(
                                  builder: (_) => CustomerDetailScreen(
                                    customerId: customer.id,
                                  ),
                                ),
                              );

                              loadCustomers();
                            },

                            title: Text(customer.name),
                            subtitle: Text(customer.phone),

                            trailing: Chip(
                              backgroundColor: AppColors.cardTint(
                                context,
                                customer.balance > 0
                                    ? Colors.orange.shade100
                                    : Colors.green.shade100,
                              ),

                              label: Text(
                                AppFormatters.currency(
                                  context,
                                  customer.balance.toDouble(),
                                  context.read<ShopProvider>().currency,
                                ),
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
