import 'package:flutter/material.dart';

import '../services/unit_service.dart';
import '../../../core/localization/localization_extension.dart';

class UnitsScreen extends StatefulWidget {
  const UnitsScreen({super.key});

  @override
  State<UnitsScreen> createState() => _UnitsScreenState();
}

class _UnitsScreenState extends State<UnitsScreen> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  List<dynamic> units = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    loadUnits();
  }

  Future<void> loadUnits() async {
    try {
      final data = await UnitService().getUnits();

      if (!mounted) return;

      setState(() {
        units = data;
        isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> showAddUnitDialog() async {
    nameController.clear();
    descriptionController.clear();

    final result = await showDialog<bool>(
      context: context,

      builder: (_) {
        return AlertDialog(
          title: Text(context.l10n.addUnit),

          content: Column(
            mainAxisSize: MainAxisSize.min,

            children: [
              TextField(
                controller: nameController,
                textDirection: Directionality.of(context),
                decoration: InputDecoration(labelText: context.l10n.unitName),
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
      await createUnit();
    }
  }

  Future<void> createUnit() async {
    if (nameController.text.trim().isEmpty) {
      return;
    }

    try {
      await UnitService().createUnit(
        name: nameController.text,
        description: descriptionController.text,
      );

      await loadUnits();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.unitAddedSuccessfully)),
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> showEditUnitDialog(dynamic unit) async {
    nameController.text = unit['name'] ?? '';

    descriptionController.text = unit['description'] ?? '';

    final result = await showDialog<bool>(
      context: context,

      builder: (_) {
        return AlertDialog(
          title: Text(context.l10n.editUnit),

          content: Column(
            mainAxisSize: MainAxisSize.min,

            children: [
              TextField(
                controller: nameController,

                decoration: const InputDecoration(labelText: 'Unit Name'),
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

              child: Text(context.l10n.update),
            ),
          ],
        );
      },
    );

    if (result == true) {
      await updateUnit(unit['id']);
    }
  }

  Future<void> updateUnit(int unitId) async {
    try {
      await UnitService().updateUnit(
        id: unitId,

        name: nameController.text,

        description: descriptionController.text,
      );

      await loadUnits();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.unitUpdatedSuccessfully)),
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> confirmDeleteUnit(dynamic unit) async {
    final confirmed = await showDialog<bool>(
      context: context,

      builder: (_) {
        return AlertDialog(
          title: Text(context.l10n.deleteUnit),

          content: Text(
            '${context.l10n.deleteUnitQuestion}\n\n'
            '${unit['name']}',
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

              child: Text(context.l10n.delete),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await deleteUnit(unit['id']);
    }
  }

  Future<void> deleteUnit(int unitId) async {
    try {
      await UnitService().deleteUnit(unitId);

      await loadUnits();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.unitDeletedSuccessfully)),
      );
    } catch (e) {
      debugPrint(e.toString());

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(context.l10n.unableToDeleteUnit)));
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
        onPressed: showAddUnitDialog,

        child: const Icon(Icons.add),
      ),
      appBar: AppBar(title: Text(context.l10n.units)),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : units.isEmpty
          ? Center(child: Text(context.l10n.noUnitsFound))
          : ListView.builder(
              padding: const EdgeInsets.only(bottom: 100),
              itemCount: units.length,

              itemBuilder: (context, index) {
                final unit = units[index];

                return Card(
                  child: ListTile(
                    title: Text(unit['name']),

                    subtitle:
                        (unit['description'] ?? '').toString().trim().isEmpty
                        ? null
                        : Text(unit['description']),

                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,

                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.orange),

                          onPressed: () {
                            showEditUnitDialog(unit);
                          },
                        ),

                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),

                          onPressed: () {
                            confirmDeleteUnit(unit);
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
