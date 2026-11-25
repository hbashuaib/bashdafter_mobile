import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../../../core/storage/token_storage.dart';
import '../../../core/navigation/main_navigation_screen.dart';
import '../../../core/localization/localization_extension.dart';
import '../../../core/widgets/app_form_field_helper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;
  bool obscurePassword = true;

  Future<void> login() async {
    if (usernameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(context.l10n.usernameRequired)));

      return;
    }

    if (passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(context.l10n.passwordRequired)));

      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final response = await AuthService().login(
        username: usernameController.text,
        password: passwordController.text,
      );

      final access = response.data['access'];
      final refresh = response.data['refresh'];

      await TokenStorage.saveTokens(access: access, refresh: refresh);

      final profile = await AuthService().getProfile();

      await TokenStorage.saveProfile(profile);

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.invalidUsernameOrPassword)),
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
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("BashDafter")),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              Image.asset('assets/images/bashsoft_logo.png', height: 120),
              const SizedBox(height: 40),
              Text(
                context.l10n.welcomeBack,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),
              Text(context.l10n.signInToContinue, textAlign: TextAlign.center),
              const SizedBox(height: 40),

              TextField(
                controller: usernameController,
                textDirection: TextDirection.ltr,
                textInputAction: TextInputAction.next,
                autocorrect: false,
                enableSuggestions: false,
                decoration: AppFormFieldHelper.decoration(
                  context: context,
                  label: context.l10n.username,
                  required: true,
                  border: const OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: passwordController,
                textDirection: TextDirection.ltr,
                obscureText: obscurePassword,
                textInputAction: TextInputAction.done,
                autocorrect: false,
                enableSuggestions: false,

                onSubmitted: (_) {
                  if (!isLoading) {
                    login();
                  }
                },

                decoration: AppFormFieldHelper.decoration(
                  context: context,
                  label: context.l10n.password,
                  required: true,
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscurePassword ? Icons.visibility : Icons.visibility_off,
                    ),

                    onPressed: () {
                      setState(() {
                        obscurePassword = !obscurePassword;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: isLoading ? null : login,

                child: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(context.l10n.login),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
