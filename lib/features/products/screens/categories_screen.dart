import 'package:flutter/material.dart';

import '../services/category_service.dart';

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
          title: const Text('Add Category'),

          content: Column(
            mainAxisSize: MainAxisSize.min,

            children: [
              TextField(
                controller: nameController,

                decoration: const InputDecoration(labelText: 'Category Name'),
              ),

              const SizedBox(height: 12),

              TextField(
                controller: descriptionController,

                decoration: const InputDecoration(labelText: 'Description'),
              ),
            ],
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },

              child: const Text('Cancel'),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },

              child: const Text('Save'),
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
        const SnackBar(content: Text('Category added successfully')),
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
          title: const Text('Edit Category'),

          content: Column(
            mainAxisSize: MainAxisSize.min,

            children: [
              TextField(
                controller: nameController,

                decoration: const InputDecoration(labelText: 'Category Name'),
              ),

              const SizedBox(height: 12),

              TextField(
                controller: descriptionController,

                decoration: const InputDecoration(labelText: 'Description'),
              ),
            ],
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },

              child: const Text('Cancel'),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },

              child: const Text('Update'),
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
        const SnackBar(content: Text('Category updated successfully')),
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
          title: const Text('Delete Category'),

          content: Text('Delete "${category['name']}"?'),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },

              child: const Text('Cancel'),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },

              child: const Text('Delete'),
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
        const SnackBar(content: Text('Category deleted successfully')),
      );
    } catch (e) {
      debugPrint(e.toString());

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to delete category')),
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
      appBar: AppBar(title: const Text('Categories')),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : categories.isEmpty
          ? const Center(child: Text('No categories found'))
          : ListView.builder(
              itemCount: categories.length,

              itemBuilder: (context, index) {
                final category = categories[index];

                return Card(
                  child: ListTile(
                    title: Text(category['name']),
                    subtitle: Text(category['description'] ?? ''),

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
