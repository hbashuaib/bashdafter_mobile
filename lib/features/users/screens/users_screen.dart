import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../services/user_service.dart';
import '../../../core/storage/token_storage.dart';

import 'inactive_users_screen.dart';
import 'user_form_screen.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final UserService _userService = UserService();
  final TextEditingController searchController = TextEditingController();

  List<UserModel> users = [];
  List<UserModel> filteredUsers = [];
  bool isLoading = true;
  String? errorMessage;
  int? currentUserId;

  @override
  void initState() {
    super.initState();
    loadUsers();
    loadCurrentUser();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void filterUsers(String query) {
    setState(() {
      filteredUsers = users
          .where(
            (user) => user.username.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    });
  }

  void showUserActions(UserModel user) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit, color: Colors.blue),
                title: const Text('Edit User'),
                onTap: () async {
                  Navigator.pop(context);

                  final result = await Navigator.push(
                    this.context,
                    MaterialPageRoute(
                      builder: (_) => UserFormScreen(user: user),
                    ),
                  );

                  if (result == true) {
                    loadUsers();
                  }
                },
              ),

              ListTile(
                leading: const Icon(Icons.lock_reset, color: Colors.indigo),
                title: const Text('Reset Password'),
                onTap: () {
                  Navigator.pop(context);
                  showResetPasswordDialog(user);
                },
              ),

              if (user.id != currentUserId)
                ListTile(
                  leading: const Icon(Icons.block, color: Colors.red),
                  title: const Text('Deactivate User'),
                  onTap: () {
                    Navigator.pop(context);
                    showDeactivateConfirmation(user);
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  void showResetPasswordDialog(UserModel user) {
    final controller = TextEditingController();

    showDialog(
      context: context,

      builder: (dialogContext) {
        return AlertDialog(
          title: Text('Reset ${user.username}'),

          content: TextField(
            controller: controller,
            decoration: const InputDecoration(labelText: 'New Password'),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },

              child: const Text('Cancel'),
            ),

            ElevatedButton(
              onPressed: () async {
                final password = controller.text.trim();

                if (controller.text.trim().length < 6) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Password must be at least 6 characters'),
                    ),
                  );

                  return;
                }

                Navigator.pop(dialogContext);
                await resetPassword(user, password);
              },

              child: const Text('Reset'),
            ),
          ],
        );
      },
    );
  }

  Future<void> loadUsers() async {
    try {
      final response = await _userService.getUsers();

      final loadedUsers = response
          .map((json) => UserModel.fromJson(json))
          .toList();

      if (!mounted) return;

      setState(() {
        users = loadedUsers;
        filteredUsers = loadedUsers;
        errorMessage = null;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        errorMessage = 'Failed to load users';
        isLoading = false;
      });
    }
  }

  Future<void> loadCurrentUser() async {
    final profile = await TokenStorage.getProfile();

    if (!mounted) return;

    setState(() {
      currentUserId = profile?.id;
    });
  }

  Future<void> resetPassword(UserModel user, String password) async {
    try {
      await _userService.resetPassword(id: user.id, password: password);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${user.username} password reset successfully')),
      );
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to reset password')));
    }
  }

  Future<void> deactivateUser(UserModel user) async {
    try {
      await _userService.deleteUser(user.id);
      await loadUsers();

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('${user.username} deactivated')));
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to deactivate user')),
      );
    }
  }

  Future<void> showDeactivateConfirmation(UserModel user) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Deactivate User'),
          content: Text(
            'Are you sure you want to deactivate ${user.username}?',
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

    if (confirmed == true) {
      await deactivateUser(user);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (errorMessage != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('User Management')),
        body: Center(child: Text(errorMessage!)),
      );
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const UserFormScreen()),
          );

          if (result == true) {
            loadUsers();
          }
        },

        child: const Icon(Icons.add),
      ),

      appBar: AppBar(
        title: const Text('User Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.restore_from_trash),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const InactiveUsersScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                labelText: 'Search Users',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: filterUsers,
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: loadUsers,
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 100),
                itemCount: filteredUsers.length,
                itemBuilder: (context, index) {
                  final user = filteredUsers[index];

                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    child: ListTile(
                      onTap: () {
                        showUserActions(user);
                      },

                      leading: CircleAvatar(
                        child: Text(
                          user.username.isNotEmpty
                              ? user.username.substring(0, 1).toUpperCase()
                              : '?',
                        ),
                      ),
                      title: Text(user.username),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user.role.replaceAll('_', ' ')),

                          if (user.email != null && user.email!.isNotEmpty)
                            Text(
                              user.email!,
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12,
                              ),
                            ),
                        ],
                      ),
                      trailing: Icon(
                        user.isActive ? Icons.check_circle : Icons.cancel,
                        color: user.isActive ? Colors.green : Colors.red,
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
