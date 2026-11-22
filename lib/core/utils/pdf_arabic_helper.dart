import 'package:arabic_reshaper/arabic_reshaper.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfArabicHelper {
  PdfArabicHelper._();

  static String text(String value) {
    return ArabicReshaper.instance.reshape(value);
  }

  static pw.TextStyle style(pw.Font arabicFont) {
    return pw.TextStyle(font: arabicFont);
  }

  static pw.Widget widget({
    required String text,
    required pw.Font arabicFont,
    double? fontSize,
    pw.FontWeight? fontWeight,
  }) {
    return pw.Directionality(
      textDirection: pw.TextDirection.rtl,
      child: pw.Text(
        ArabicReshaper.instance.reshape(text),
        style: pw.TextStyle(
          font: arabicFont,
          fontSize: fontSize,
          fontWeight: fontWeight,
        ),
      ),
    );
  }

  static String display(String value, bool isArabic) {
    return isArabic ? ArabicReshaper.instance.reshape(value) : value;
  }

  static pw.Widget rtl({required pw.Widget child}) {
    return pw.Directionality(textDirection: pw.TextDirection.rtl, child: child);
  }
}
