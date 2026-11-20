import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/localization/locale_provider.dart';
import '../../../core/localization/localization_extension.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.language)),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            Card(
              child: RadioListTile<String>(
                value: 'en',
                groupValue: localeProvider.locale.languageCode,
                title: Text(context.l10n.english),
                secondary: const Text('🇺🇸'),

                onChanged: (value) async {
                  if (value != null) {
                    await localeProvider.setLanguage(value);
                  }
                },
              ),
            ),

            Card(
              child: RadioListTile<String>(
                value: 'ar',
                groupValue: localeProvider.locale.languageCode,
                title: Text(context.l10n.arabic),
                secondary: const Text('🇾🇪'),

                onChanged: (value) async {
                  if (value != null) {
                    await localeProvider.setLanguage(value);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
