import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../services/user_service.dart';
import '../../../core/localization/localization_extension.dart';
import '../../../core/widgets/app_form_field_helper.dart';

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
      firstNameController.text = widget.user!.firstName;
      lastNameController.text = widget.user!.lastName;
      emailController.text = widget.user!.email;
      phoneController.text = widget.user!.phoneNumber;
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
          .showSnackBar(SnackBar(content: Text(context.l10n.usernameRequired)));

      return;
    }

    if (!widget.isEdit && passwordController.text.trim().length < 6) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.l10n.passwordMinLength)));

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
                ? context.l10n.userUpdatedSuccessfully
                : context.l10n.userCreatedSuccessfully,
          ),
        ),
      );

      Navigator.pop(context, true);
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.isEdit
                ? context.l10n.failedToUpdateUser
                : context.l10n.failedToCreateUser,
          ),
        ),
      );
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
      appBar: AppBar(
        title: Text(
          widget.isEdit
              ? context.l10n.userFormEditTitle
              : context.l10n.userFormCreateTitle,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: usernameController,
            textDirection: TextDirection.ltr,
            textInputAction: TextInputAction.next,
            decoration: AppFormFieldHelper.decoration(
              context: context,
              label: context.l10n.username,
              required: true,
            ),
          ),

          const SizedBox(height: 16),

          TextField(
            controller: firstNameController,
            textDirection: Directionality.of(context),
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
            decoration: AppFormFieldHelper.decoration(
              context: context,
              label: context.l10n.firstName,
            ),
          ),

          const SizedBox(height: 16),

          TextField(
            controller: lastNameController,
            textDirection: Directionality.of(context),
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
            decoration: AppFormFieldHelper.decoration(
              context: context,
              label: context.l10n.lastName,
            ),
          ),

          const SizedBox(height: 16),

          TextField(
            controller: emailController,
            textDirection: TextDirection.ltr,
            keyboardType: TextInputType.emailAddress,
            autocorrect: false,
            enableSuggestions: false,
            textInputAction: TextInputAction.next,
            decoration: AppFormFieldHelper.decoration(
              context: context,
              label: context.l10n.email,
            ),
          ),

          const SizedBox(height: 16),

          TextField(
            controller: phoneController,
            textDirection: TextDirection.ltr,
            keyboardType: TextInputType.phone,
            autocorrect: false,
            enableSuggestions: false,
            textInputAction: TextInputAction.next,
            decoration: AppFormFieldHelper.decoration(
              context: context,
              label: context.l10n.phoneNumber,
            ),
          ),

          if (!widget.isEdit) ...[
            const SizedBox(height: 16),

            TextField(
              controller: passwordController,
              textDirection: TextDirection.ltr,
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              textInputAction: TextInputAction.next,
              decoration: AppFormFieldHelper.decoration(
                context: context,
                label: context.l10n.password,
                required: true,
              ),
            ),
          ],

          const SizedBox(height: 16),

          DropdownButtonFormField<String>(
            initialValue: selectedRole,
            decoration: AppFormFieldHelper.decoration(
              context: context,
              label: context.l10n.role,
              required: true,
            ),
            items: [
              DropdownMenuItem(
                value: 'ADMIN',
                child: Text(context.l10n.adminRole),
              ),

              DropdownMenuItem(
                value: 'MANAGER',
                child: Text(context.l10n.managerRole),
              ),

              DropdownMenuItem(
                value: 'CASHIER',
                child: Text(context.l10n.cashierRole),
              ),
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
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      widget.isEdit
                          ? context.l10n.saveChanges
                          : context.l10n.createUser,
                    ),
            ),
          ),

          const SizedBox(height: 100),
        ],
      ),
    );
  }
}
