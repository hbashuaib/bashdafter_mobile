import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../services/user_service.dart';

class UserFormScreen extends StatefulWidget {
  final UserModel? user;

  const UserFormScreen({super.key, this.user});

  bool get isEdit => user != null;

  @override
  State<UserFormScreen> createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {
  final UserService _userService = UserService();

  final usernameController = TextEditingController();

  final firstNameController = TextEditingController();

  final lastNameController = TextEditingController();

  final emailController = TextEditingController();

  final phoneController = TextEditingController();

  final passwordController = TextEditingController();

  String selectedRole = 'CASHIER';

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    if (widget.user != null) {
      usernameController.text = widget.user!.username;

      firstNameController.text = widget.user!.firstName ?? '';

      lastNameController.text = widget.user!.lastName ?? '';

      emailController.text = widget.user!.email ?? '';

      phoneController.text = widget.user!.phoneNumber ?? '';

      selectedRole = widget.user!.role;
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  Future<void> saveUser() async {
    if (usernameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Username is required')));

      return;
    }

    if (!widget.isEdit && passwordController.text.trim().length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password must be at least 6 characters')),
      );

      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      if (widget.isEdit) {
        await _userService.updateUser(
          id: widget.user!.id,
          username: usernameController.text.trim(),
          firstName: firstNameController.text.trim(),
          lastName: lastNameController.text.trim(),
          email: emailController.text.trim(),
          phoneNumber: phoneController.text.trim(),
          role: selectedRole,
          shop: widget.user!.shop,
          isActive: widget.user!.isActive,
        );
      } else {
        await _userService.createUser(
          username: usernameController.text.trim(),
          password: passwordController.text.trim(),
          role: selectedRole,
        );
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.isEdit
                ? 'User updated successfully'
                : 'User created successfully',
          ),
        ),
      );

      Navigator.pop(context, true);
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.isEdit ? 'Failed to update user' : 'Failed to create user',
          ),
        ),
      );
    } finally {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.isEdit ? 'Edit User' : 'Create User')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: usernameController,
            decoration: const InputDecoration(
              labelText: 'Username',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 16),

          TextField(
            controller: firstNameController,
            decoration: const InputDecoration(
              labelText: 'First Name',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 16),

          TextField(
            controller: lastNameController,
            decoration: const InputDecoration(
              labelText: 'Last Name',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 16),

          TextField(
            controller: emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 16),

          TextField(
            controller: phoneController,
            decoration: const InputDecoration(
              labelText: 'Phone Number',
              border: OutlineInputBorder(),
            ),
          ),

          if (!widget.isEdit) ...[
            const SizedBox(height: 16),

            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
          ],

          const SizedBox(height: 16),

          DropdownButtonFormField<String>(
            value: selectedRole,
            decoration: const InputDecoration(
              labelText: 'Role',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(value: 'ADMIN', child: Text('ADMIN')),
              DropdownMenuItem(value: 'MANAGER', child: Text('MANAGER')),
              DropdownMenuItem(value: 'CASHIER', child: Text('CASHIER')),
            ],
            onChanged: (value) {
              setState(() {
                selectedRole = value!;
              });
            },
          ),

          const SizedBox(height: 30),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isLoading ? null : saveUser,
              child: isLoading
                  ? const CircularProgressIndicator()
                  : Text(widget.isEdit ? 'Save Changes' : 'Create User'),
            ),
          ),

          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
