import 'package:intl/intl.dart';

class PdfFormatters {
  PdfFormatters._();

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
    var text = value;

    text = text.replaceAll(',', '٬');
    text = text.replaceAll('.', '٫');

    return text.replaceAllMapped(
      RegExp(r'\d'),
      (match) => arabicDigits[match.group(0)]!,
    );
  }

  static String number(num value, {bool isArabic = false}) {
    final formatted = NumberFormat.decimalPattern(isArabic ? 'ar' : 'en')
        .format(value);

    return isArabic ? _toArabicDigits(formatted) : formatted;
  }

  static String decimal(num value, {bool isArabic = false}) {
    final formatted = NumberFormat(
      '#,##0.00',
      isArabic ? 'ar' : 'en',
    ).format(value);

    return isArabic ? _toArabicDigits(formatted) : formatted;
  }

  static String currency(
    num value,
    String currencyCode, {
    bool isArabic = false,
  }) {
    final symbol = isArabic
        ? arabicSymbols[currencyCode] ?? currencyCode
        : currencyCode;

    final formatted = NumberFormat.currency(
      locale: isArabic ? 'ar' : 'en',
      symbol: '$symbol ',
      decimalDigits: 2,
    ).format(value);

    return isArabic ? _toArabicDigits(formatted) : formatted;
  }

  static String date(DateTime date, {bool isArabic = false}) {
    final formatted = DateFormat.yMMMMd(isArabic ? 'ar' : 'en').format(date);

    return isArabic ? _toArabicDigits(formatted) : formatted;
  }

  static String shortDate(DateTime date, {bool isArabic = false}) {
    final formatted = DateFormat.yMd(isArabic ? 'ar' : 'en').format(date);

    return isArabic ? _toArabicDigits(formatted) : formatted;
  }
}
