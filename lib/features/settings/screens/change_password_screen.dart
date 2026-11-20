import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import '../services/change_password_service.dart';
import '../../../core/localization/localization_extension.dart';

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
        SnackBar(content: Text(context.l10n.currentPasswordRequired)),
      );

      return;
    }

    if (newPasswordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.l10n.newPasswordRequired)));

      return;
    }

    if (confirmPasswordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.confirmPasswordRequired)),
      );

      return;
    }

    if (newPasswordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.l10n.passwordsDoNotMatch)));

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
        SnackBar(content: Text(context.l10n.passwordChangedSuccessfully)),
      );

      Navigator.pop(context);
    } on DioException catch (e) {
      String errorMessage = context.l10n.failedToChangePassword;

      if (e.response?.data is Map<String, dynamic>) {
        final data = e.response!.data as Map<String, dynamic>;
        errorMessage = data['detail']?.toString() ?? errorMessage;
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(errorMessage)));
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.changePassword)),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            TextField(
              controller: oldPasswordController,
              textDirection: Directionality.of(context),
              obscureText: obscureOldPassword,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: context.l10n.currentPassword,
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
              textDirection: Directionality.of(context),
              obscureText: obscureNewPassword,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: context.l10n.newPassword,

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
              textDirection: Directionality.of(context),
              obscureText: obscureConfirmPassword,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                labelText: context.l10n.confirmPassword,

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

              onSubmitted: (_) {
                if (!isLoading) {
                  changePassword();
                }
              },
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                onPressed: isLoading ? null : changePassword,

                child: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(context.l10n.changePassword),
              ),
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
