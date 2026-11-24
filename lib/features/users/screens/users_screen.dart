import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../services/user_service.dart';
import '../../../core/storage/token_storage.dart';
import '../../../core/localization/localization_extension.dart';

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
                title: Text(context.l10n.editUser),
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
                title: Text(context.l10n.resetPassword),
                onTap: () {
                  Navigator.pop(context);
                  showResetPasswordDialog(user);
                },
              ),

              if (user.id != currentUserId)
                ListTile(
                  leading: const Icon(Icons.block, color: Colors.red),
                  title: Text(context.l10n.deactivateUser),
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
          title: Text(context.l10n.resetUserPassword(user.username)),

          content: TextField(
            controller: controller,
            obscureText: true,
            decoration: InputDecoration(labelText: context.l10n.newPassword),
          ),

          actions: [
            TextButton(
              onPressed: () {
                controller.dispose();
                Navigator.pop(dialogContext);
              },

              child: Text(context.l10n.cancel),
            ),

            ElevatedButton(
              onPressed: () async {
                final password = controller.text.trim();

                if (password.length < 6) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(context.l10n.passwordMinLength)),
                  );

                  return;
                }

                controller.dispose();

                Navigator.pop(dialogContext, true);
                await resetPassword(user, password);
              },

              child: Text(context.l10n.resetPassword),
            ),
          ],
        );
      },
    );
  }

  Future<void> loadUsers() async {
    try { 
      final loadedUsers = await _userService.getUsers();

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
        errorMessage = context.l10n.failedToLoadUsers;
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
        SnackBar(
          content: Text(context.l10n.resetPasswordSuccess(user.username)),
        ),
      );
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.failedToResetPassword)),
      );
    }
  }

  Future<void> deactivateUser(UserModel user) async {
    try {
      await _userService.deleteUser(user.id);
      await loadUsers();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.userDeactivated(user.username))),
      );
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.failedToDeactivateUser)),
      );
    }
  }

  Future<void> showDeactivateConfirmation(UserModel user) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(context.l10n.deactivateUser),
          content: Text(context.l10n.deactivateUserQuestion(user.username)),
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
              child: Text(context.l10n.deactivateUser),
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
        appBar: AppBar(title: Text(context.l10n.userManagement)),
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
              decoration: InputDecoration(
                labelText: context.l10n.searchUsers,
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: filterUsers,
            ),
          ),
          Expanded(
            child: filteredUsers.isEmpty
                ? ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      SizedBox(height: 150),
                      Center(child: Text(context.l10n.noUsersFound)),
                    ],
                  )
                : RefreshIndicator(
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
                                    ? user.username
                                          .substring(0, 1)
                                          .toUpperCase()
                                    : '?',
                              ),
                            ),
                            title: Text(user.username),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(user.role.replaceAll('_', ' ')),

                                if (user.email.isNotEmpty)
                                  Text(
                                    user.email,
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
