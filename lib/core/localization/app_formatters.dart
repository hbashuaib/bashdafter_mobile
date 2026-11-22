import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppFormatters {
  AppFormatters._();

  static const Map<String, String> arabicSymbols = {
    'YER': 'ر.ي',
    'SAR': 'ر.س',
    'AED': 'د.إ',
    'QAR': 'ر.ق',
    'OMR': 'ر.ع',
    'KWD': 'د.ك',
    'BHD': 'د.ب',
    'JOD': 'د.أ',
    'IQD': 'د.ع',
    'EGP': 'ج.م',
    'MAD': 'د.م',
    'DZD': 'د.ج',
    'TND': 'د.ت',
    'LYD': 'د.ل',
    'SDG': 'ج.س',
    'USD': '\$',
    'EUR': '€',
  };

  static const Map<String, String> arabicDigits = {
    '0': '٠',
    '1': '١',
    '2': '٢',
    '3': '٣',
    '4': '٤',
    '5': '٥',
    '6': '٦',
    '7': '٧',
    '8': '٨',
    '9': '٩',
  };

  static String _toArabicDigits(String value) {
    return value.replaceAllMapped(
      RegExp(r'\d'),
      (match) => arabicDigits[match.group(0)]!,
    );
  }

  static String number(BuildContext context, num value) {
    final locale = Localizations.localeOf(context).languageCode;
    final formatted = NumberFormat.decimalPattern(locale).format(value);
    return locale == 'ar' ? _toArabicDigits(formatted) : formatted;
  }

  static String decimal(BuildContext context, num value) {
    final locale = Localizations.localeOf(context).languageCode;
    final formatted = NumberFormat('#,##0.00', locale).format(value);
    return locale == 'ar' ? _toArabicDigits(formatted) : formatted;
  }

  static String currency(
    BuildContext context,
    num amount,
    String currencyCode,
  ) {
    final locale = Localizations.localeOf(context).languageCode;

    final symbol = locale == 'ar'
        ? arabicSymbols[currencyCode] ?? currencyCode
        : currencyCode;

    final formatted = NumberFormat.currency(
      locale: locale,
      symbol: '$symbol ',
      decimalDigits: 2,
    ).format(amount);

    return locale == 'ar' ? _toArabicDigits(formatted) : formatted;
  }

  static String date(BuildContext context, DateTime date) {
    final locale = Localizations.localeOf(context).languageCode;

    return DateFormat.yMMMMd(locale).format(date);
  }

  static String shortDate(BuildContext context, DateTime date) {
    final locale = Localizations.localeOf(context).languageCode;

    return DateFormat.yMd(locale).format(date);
  }

  static String dateTime(BuildContext context, DateTime date) {
    final locale = Localizations.localeOf(context).languageCode;

    return DateFormat.yMd(locale).add_jm().format(date);
  }
}
