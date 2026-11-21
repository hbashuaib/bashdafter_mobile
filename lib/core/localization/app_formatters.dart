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

  static String number(
    BuildContext context,
    num value,
  ) {
    final locale =
        Localizations.localeOf(context).languageCode;

    return NumberFormat.decimalPattern(
      locale,
    ).format(value);
  }

  static String decimal(
    BuildContext context,
    num value,
  ) {
    final locale =
        Localizations.localeOf(context).languageCode;

    return NumberFormat(
      '#,##0.00',
      locale,
    ).format(value);
  }

  static String currency(
    BuildContext context,
    num amount,
    String currencyCode,
  ) {
    final locale =
        Localizations.localeOf(context).languageCode;

    final symbol = locale == 'ar'
        ? arabicSymbols[currencyCode] ??
            currencyCode
        : currencyCode;

    return NumberFormat.currency(
      locale: locale,
      symbol: '$symbol ',
      decimalDigits: 2,
    ).format(amount);
  }

  static String date(
    BuildContext context,
    DateTime date,
  ) {
    final locale =
        Localizations.localeOf(context).languageCode;

    return DateFormat.yMMMMd(
      locale,
    ).format(date);
  }

  static String shortDate(
    BuildContext context,
    DateTime date,
  ) {
    final locale =
        Localizations.localeOf(context).languageCode;

    return DateFormat.yMd(
      locale,
    ).format(date);
  }

  static String dateTime(
    BuildContext context,
    DateTime date,
  ) {
    final locale =
        Localizations.localeOf(context).languageCode;

    return DateFormat.yMd(
      locale,
    ).add_jm()
        .format(date);
  }
}