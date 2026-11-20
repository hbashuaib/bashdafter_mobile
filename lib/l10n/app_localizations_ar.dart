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
  String get inventoryManagementDescription =>
      'إدارة عمليات المخزون وتقارير المخزون';

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
  String showingProducts(int filtered, int total) {
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

  @override
  String get failedToLoadCustomer => 'فشل في تحميل بيانات العميل';

  @override
  String get cannotDeactivate => 'لا يمكن تعطيل العميل';

  @override
  String get customerBalanceMustBeZero =>
      'يجب أن يكون رصيد العميل صفراً قبل التعطيل.';

  @override
  String get ok => 'موافق';

  @override
  String get deactivateCustomer => 'تعطيل العميل';

  @override
  String get deactivate => 'تعطيل';

  @override
  String get deactivateCustomerQuestion => 'هل تريد تعطيل العميل؟';

  @override
  String get customerDeactivatedSuccessfully => 'تم تعطيل العميل بنجاح';

  @override
  String get failedToDeactivateCustomer => 'فشل في تعطيل العميل';

  @override
  String get customerReactivatedSuccessfully => 'تمت إعادة تفعيل العميل بنجاح';

  @override
  String get failedToReactivateCustomer => 'فشل في إعادة تفعيل العميل';

  @override
  String get purchase => 'شراء';

  @override
  String get payment => 'دفعة';

  @override
  String get records => 'السجلات';

  @override
  String get statement => 'كشف الحساب';

  @override
  String get addCustomer => 'إضافة عميل';

  @override
  String get name => 'الاسم';

  @override
  String get phone => 'الهاتف';

  @override
  String get address => 'العنوان';

  @override
  String get notes => 'ملاحظات';

  @override
  String get saveCustomer => 'حفظ العميل';

  @override
  String get customerNameRequired => 'اسم العميل مطلوب';

  @override
  String get phoneNumberRequired => 'رقم الهاتف مطلوب';

  @override
  String get enterValidPhoneNumber => 'أدخل رقم هاتف صحيح';

  @override
  String get customerAddedSuccessfully => 'تمت إضافة العميل بنجاح';

  @override
  String get failedToSaveCustomer => 'فشل في حفظ العميل';

  @override
  String get editCustomer => 'تعديل العميل';

  @override
  String get activeStatus => 'نشط';

  @override
  String get saveChanges => 'حفظ التعديلات';

  @override
  String get customerUpdatedSuccessfully => 'تم تحديث العميل بنجاح';

  @override
  String get failedToUpdateCustomer => 'فشل في تحديث العميل';

  @override
  String get inactiveCustomers => 'العملاء المعطلون';

  @override
  String get failedToLoadInactiveCustomers => 'فشل في تحميل العملاء المعطلين';

  @override
  String get restoreCustomer => 'استعادة العميل';

  @override
  String get restore => 'استعادة';

  @override
  String get restoreCustomerQuestion => 'هل أنت متأكد من استعادة هذا العميل؟';

  @override
  String get customerRestoredSuccessfully => 'تمت استعادة العميل بنجاح';

  @override
  String get failedToRestoreCustomer => 'فشل في استعادة العميل';

  @override
  String get noInactiveCustomers => 'لا يوجد عملاء معطلون';

  @override
  String get customerStatement => 'كشف حساب العميل';

  @override
  String get loadingStatement => 'جاري تحميل كشف الحساب...';

  @override
  String get failedToLoadStatement => 'فشل في تحميل كشف الحساب';

  @override
  String get noStatementAvailable => 'لا يوجد كشف حساب متاح';

  @override
  String get transactions => 'المعاملات';

  @override
  String get searchTransactions => 'البحث في المعاملات';

  @override
  String get noTransactionsFound => 'لا توجد معاملات';

  @override
  String get currentBalance => 'الرصيد الحالي';

  @override
  String get phoneLabel => 'الهاتف';

  @override
  String get pdfGeneratedSuccessfully => 'تم إنشاء ملف PDF بنجاح';

  @override
  String get failedToGeneratePdf => 'فشل في إنشاء ملف PDF';

  @override
  String get generatedByBashDafter => 'تم الإنشاء بواسطة باش دفتر';

  @override
  String get purchaseType => 'شراء';

  @override
  String get paymentType => 'دفعة';

  @override
  String get runningBalance => 'الرصيد';

  @override
  String get loadingPurchases => 'جاري تحميل المشتريات...';

  @override
  String get failedToLoadPurchases => 'فشل في تحميل المشتريات';

  @override
  String get average => 'المتوسط';

  @override
  String get searchPurchases => 'البحث بالتاريخ أو الملاحظات أو المبلغ';

  @override
  String get showingPurchases => 'مشتريات';

  @override
  String get noPurchasesFound => 'لا توجد مشتريات';

  @override
  String get purchaseDetails => 'تفاصيل الشراء';

  @override
  String get purchaseDate => 'تاريخ الشراء';

  @override
  String get totalAmount => 'إجمالي المبلغ';

  @override
  String get noNotes => 'لا توجد ملاحظات';

  @override
  String get items => 'الأصناف';

  @override
  String get addPurchase => 'إضافة مشتريات';

  @override
  String get scanProductBarcode => 'مسح باركود المنتج';

  @override
  String get product => 'المنتج';

  @override
  String get quantity => 'الكمية';

  @override
  String get unitPrice => 'سعر الوحدة';

  @override
  String get lineTotal => 'إجمالي السطر';

  @override
  String get addItem => 'إضافة صنف';

  @override
  String get purchaseItems => 'أصناف المشتريات';

  @override
  String get purchaseTotal => 'إجمالي المشتريات';

  @override
  String get savePurchase => 'حفظ المشتريات';

  @override
  String get pleaseSelectProduct => 'الرجاء اختيار منتج';

  @override
  String get enterValidQuantity => 'أدخل كمية صحيحة';

  @override
  String get enterValidUnitPrice => 'أدخل سعر وحدة صحيح';

  @override
  String get productAlreadyAdded => 'تمت إضافة المنتج مسبقاً';

  @override
  String get availableInStock => 'متوفر في المخزون';

  @override
  String get addAtLeastOneItem => 'أضف صنفاً واحداً على الأقل';

  @override
  String get purchaseSavedSuccessfully => 'تم حفظ المشتريات بنجاح';

  @override
  String get failedToSavePurchase => 'فشل في حفظ المشتريات';

  @override
  String get noItemsAddedYet => 'لم تتم إضافة أي أصناف بعد';

  @override
  String get loadingPayments => 'جاري تحميل المدفوعات...';

  @override
  String get failedToLoadPayments => 'فشل في تحميل المدفوعات';

  @override
  String get searchPayments => 'البحث بالتاريخ أو الملاحظات أو المبلغ';

  @override
  String get showingPayments => 'مدفوعات';

  @override
  String get noPaymentsFound => 'لا توجد مدفوعات';

  @override
  String get paymentDetails => 'تفاصيل الدفعة';

  @override
  String get paymentReceipt => 'إيصال دفعة';

  @override
  String get paymentAmount => 'مبلغ الدفعة';

  @override
  String get paymentDate => 'تاريخ الدفعة';

  @override
  String get paymentId => 'رقم الدفعة';

  @override
  String get addPayment => 'إضافة دفعة';

  @override
  String get amount => 'المبلغ';

  @override
  String get paymentPreview => 'معاينة الدفعة';

  @override
  String get savePayment => 'حفظ الدفعة';

  @override
  String get paymentAmountRequired => 'مبلغ الدفعة مطلوب';

  @override
  String get enterValidAmount => 'أدخل مبلغاً صحيحاً';

  @override
  String get amountMustBeGreaterThanZero => 'يجب أن يكون المبلغ أكبر من صفر';

  @override
  String get paymentAddedSuccessfully => 'تمت إضافة الدفعة بنجاح';

  @override
  String get failedToSavePayment => 'فشل في حفظ الدفعة';

  @override
  String get inventoryFunctions => 'وظائف المخزون';

  @override
  String get inventoryDashboard => 'لوحة المخزون';

  @override
  String get inventoryDashboardDescription => 'إحصائيات وملخص المخزون';

  @override
  String get inventoryLookup => 'استعلام المخزون';

  @override
  String get inventoryLookupDescription => 'مسح الباركود والتحقق من المخزون';

  @override
  String get lowStockProducts => 'المنتجات منخفضة المخزون';

  @override
  String get lowStockProductsDescription =>
      'المنتجات التي تحتاج إلى إعادة تزويد';

  @override
  String get expiringProducts => 'المنتجات قاربة الانتهاء';

  @override
  String get expiringProductsDescription =>
      'المنتجات التي ستنتهي صلاحيتها قريباً';

  @override
  String get topSellingProducts => 'المنتجات الأكثر مبيعاً';

  @override
  String get topSellingProductsDescription => 'أفضل المنتجات أداءً';

  @override
  String get inventoryHistory => 'سجل المخزون';

  @override
  String get inventoryHistoryDescription => 'جميع حركات المخزون';

  @override
  String get stockAdjustments => 'تعديلات المخزون';

  @override
  String get stockAdjustmentsDescription => 'زيادة أو تقليل المخزون';

  @override
  String get failedToLoadInventoryDashboard => 'فشل في تحميل لوحة المخزون';

  @override
  String get noInventoryDataAvailable => 'لا توجد بيانات مخزون متاحة';

  @override
  String get lowStock => 'منخفض';

  @override
  String get expiring => 'منتهي قريباً';

  @override
  String get totalProducts => 'إجمالي المنتجات';

  @override
  String get inventoryTransactions => 'حركات المخزون';

  @override
  String get inventoryValue => 'قيمة المخزون';

  @override
  String get currentStockValue => 'القيمة الحالية للمخزون';

  @override
  String get scanProduct => 'مسح المنتج';

  @override
  String get searchingProduct => 'جاري البحث عن المنتج...';

  @override
  String get stock => 'المخزون';

  @override
  String get minimumStock => 'الحد الأدنى للمخزون';

  @override
  String get sellingPrice => 'سعر البيع';

  @override
  String get inStock => 'متوفر';

  @override
  String get lowStockStatus => 'مخزون منخفض';

  @override
  String get adjustStock => 'تعديل المخزون';

  @override
  String get stockUpdated => 'تم تحديث المخزون';

  @override
  String get currentStockLabel => 'المخزون الحالي';

  @override
  String get barcodeLabel => 'الباركود';

  @override
  String get stockAdjustment => 'تعديل المخزون';

  @override
  String get adjustmentType => 'نوع التعديل';

  @override
  String get reason => 'السبب';

  @override
  String get saveAdjustment => 'حفظ التعديل';

  @override
  String get reasonRequired => 'السبب مطلوب';

  @override
  String get stockAdjustmentSavedSuccessfully => 'تم حفظ تعديل المخزون بنجاح';

  @override
  String get failedToSaveStockAdjustment => 'فشل في حفظ تعديل المخزون';

  @override
  String get selectedFromBarcodeLookup => 'تم الاختيار من البحث بالباركود';

  @override
  String get currentStock => 'المخزون الحالي';

  @override
  String get openingStock => 'رصيد افتتاحي';

  @override
  String get stockIn => 'إضافة للمخزون';

  @override
  String get stockOut => 'سحب من المخزون';

  @override
  String get damagedStock => 'مخزون تالف';

  @override
  String get correction => 'تصحيح';

  @override
  String get loadingLowStockProducts => 'جاري تحميل المنتجات منخفضة المخزون...';

  @override
  String get failedToLoadLowStockProducts =>
      'فشل في تحميل المنتجات منخفضة المخزون';

  @override
  String get searchProduct => 'البحث عن منتج';

  @override
  String get noLowStockProducts => 'لا توجد منتجات منخفضة المخزون';

  @override
  String get current => 'الحالي';

  @override
  String get minimum => 'الحد الأدنى';

  @override
  String get unknownProduct => 'منتج غير معروف';

  @override
  String get loadingTopSellingProducts =>
      'جاري تحميل المنتجات الأكثر مبيعاً...';

  @override
  String get failedToLoadTopSellingProducts =>
      'فشل في تحميل المنتجات الأكثر مبيعاً';

  @override
  String get topSeller => 'الأكثر مبيعاً';

  @override
  String get noSalesFound => 'لا توجد مبيعات';

  @override
  String get sold => 'تم البيع';

  @override
  String get loadingInventoryHistory => 'جاري تحميل سجل المخزون...';

  @override
  String get failedToLoadInventoryHistory => 'فشل في تحميل سجل المخزون';

  @override
  String get searchInventoryHistory => 'البحث بالمنتج أو النوع أو المرجع';

  @override
  String get noInventoryTransactionsFound => 'لا توجد حركات مخزون';

  @override
  String get reference => 'المرجع';

  @override
  String get sale => 'بيع';

  @override
  String get transactionOpening => 'افتتاحي';

  @override
  String get transactionIn => 'إدخال';

  @override
  String get transactionOut => 'إخراج';

  @override
  String get transactionDamage => 'تالف';

  @override
  String get transactionCorrection => 'تصحيح';

  @override
  String get transactionSale => 'بيع';

  @override
  String get deactivateProduct => 'تعطيل المنتج';

  @override
  String get deactivateProductQuestion => 'هل أنت متأكد من تعطيل هذا المنتج؟';

  @override
  String get productDeactivatedSuccessfully => 'تم تعطيل المنتج بنجاح';

  @override
  String get failedToDeactivateProduct => 'فشل في تعطيل المنتج';

  @override
  String get category => 'الفئة';

  @override
  String get unit => 'الوحدة';

  @override
  String get description => 'الوصف';

  @override
  String get noDescription => 'لا يوجد وصف';

  @override
  String get costPrice => 'سعر التكلفة';

  @override
  String get totalSold => 'إجمالي المبيعات';

  @override
  String get hasExpiry => 'له تاريخ انتهاء';

  @override
  String get expiryDate => 'تاريخ الانتهاء';

  @override
  String get status => 'الحالة';

  @override
  String get yes => 'نعم';

  @override
  String get no => 'لا';

  @override
  String get expired => 'منتهي الصلاحية';

  @override
  String get daysRemaining => 'يوم متبقي';

  @override
  String get expiresIn => 'ينتهي خلال';

  @override
  String get currentStockBelowMinimum => 'المخزون الحالي أقل من الحد الأدنى';

  @override
  String get addProduct => 'إضافة منتج';

  @override
  String get productName => 'اسم المنتج';

  @override
  String get failedToLoadDropdownData => 'فشل في تحميل بيانات القوائم';

  @override
  String get pleaseSelectCategory => 'الرجاء اختيار فئة';

  @override
  String get pleaseSelectUnit => 'الرجاء اختيار وحدة';

  @override
  String get enterValidCostPrice => 'أدخل سعر تكلفة صحيح';

  @override
  String get enterValidSellingPrice => 'أدخل سعر بيع صحيح';

  @override
  String get enterValidMinimumStock => 'أدخل حدًا أدنى صحيحًا للمخزون';

  @override
  String get pleaseSelectExpiryDate => 'الرجاء اختيار تاريخ انتهاء';

  @override
  String get sellingPriceCannotBeLessThanCostPrice =>
      'لا يمكن أن يكون سعر البيع أقل من سعر التكلفة';

  @override
  String get productAddedSuccessfully => 'تمت إضافة المنتج بنجاح';

  @override
  String get failedToSaveProduct => 'فشل في حفظ المنتج';

  @override
  String get hasExpiryDate => 'له تاريخ انتهاء';

  @override
  String get selectExpiryDate => 'اختر تاريخ الانتهاء';

  @override
  String get saveProduct => 'حفظ المنتج';

  @override
  String get productNameRequired => 'اسم المنتج مطلوب';

  @override
  String get editProduct => 'تعديل المنتج';

  @override
  String get productUpdatedSuccessfully => 'تم تحديث المنتج بنجاح';

  @override
  String get failedToUpdateProduct => 'فشل في تحديث المنتج';

  @override
  String get addCategory => 'إضافة فئة';

  @override
  String get editCategory => 'تعديل فئة';

  @override
  String get categoryName => 'اسم الفئة';

  @override
  String get categoryAddedSuccessfully => 'تمت إضافة الفئة بنجاح';

  @override
  String get categoryUpdatedSuccessfully => 'تم تحديث الفئة بنجاح';

  @override
  String get categoryDeletedSuccessfully => 'تم حذف الفئة بنجاح';

  @override
  String get deleteCategory => 'حذف فئة';

  @override
  String get deleteCategoryQuestion => 'حذف الفئة؟';

  @override
  String get update => 'تحديث';

  @override
  String get noCategoriesFound => 'لا توجد فئات';

  @override
  String get unableToDeleteCategory => 'تعذر حذف الفئة';

  @override
  String get categories => 'الفئات';

  @override
  String get scanBarcode => 'مسح الباركود';

  @override
  String get units => 'الوحدات';

  @override
  String get addUnit => 'إضافة وحدة';

  @override
  String get editUnit => 'تعديل وحدة';

  @override
  String get unitName => 'اسم الوحدة';

  @override
  String get unitAddedSuccessfully => 'تمت إضافة الوحدة بنجاح';

  @override
  String get unitUpdatedSuccessfully => 'تم تحديث الوحدة بنجاح';

  @override
  String get unitDeletedSuccessfully => 'تم حذف الوحدة بنجاح';

  @override
  String get deleteUnit => 'حذف وحدة';

  @override
  String get deleteUnitQuestion => 'حذف الوحدة؟';

  @override
  String get noUnitsFound => 'لا توجد وحدات';

  @override
  String get unableToDeleteUnit => 'تعذر حذف الوحدة';

  @override
  String get noExpiringProducts => 'لا توجد منتجات قاربت على الانتهاء';

  @override
  String get days => 'يوم';

  @override
  String get inactiveProducts => 'المنتجات غير النشطة';

  @override
  String get failedToLoadInactiveProducts => 'فشل في تحميل المنتجات غير النشطة';

  @override
  String get restoreProduct => 'استعادة المنتج';

  @override
  String get restoreProductQuestion => 'هل أنت متأكد من استعادة هذا المنتج؟';

  @override
  String get productRestoredSuccessfully => 'تمت استعادة المنتج بنجاح';

  @override
  String get failedToRestoreProduct => 'فشل في استعادة المنتج';

  @override
  String get noInactiveProducts => 'لا توجد منتجات غير نشطة';

  @override
  String get noCategory => 'بدون فئة';

  @override
  String get failedToLoadProfile => 'فشل في تحميل الملف الشخصي';

  @override
  String get noProfileFound => 'لم يتم العثور على ملف شخصي';

  @override
  String get profileImageUpdated => 'تم تحديث صورة الملف الشخصي';

  @override
  String get failedToUploadImage => 'فشل في رفع الصورة';

  @override
  String get profileInformation => 'معلومات الملف الشخصي';

  @override
  String get profileInformationDescription => 'معلومات التطبيق والمستخدم';

  @override
  String get user => 'المستخدم';

  @override
  String get application => 'التطبيق';

  @override
  String get role => 'الدور';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get phoneNumber => 'رقم الهاتف';

  @override
  String get theme => 'المظهر';

  @override
  String get lightMode => 'الوضع الفاتح';

  @override
  String get version => 'الإصدار';

  @override
  String get company => 'الشركة';

  @override
  String get changePassword => 'تغيير كلمة المرور';

  @override
  String get updateYourAccountPassword => 'تحديث كلمة مرور الحساب';

  @override
  String get profileImageUploadUnsupported =>
      'رفع صورة الملف الشخصي متاح حالياً في إصدارات أندرويد وسطح المكتب فقط.';

  @override
  String get applicationName => 'باش دَفتر';

  @override
  String get companyName => 'باش سوفت ديجيتال';

  @override
  String get failedToLoadShopProfile => 'فشل في تحميل ملف المتجر';

  @override
  String get shopProfileUpdated => 'تم تحديث ملف المتجر';

  @override
  String get failedToUpdateShopProfile => 'فشل في تحديث ملف المتجر';

  @override
  String get noShopProfileFound => 'لم يتم العثور على ملف المتجر';

  @override
  String get shopName => 'اسم المتجر';

  @override
  String get shopNameRequired => 'اسم المتجر مطلوب';

  @override
  String get currency => 'العملة';

  @override
  String get currencyRequired => 'العملة مطلوبة';

  @override
  String get phoneRequired => 'رقم الهاتف مطلوب';

  @override
  String get city => 'المدينة';

  @override
  String get currentPassword => 'كلمة المرور الحالية';

  @override
  String get currentPasswordRequired => 'كلمة المرور الحالية مطلوبة';

  @override
  String get newPassword => 'كلمة المرور الجديدة';

  @override
  String get newPasswordRequired => 'كلمة المرور الجديدة مطلوبة';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور';

  @override
  String get confirmPasswordRequired => 'تأكيد كلمة المرور مطلوب';

  @override
  String get passwordsDoNotMatch => 'كلمتا المرور غير متطابقتين';

  @override
  String get passwordChangedSuccessfully => 'تم تغيير كلمة المرور بنجاح';

  @override
  String get failedToChangePassword => 'فشل في تغيير كلمة المرور';

  @override
  String get english => 'English';

  @override
  String get arabic => 'العربية';

  @override
  String get aboutDescription =>
      'يساعد باش دفتر الشركات على إدارة العملاء والمشتريات والمدفوعات والمخزون والتقارير.';

  @override
  String get businessAccountingAndInventoryManagementSystem =>
      'نظام محاسبة وإدارة مخزون للأعمال.';

  @override
  String get developedBy => 'تم التطوير بواسطة';

  @override
  String get loadingCustomerSummary => 'جاري تحميل ملخص العملاء...';

  @override
  String get failedToLoadCustomerSummary => 'فشل في تحميل ملخص العملاء';

  @override
  String get outstanding => 'المستحق';

  @override
  String get searchCustomer => 'البحث عن عميل';

  @override
  String get unknownCustomer => 'عميل غير معروف';

  @override
  String get loadingRecentTransactions => 'جاري تحميل أحدث المعاملات...';

  @override
  String get failedToLoadTransactions => 'فشل في تحميل المعاملات';

  @override
  String get loadingTopDebtors => 'جاري تحميل أكبر المدينين...';

  @override
  String get failedToLoadTopDebtors => 'فشل في تحميل أكبر المدينين';

  @override
  String get debtors => 'المدينون';

  @override
  String get highestDebt => 'أعلى دين';

  @override
  String get searchDebtor => 'البحث عن مدين';

  @override
  String get noDebtorsFound => 'لا يوجد مدينون';
}
