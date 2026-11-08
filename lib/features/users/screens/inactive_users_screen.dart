import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../services/user_service.dart';

class InactiveUsersScreen extends StatefulWidget {
  const InactiveUsersScreen({super.key});

  @override
  State<InactiveUsersScreen> createState() => _InactiveUsersScreenState();
}

class _InactiveUsersScreenState extends State<InactiveUsersScreen> {
  final UserService _userService = UserService();

  List<UserModel> users = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();

    loadUsers();
  }

  Future<void> loadUsers() async {
    try {
      final response = await _userService.getInactiveUsers();

      final loadedUsers = response
          .map((json) => UserModel.fromJson(json))
          .toList();

      if (!mounted) return;

      setState(() {
        users = loadedUsers;
        errorMessage = null;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        errorMessage = 'Failed to load inactive users';
        isLoading = false;
      });
    }
  }

  Future<void> restoreUser(UserModel user) async {
    try {
      await _userService.restoreUser(user.id);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${user.username} restored successfully')),
      );

      loadUsers();
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to restore user')));
    }
  }

  Future<void> showRestoreConfirmation(UserModel user) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Restore User'),
          content: Text('Are you sure you want to restore ${user.username}?'),
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
              child: const Text('Restore'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await restoreUser(user);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (errorMessage != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Inactive Users')),
        body: Center(child: Text(errorMessage!)),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Inactive Users')),
      body: RefreshIndicator(
        onRefresh: loadUsers,
        child: ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: ListTile(
                leading: CircleAvatar(
                  child: Text(
                    user.username.isNotEmpty
                        ? user.username.substring(0, 1).toUpperCase()
                        : '?',
                  ),
                ),
                title: Text(user.username),
                subtitle: Text(user.role),
                trailing: IconButton(
                  icon: const Icon(Icons.restore, color: Colors.green),
                  onPressed: () {
                    showRestoreConfirmation(user);
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
