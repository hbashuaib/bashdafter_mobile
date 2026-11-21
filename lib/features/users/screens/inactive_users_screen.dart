import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../services/user_service.dart';
import '../../../core/localization/localization_extension.dart';

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
        errorMessage = context.l10n.failedToLoadInactiveUsers;
        isLoading = false;
      });
    }
  }

  Future<void> restoreUser(UserModel user) async {
    try {
      await _userService.restoreUser(user.id);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.userRestoredSuccessfully(user.username)),
        ),
      );

      loadUsers();
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.l10n.failedToRestoreUser)));
    }
  }

  Future<void> showRestoreConfirmation(UserModel user) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(context.l10n.restoreUser),
          content: Text(context.l10n.restoreUserQuestion(user.username)),
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
              child: Text(context.l10n.restore),
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
        appBar: AppBar(title: Text(context.l10n.inactiveUsers)),
        body: Center(child: Text(errorMessage!)),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.inactiveUsers)),
      body: users.isEmpty
          ? ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                const SizedBox(height: 150),
                Center(child: Text(context.l10n.noInactiveUsersFound)),
              ],
            )
          : RefreshIndicator(
              onRefresh: loadUsers,

              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 100),
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];

                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text(
                          user.username.isNotEmpty
                              ? user.username.substring(0, 1).toUpperCase()
                              : '?',
                        ),
                      ),
                      title: Text(user.username),
                      subtitle: Text(user.role.replaceAll('_', ' ')),
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
