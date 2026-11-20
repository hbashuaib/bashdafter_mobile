import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/localization/localization_extension.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.about)),

      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 100),
        child: Center(
          child: Card(
            margin: const EdgeInsets.all(20),

            child: Padding(
              padding: const EdgeInsets.all(24),

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  Icon(Icons.store, size: 80, color: AppTheme.primaryBlue),
                  const SizedBox(height: 20),

                  Text(
                    context.l10n.applicationName,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    '${context.l10n.version} 1.0.0',

                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Card(
                    color: Theme.of(context).colorScheme.primary
                        .withValues(alpha: 0.05),
                    child: Padding(
                      padding: EdgeInsets.all(12),

                      child: Text(
                        context.l10n.aboutDescription,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Text(
                    context.l10n.businessAccountingAndInventoryManagementSystem,
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 20),

                  Text(
                    '${context.l10n.developedBy} '
                    '${context.l10n.companyName}',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    '© 2026 ${context.l10n.companyName}',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
