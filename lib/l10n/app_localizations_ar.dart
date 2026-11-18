// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'باش دفتر';

  @override
  String get products => 'المنتجات';

  @override
  String get customers => 'العملاء';

  @override
  String get payments => 'المدفوعات';

  @override
  String get purchases => 'المشتريات';

  @override
  String get reports => 'التقارير';

  @override
  String get inventory => 'المخزون';

  @override
  String get settings => 'الإعدادات';

  @override
  String get search => 'بحث';

  @override
  String get save => 'حفظ';

  @override
  String get cancel => 'إلغاء';

  @override
  String get delete => 'حذف';

  @override
  String get edit => 'تعديل';

  @override
  String get loading => 'جاري التحميل...';

  @override
  String get noDataFound => 'لا توجد بيانات';

  @override
  String get profileNotFound => 'لم يتم العثور على الملف الشخصي';

  @override
  String get userManagement => 'إدارة المستخدمين';

  @override
  String get manageSystemUsers => 'إدارة مستخدمي النظام';

  @override
  String get productCategories => 'فئات المنتجات';

  @override
  String get manageProductCategories => 'إدارة فئات المنتجات';

  @override
  String get productUnits => 'وحدات المنتجات';

  @override
  String get manageProductUnits => 'إدارة وحدات المنتجات';

  @override
  String get manageApplicationPreferences => 'إدارة تفضيلات ومعلومات التطبيق';

  @override
  String get shopProfile => 'بيانات المتجر';

  @override
  String get manageShopInformation => 'إدارة معلومات المتجر';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get userAndApplicationDetails => 'بيانات المستخدم والتطبيق';

  @override
  String get language => 'اللغة';

  @override
  String get changeApplicationLanguage => 'تغيير لغة التطبيق';

  @override
  String get darkMode => 'الوضع الداكن';

  @override
  String get darkModeEnabled => 'تم تفعيل الوضع الداكن';

  @override
  String get lightModeEnabled => 'تم تفعيل الوضع الفاتح';

  @override
  String get about => 'حول التطبيق';

  @override
  String get applicationInformation => 'معلومات التطبيق';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get signOut => 'تسجيل الخروج من التطبيق';

  @override
  String get areYouSureLogout => 'هل أنت متأكد من تسجيل الخروج؟';

  @override
  String get welcomeBack => 'مرحباً بعودتك';

  @override
  String get signInToContinue => 'سجل الدخول للمتابعة';

  @override
  String get username => 'اسم المستخدم';

  @override
  String get password => 'كلمة المرور';

  @override
  String get usernameRequired => 'اسم المستخدم مطلوب';

  @override
  String get passwordRequired => 'كلمة المرور مطلوبة';

  @override
  String get invalidUsernameOrPassword =>
      'اسم المستخدم أو كلمة المرور غير صحيحة';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get dashboard => 'الرئيسية';

  @override
  String get failedToLoadDashboard => 'فشل في تحميل لوحة التحكم';

  @override
  String get noDashboardDataAvailable => 'لا توجد بيانات متاحة';

  @override
  String get businessDashboard => 'لوحة الأعمال';

  @override
  String get businessDashboardDescription =>
      'متابعة العملاء والمشتريات والمدفوعات والمخزون';

  @override
  String get customersCount => 'العملاء';

  @override
  String get balance => 'الرصيد';

  @override
  String get businessOverview => 'نظرة عامة على الأعمال';

  @override
  String get totalPurchases => 'إجمالي المشتريات';

  @override
  String get totalPayments => 'إجمالي المدفوعات';

  @override
  String get quickActions => 'إجراءات سريعة';

  @override
  String get inventoryManagement => 'إدارة المخزون';

  @override
  String get inventoryManagementDescription => 'تعديلات المخزون وسجل المخزون';

  @override
  String get voiceEntry => 'الإدخال الصوتي';

  @override
  String get voiceEntryDescription => 'تسجيل معاملات العملاء';

  @override
  String get loadingProducts => 'جاري تحميل المنتجات...';

  @override
  String get failedToLoadProducts => 'فشل في تحميل المنتجات';

  @override
  String get total => 'الإجمالي';

  @override
  String get active => 'نشط';

  @override
  String get inactive => 'غير نشط';

  @override
  String get searchProducts => 'ابحث بالاسم أو الفئة أو الباركود';

  @override
  String get all => 'الكل';

  @override
  String showingProducts(Object filtered, Object total) {
    return 'عرض $filtered من أصل $total منتج';
  }

  @override
  String get productNotFound => 'لم يتم العثور على المنتج';

  @override
  String get noProductsFound => 'لا توجد منتجات';

  @override
  String get barcode => 'الباركود';

  @override
  String get showing => 'عرض';

  @override
  String get outOf => 'من أصل';

  @override
  String get productsLabel => 'منتج';

  @override
  String get loadingCustomers => 'جاري تحميل العملاء...';

  @override
  String get failedToLoadCustomers => 'فشل في تحميل العملاء';

  @override
  String get searchCustomers => 'ابحث بالاسم أو رقم الهاتف';

  @override
  String get showingCustomers => 'عميل';

  @override
  String get noCustomersFound => 'لا يوجد عملاء';

  @override
  String get reportsCenter => 'مركز التقارير';

  @override
  String get customerAndFinancialReports => 'تقارير العملاء والتقارير المالية';

  @override
  String get customerSummary => 'ملخص العملاء';

  @override
  String get customerBalancesAndAccounts => 'أرصدة وحسابات العملاء';

  @override
  String get topDebtors => 'أعلى المديونين';

  @override
  String get customersWithHighestBalances => 'العملاء ذوو أعلى أرصدة';

  @override
  String get recentTransactions => 'أحدث المعاملات';

  @override
  String get latestPurchasesAndPayments => 'أحدث المشتريات والمدفوعات';
}
