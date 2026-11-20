import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppFormatters {
  AppFormatters._();

  static String number(BuildContext context, num value) {
    final locale = Localizations.localeOf(context).languageCode;

    return NumberFormat.decimalPattern(locale).format(value);
  }

  static String decimal(BuildContext context, num value) {
    final locale = Localizations.localeOf(context).languageCode;

    return NumberFormat('#,##0.00', locale).format(value);
  }

  static String currency(BuildContext context, num amount) {
    final locale = Localizations.localeOf(context).languageCode;

    return NumberFormat.currency(
      locale: locale,
      symbol: locale == 'ar' ? 'ر.ي' : 'YER',
      decimalDigits: 2,
    ).format(amount);
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
