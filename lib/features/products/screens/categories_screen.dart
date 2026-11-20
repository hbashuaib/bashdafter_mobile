import 'package:flutter/material.dart';

import '../services/category_service.dart';
import '../../../core/localization/localization_extension.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  List<dynamic> categories = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    loadCategories();
  }

  Future<void> loadCategories() async {
    try {
      final data = await CategoryService().getCategories();

      if (!mounted) return;

      setState(() {
        categories = data;
        isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> showAddCategoryDialog() async {
    nameController.clear();
    descriptionController.clear();

    final result = await showDialog<bool>(
      context: context,

      builder: (_) {
        return AlertDialog(
          title: Text(context.l10n.addCategory),

          content: Column(
            mainAxisSize: MainAxisSize.min,

            children: [
              TextField(
                controller: nameController,
                textDirection: Directionality.of(context),
                decoration: InputDecoration(
                  labelText: context.l10n.categoryName,
                ),
              ),

              const SizedBox(height: 12),

              TextField(
                controller: descriptionController,
                textDirection: Directionality.of(context),
                decoration: InputDecoration(
                  labelText: context.l10n.description,
                ),
              ),
            ],
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },

              child: Text(context.l10n.cancel),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },

              child: Text(context.l10n.save),
            ),
          ],
        );
      },
    );

    if (result == true) {
      await createCategory();
    }
  }

  Future<void> createCategory() async {
    if (nameController.text.trim().isEmpty) {
      return;
    }

    try {
      await CategoryService().createCategory(
        name: nameController.text,
        description: descriptionController.text,
      );

      await loadCategories();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.categoryAddedSuccessfully)),
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> showEditCategoryDialog(dynamic category) async {
    nameController.text = category['name'] ?? '';

    descriptionController.text = category['description'] ?? '';

    final result = await showDialog<bool>(
      context: context,

      builder: (_) {
        return AlertDialog(
          title: Text(context.l10n.editCategory),

          content: Column(
            mainAxisSize: MainAxisSize.min,

            children: [
              TextField(
                controller: nameController,

                decoration: InputDecoration(labelText: context.l10n.categoryName),
              ),

              const SizedBox(height: 12),

              TextField(
                controller: descriptionController,

                decoration: InputDecoration(labelText: context.l10n.description),
              ),
            ],
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },

              child: Text(context.l10n.cancel),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },

              child: Text(context.l10n.update),
            ),
          ],
        );
      },
    );

    if (result == true) {
      await updateCategory(category['id']);
    }
  }

  Future<void> updateCategory(int categoryId) async {
    try {
      await CategoryService().updateCategory(
        id: categoryId,
        name: nameController.text,
        description: descriptionController.text,
      );

      await loadCategories();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.categoryUpdatedSuccessfully)),
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> confirmDeleteCategory(dynamic category) async {
    final confirmed = await showDialog<bool>(
      context: context,

      builder: (_) {
        return AlertDialog(
          title: Text(context.l10n.deleteCategory),

          content: Text(
            '${context.l10n.deleteCategoryQuestion}\n\n'
            '${category['name']}',
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },

              child: Text(context.l10n.cancel),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },

              child: Text(context.l10n.delete),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await deleteCategory(category['id']);
    }
  }

  Future<void> deleteCategory(int categoryId) async {
    try {
      await CategoryService().deleteCategory(categoryId);

      await loadCategories();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.categoryDeletedSuccessfully)),
      );
    } catch (e) {
      debugPrint(e.toString());

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.unableToDeleteCategory)),
      );
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: showAddCategoryDialog,

        child: const Icon(Icons.add),
      ),
      appBar: AppBar(title: Text(context.l10n.categories)),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : categories.isEmpty
          ? Center(child: Text(context.l10n.noCategoriesFound))
          : ListView.builder(
              padding: const EdgeInsets.only(bottom: 100),
              itemCount: categories.length,

              itemBuilder: (context, index) {
                final category = categories[index];

                return Card(
                  child: ListTile(
                    title: Text(category['name']),
                    subtitle:
                        (category['description'] ?? '')
                            .toString()
                            .trim()
                            .isEmpty
                        ? null
                        : Text(category['description']),

                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,

                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.orange),

                          onPressed: () {
                            showEditCategoryDialog(category);
                          },
                        ),

                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),

                          onPressed: () {
                            confirmDeleteCategory(category);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
