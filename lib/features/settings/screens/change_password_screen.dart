import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import '../services/change_password_service.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isLoading = false;
  bool obscureOldPassword = true;
  bool obscureNewPassword = true;
  bool obscureConfirmPassword = true;

  @override
  void dispose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();

    super.dispose();
  }

  Future<void> changePassword() async {
    if (oldPasswordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Current password is required')),
      );

      return;
    }

    if (newPasswordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('New password is required')));

      return;
    }

    if (confirmPasswordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Confirm password is required')),
      );

      return;
    }

    if (newPasswordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Passwords do not match')));

      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await ChangePasswordService().changePassword(
        oldPassword: oldPasswordController.text,
        newPassword: newPasswordController.text,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password changed successfully')),
      );

      Navigator.pop(context);
    } on DioException catch (e) {
      String errorMessage = 'Failed to change password';

      if (e.response?.data is Map<String, dynamic>) {
        final data = e.response!.data as Map<String, dynamic>;
        errorMessage = data['detail']?.toString() ?? errorMessage;
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(errorMessage)));
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
      appBar: AppBar(title: const Text('Change Password')),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            TextField(
              controller: oldPasswordController,
              obscureText: obscureOldPassword,

              decoration: InputDecoration(
                labelText: 'Current Password',

                border: const OutlineInputBorder(),

                suffixIcon: IconButton(
                  icon: Icon(
                    obscureOldPassword
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      obscureOldPassword = !obscureOldPassword;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: newPasswordController,
              obscureText: obscureNewPassword,

              decoration: InputDecoration(
                labelText: 'New Password',

                border: const OutlineInputBorder(),

                suffixIcon: IconButton(
                  icon: Icon(
                    obscureNewPassword
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      obscureNewPassword = !obscureNewPassword;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: confirmPasswordController,

              obscureText: obscureConfirmPassword,

              decoration: InputDecoration(
                labelText: 'Confirm Password',

                border: const OutlineInputBorder(),

                suffixIcon: IconButton(
                  icon: Icon(
                    obscureConfirmPassword
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      obscureConfirmPassword = !obscureConfirmPassword;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                onPressed: isLoading ? null : changePassword,

                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Change Password'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
