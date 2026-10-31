import 'package:flutter/material.dart';
import 'features/auth/screens/login_screen.dart';

import 'core/theme/app_theme.dart';

void main() {
  runApp(
    const BashDafterApp(),
  );
}

class BashDafterApp extends StatelessWidget {
  const BashDafterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BashDafter',

      debugShowCheckedModeBanner: false,

      theme: AppTheme.lightTheme,

      home: const LoginScreen(),
    );
  }
}