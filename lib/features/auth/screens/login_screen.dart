import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../../../core/storage/token_storage.dart';
import '../../../core/navigation/main_navigation_screen.dart';
import '../models/user_profile.dart';

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
          .showSnackBar(const SnackBar(content: Text('Username is required')));

      return;
    }

    if (passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Password is required')));

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

      final profileResponse = await AuthService().getProfile();
      final profile = UserProfile.fromJson(profileResponse.data);

      await TokenStorage.saveProfile(profile);      

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
      );
      
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid username or password')),
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
      appBar: AppBar(title: const Text("BashDafter")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            Image.asset('assets/images/bashsoft_logo.png', height: 120),
            const SizedBox(height: 40),
            const Text(
              "Welcome Back",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),
            const Text("Sign in to continue", textAlign: TextAlign.center),
            const SizedBox(height: 40),

            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                labelText: "Username",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: passwordController,
              obscureText: obscurePassword,
              textInputAction: TextInputAction.done,

              onSubmitted: (_) {
                if (!isLoading) {
                  login();
                }
              },

              decoration: InputDecoration(
                labelText: "Password",
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
                  : const Text("Login"),
            ),
          ],
        ),
      ),
    );
  }
}
