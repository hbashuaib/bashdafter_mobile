import 'package:flutter/material.dart';

class AppLocalizedName {
  AppLocalizedName._();

  static String resolve({
    required BuildContext context,
    required String name,
    required String? nameEn,
    required String? nameAr,
  }) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    if (isArabic) {
      if (nameAr != null && nameAr.trim().isNotEmpty) {
        return nameAr;
      }
    } else {
      if (nameEn != null && nameEn.trim().isNotEmpty) {
        return nameEn;
      }
    }

    return name;
  }

  static String resolveByLanguage({
    required bool isArabic,
    required String name,
    required String? nameEn,
    required String? nameAr,
  }) {
    if (isArabic) {
      if (nameAr != null && nameAr.trim().isNotEmpty) {
        return nameAr;
      }
    } else {
      if (nameEn != null && nameEn.trim().isNotEmpty) {
        return nameEn;
      }
    }

    return name;
  }
}
