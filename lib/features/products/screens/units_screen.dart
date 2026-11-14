import 'package:flutter/material.dart';

import '../services/unit_service.dart';

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
          title: const Text('Add Unit'),

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

              child: const Text('Save'),
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

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Unit added successfully')));
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
          title: const Text('Edit Unit'),

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

              child: const Text('Update'),
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
        const SnackBar(content: Text('Unit updated successfully')),
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
          title: const Text('Delete Unit'),

          content: Text('Delete "${unit['name']}"?'),

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
      await deleteUnit(unit['id']);
    }
  }

  Future<void> deleteUnit(int unitId) async {
    try {
      await UnitService().deleteUnit(unitId);

      await loadUnits();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unit deleted successfully')),
      );
    } catch (e) {
      debugPrint(e.toString());

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Unable to delete unit')));
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
      appBar: AppBar(title: const Text('Units')),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : units.isEmpty
          ? const Center(child: Text('No units found'))
          : ListView.builder(
              itemCount: units.length,

              itemBuilder: (context, index) {
                final unit = units[index];

                return Card(
                  child: ListTile(
                    title: Text(unit['name']),

                    subtitle: Text(unit['description'] ?? ''),

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
