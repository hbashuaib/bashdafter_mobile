import 'package:flutter/material.dart';

import '../services/category_service.dart';
import '../models/category_model.dart';
import '../../../core/localization/localization_extension.dart';
import '../../../core/localization/app_localized_name.dart';
import '../../../core/widgets/app_form_field_helper.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {  
  final nameEnController = TextEditingController();
  final nameArController = TextEditingController();
  final descriptionController = TextEditingController();
  List<CategoryModel> categories = [];
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
    nameEnController.clear();
    nameArController.clear();
    descriptionController.clear();

    final result = await showDialog<bool>(
      context: context,

      builder: (_) {
        return AlertDialog(
          title: Text(context.l10n.addCategory),

          content: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Column(
                mainAxisSize: MainAxisSize.min,

                children: [                  
                  TextField(
                    controller: nameEnController,
                    textInputAction: TextInputAction.next,
                    textDirection: TextDirection.ltr,
                    decoration: AppFormFieldHelper.decoration(
                      context: context,
                      label: context.l10n.englishName,
                      required: true,
                    ),
                  ),

                  const SizedBox(height: 12),

                  TextField(
                    controller: nameArController,
                    textDirection: TextDirection.rtl,
                    textInputAction: TextInputAction.next,
                    decoration: AppFormFieldHelper.decoration(
                      context: context,
                      label: context.l10n.arabicName,
                    ),
                  ),

                  const SizedBox(height: 12),

                  TextField(
                    controller: descriptionController,
                    textDirection: Directionality.of(context),
                    decoration: AppFormFieldHelper.decoration(
                      context: context,
                      label: context.l10n.description,
                    ),
                  ),
                ],
              ),
            ),
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
    if (nameEnController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${context.l10n.englishName} ${context.l10n.englishNameRequired}',
          ),
        ),
      );

      return;
    }

    try {
      await CategoryService().createCategory(
        name: nameEnController.text,
        nameEn: nameEnController.text,
        nameAr: nameArController.text,
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

  Future<void> showEditCategoryDialog(CategoryModel category) async {    
    nameEnController.text = category.nameEn;
    nameArController.text = category.nameAr;
    descriptionController.text = category.description;

    final result = await showDialog<bool>(
      context: context,

      builder: (_) {
        return AlertDialog(
          title: Text(context.l10n.editCategory),

          content: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Column(
                mainAxisSize: MainAxisSize.min,

                children: [                  
                  TextField(
                    controller: nameEnController,
                    textDirection: TextDirection.ltr,
                    textInputAction: TextInputAction.next,
                    decoration: AppFormFieldHelper.decoration(
                      context: context,
                      label: context.l10n.englishName,
                      required: true,
                    ),
                  ),

                  const SizedBox(height: 12),

                  TextField(
                    controller: nameArController,
                    textDirection: TextDirection.rtl,
                    textInputAction: TextInputAction.next,
                    decoration: AppFormFieldHelper.decoration(
                      context: context,
                      label: context.l10n.arabicName,
                    ),
                  ),

                  const SizedBox(height: 12),

                  TextField(
                    controller: descriptionController,
                    textDirection: Directionality.of(context),
                    decoration: AppFormFieldHelper.decoration(
                      context: context,
                      label: context.l10n.description,
                    ),
                  ),
                ],
              ),
            ),
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
      await updateCategory(category.id);
    }
  }

  Future<void> updateCategory(int categoryId) async {
    try {
      await CategoryService().updateCategory(
        id: categoryId,
        name: nameEnController.text,
        nameEn: nameEnController.text,
        nameAr: nameArController.text,
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

  Future<void> confirmDeleteCategory(CategoryModel category) async {
    final confirmed = await showDialog<bool>(
      context: context,

      builder: (_) {
        return AlertDialog(
          title: Text(context.l10n.deleteCategory),

          content: Text(
            '${context.l10n.deleteCategoryQuestion}\n\n'
            '${AppLocalizedName.resolve(context: context, name: category.name, nameEn: category.nameEn, nameAr: category.nameAr)}',
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
      await deleteCategory(category.id);
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
    nameEnController.dispose();
    nameArController.dispose();
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
                    title: Text(
                      AppLocalizedName.resolve(
                        context: context,
                        name: category.name,
                        nameEn: category.nameEn,
                        nameAr: category.nameAr,
                      ),
                    ),
                    subtitle: category.description.trim().isEmpty
                        ? null
                        : Text(category.description),

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
