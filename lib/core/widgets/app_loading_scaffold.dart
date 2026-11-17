import 'package:flutter/material.dart';

import 'app_loading.dart';

class AppLoadingScaffold extends StatelessWidget {
  final String? message;
  const AppLoadingScaffold({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: AppLoading(message: message));
  }
}
