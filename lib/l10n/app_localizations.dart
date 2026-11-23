import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'BashDafter'**
  String get appName;

  /// No description provided for @products.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get products;

  /// No description provided for @customers.
  ///
  /// In en, this message translates to:
  /// **'Customers'**
  String get customers;

  /// No description provided for @payments.
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get payments;

  /// No description provided for @purchases.
  ///
  /// In en, this message translates to:
  /// **'Purchases'**
  String get purchases;

  /// No description provided for @reports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reports;

  /// No description provided for @inventory.
  ///
  /// In en, this message translates to:
  /// **'Inventory'**
  String get inventory;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @noDataFound.
  ///
  /// In en, this message translates to:
  /// **'No data found'**
  String get noDataFound;

  /// No description provided for @profileNotFound.
  ///
  /// In en, this message translates to:
  /// **'Profile not found'**
  String get profileNotFound;

  /// No description provided for @userManagement.
  ///
  /// In en, this message translates to:
  /// **'User Management'**
  String get userManagement;

  /// No description provided for @manageSystemUsers.
  ///
  /// In en, this message translates to:
  /// **'Manage system users'**
  String get manageSystemUsers;

  /// No description provided for @productCategories.
  ///
  /// In en, this message translates to:
  /// **'Product Categories'**
  String get productCategories;

  /// No description provided for @manageProductCategories.
  ///
  /// In en, this message translates to:
  /// **'Manage product categories'**
  String get manageProductCategories;

  /// No description provided for @productUnits.
  ///
  /// In en, this message translates to:
  /// **'Product Units'**
  String get productUnits;

  /// No description provided for @manageProductUnits.
  ///
  /// In en, this message translates to:
  /// **'Manage product units'**
  String get manageProductUnits;

  /// No description provided for @manageApplicationPreferences.
  ///
  /// In en, this message translates to:
  /// **'Manage application preferences and information'**
  String get manageApplicationPreferences;

  /// No description provided for @shopProfile.
  ///
  /// In en, this message translates to:
  /// **'Shop Profile'**
  String get shopProfile;

  /// No description provided for @manageShopInformation.
  ///
  /// In en, this message translates to:
  /// **'Manage shop information'**
  String get manageShopInformation;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @userAndApplicationDetails.
  ///
  /// In en, this message translates to:
  /// **'User and application details'**
  String get userAndApplicationDetails;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @changeApplicationLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change application language'**
  String get changeApplicationLanguage;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @darkModeEnabled.
  ///
  /// In en, this message translates to:
  /// **'Dark mode enabled'**
  String get darkModeEnabled;

  /// No description provided for @lightModeEnabled.
  ///
  /// In en, this message translates to:
  /// **'Light mode enabled'**
  String get lightModeEnabled;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @applicationInformation.
  ///
  /// In en, this message translates to:
  /// **'Application information'**
  String get applicationInformation;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out of the application'**
  String get signOut;

  /// No description provided for @areYouSureLogout.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get areYouSureLogout;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// No description provided for @signInToContinue.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue'**
  String get signInToContinue;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @usernameRequired.
  ///
  /// In en, this message translates to:
  /// **'Username is required'**
  String get usernameRequired;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordRequired;

  /// No description provided for @invalidUsernameOrPassword.
  ///
  /// In en, this message translates to:
  /// **'Invalid username or password'**
  String get invalidUsernameOrPassword;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @failedToLoadDashboard.
  ///
  /// In en, this message translates to:
  /// **'Failed to load dashboard'**
  String get failedToLoadDashboard;

  /// No description provided for @noDashboardDataAvailable.
  ///
  /// In en, this message translates to:
  /// **'No dashboard data available'**
  String get noDashboardDataAvailable;

  /// No description provided for @businessDashboard.
  ///
  /// In en, this message translates to:
  /// **'Business Dashboard'**
  String get businessDashboard;

  /// No description provided for @businessDashboardDescription.
  ///
  /// In en, this message translates to:
  /// **'Monitor customers, purchases, payments and inventory'**
  String get businessDashboardDescription;

  /// No description provided for @customersCount.
  ///
  /// In en, this message translates to:
  /// **'Customers'**
  String get customersCount;

  /// No description provided for @balance.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get balance;

  /// No description provided for @businessOverview.
  ///
  /// In en, this message translates to:
  /// **'Business Overview'**
  String get businessOverview;

  /// No description provided for @totalPurchases.
  ///
  /// In en, this message translates to:
  /// **'Total Purchases'**
  String get totalPurchases;

  /// No description provided for @totalPayments.
  ///
  /// In en, this message translates to:
  /// **'Total Payments'**
  String get totalPayments;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @inventoryManagement.
  ///
  /// In en, this message translates to:
  /// **'Inventory Management'**
  String get inventoryManagement;

  /// No description provided for @inventoryManagementDescription.
  ///
  /// In en, this message translates to:
  /// **'Manage stock operations and inventory reports'**
  String get inventoryManagementDescription;

  /// No description provided for @voiceEntry.
  ///
  /// In en, this message translates to:
  /// **'Voice Entry'**
  String get voiceEntry;

  /// No description provided for @voiceEntryDescription.
  ///
  /// In en, this message translates to:
  /// **'Record customer transactions'**
  String get voiceEntryDescription;

  /// No description provided for @loadingProducts.
  ///
  /// In en, this message translates to:
  /// **'Loading products...'**
  String get loadingProducts;

  /// No description provided for @failedToLoadProducts.
  ///
  /// In en, this message translates to:
  /// **'Failed to load products'**
  String get failedToLoadProducts;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @inactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get inactive;

  /// No description provided for @searchProducts.
  ///
  /// In en, this message translates to:
  /// **'Search by name, category, or barcode'**
  String get searchProducts;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// Shows filtered products count
  ///
  /// In en, this message translates to:
  /// **'Showing {filtered} of {total} products'**
  String showingProducts(int filtered, int total);

  /// No description provided for @productNotFound.
  ///
  /// In en, this message translates to:
  /// **'Product not found'**
  String get productNotFound;

  /// No description provided for @noProductsFound.
  ///
  /// In en, this message translates to:
  /// **'No products found'**
  String get noProductsFound;

  /// No description provided for @barcode.
  ///
  /// In en, this message translates to:
  /// **'Barcode'**
  String get barcode;

  /// No description provided for @showing.
  ///
  /// In en, this message translates to:
  /// **'Showing'**
  String get showing;

  /// No description provided for @outOf.
  ///
  /// In en, this message translates to:
  /// **'of'**
  String get outOf;

  /// No description provided for @productsLabel.
  ///
  /// In en, this message translates to:
  /// **'products'**
  String get productsLabel;

  /// No description provided for @loadingCustomers.
  ///
  /// In en, this message translates to:
  /// **'Loading customers...'**
  String get loadingCustomers;

  /// No description provided for @failedToLoadCustomers.
  ///
  /// In en, this message translates to:
  /// **'Failed to load customers'**
  String get failedToLoadCustomers;

  /// No description provided for @searchCustomers.
  ///
  /// In en, this message translates to:
  /// **'Search by name or phone'**
  String get searchCustomers;

  /// No description provided for @showingCustomers.
  ///
  /// In en, this message translates to:
  /// **'customers'**
  String get showingCustomers;

  /// No description provided for @noCustomersFound.
  ///
  /// In en, this message translates to:
  /// **'No customers found'**
  String get noCustomersFound;

  /// No description provided for @reportsCenter.
  ///
  /// In en, this message translates to:
  /// **'Reports Center'**
  String get reportsCenter;

  /// No description provided for @customerAndFinancialReports.
  ///
  /// In en, this message translates to:
  /// **'Customer and financial reports'**
  String get customerAndFinancialReports;

  /// No description provided for @customerSummary.
  ///
  /// In en, this message translates to:
  /// **'Customer Summary'**
  String get customerSummary;

  /// No description provided for @customerBalancesAndAccounts.
  ///
  /// In en, this message translates to:
  /// **'Customer balances and accounts'**
  String get customerBalancesAndAccounts;

  /// No description provided for @topDebtors.
  ///
  /// In en, this message translates to:
  /// **'Top Debtors'**
  String get topDebtors;

  /// No description provided for @customersWithHighestBalances.
  ///
  /// In en, this message translates to:
  /// **'Customers with highest balances'**
  String get customersWithHighestBalances;

  /// No description provided for @recentTransactions.
  ///
  /// In en, this message translates to:
  /// **'Recent Transactions'**
  String get recentTransactions;

  /// No description provided for @latestPurchasesAndPayments.
  ///
  /// In en, this message translates to:
  /// **'Latest purchases and payments'**
  String get latestPurchasesAndPayments;

  /// No description provided for @failedToLoadCustomer.
  ///
  /// In en, this message translates to:
  /// **'Failed to load customer'**
  String get failedToLoadCustomer;

  /// No description provided for @cannotDeactivate.
  ///
  /// In en, this message translates to:
  /// **'Cannot Deactivate'**
  String get cannotDeactivate;

  /// No description provided for @customerBalanceMustBeZero.
  ///
  /// In en, this message translates to:
  /// **'Customer balance must be zero before deactivation.'**
  String get customerBalanceMustBeZero;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @deactivateCustomer.
  ///
  /// In en, this message translates to:
  /// **'Deactivate Customer'**
  String get deactivateCustomer;

  /// No description provided for @deactivate.
  ///
  /// In en, this message translates to:
  /// **'Deactivate'**
  String get deactivate;

  /// No description provided for @deactivateCustomerQuestion.
  ///
  /// In en, this message translates to:
  /// **'Deactivate customer?'**
  String get deactivateCustomerQuestion;

  /// No description provided for @customerDeactivatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Customer deactivated successfully'**
  String get customerDeactivatedSuccessfully;

  /// No description provided for @failedToDeactivateCustomer.
  ///
  /// In en, this message translates to:
  /// **'Failed to deactivate customer'**
  String get failedToDeactivateCustomer;

  /// No description provided for @customerReactivatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Customer reactivated successfully'**
  String get customerReactivatedSuccessfully;

  /// No description provided for @failedToReactivateCustomer.
  ///
  /// In en, this message translates to:
  /// **'Failed to reactivate customer'**
  String get failedToReactivateCustomer;

  /// No description provided for @purchase.
  ///
  /// In en, this message translates to:
  /// **'Purchase'**
  String get purchase;

  /// No description provided for @payment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get payment;

  /// No description provided for @records.
  ///
  /// In en, this message translates to:
  /// **'Records'**
  String get records;

  /// No description provided for @statement.
  ///
  /// In en, this message translates to:
  /// **'Statement'**
  String get statement;

  /// No description provided for @addCustomer.
  ///
  /// In en, this message translates to:
  /// **'Add Customer'**
  String get addCustomer;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @saveCustomer.
  ///
  /// In en, this message translates to:
  /// **'Save Customer'**
  String get saveCustomer;

  /// No description provided for @customerNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Customer name is required'**
  String get customerNameRequired;

  /// No description provided for @phoneNumberRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone number is required'**
  String get phoneNumberRequired;

  /// No description provided for @enterValidPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid phone number'**
  String get enterValidPhoneNumber;

  /// No description provided for @customerAddedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Customer added successfully'**
  String get customerAddedSuccessfully;

  /// No description provided for @failedToSaveCustomer.
  ///
  /// In en, this message translates to:
  /// **'Failed to save customer'**
  String get failedToSaveCustomer;

  /// No description provided for @editCustomer.
  ///
  /// In en, this message translates to:
  /// **'Edit Customer'**
  String get editCustomer;

  /// No description provided for @activeStatus.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get activeStatus;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @customerUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Customer updated successfully'**
  String get customerUpdatedSuccessfully;

  /// No description provided for @failedToUpdateCustomer.
  ///
  /// In en, this message translates to:
  /// **'Failed to update customer'**
  String get failedToUpdateCustomer;

  /// No description provided for @inactiveCustomers.
  ///
  /// In en, this message translates to:
  /// **'Inactive Customers'**
  String get inactiveCustomers;

  /// No description provided for @failedToLoadInactiveCustomers.
  ///
  /// In en, this message translates to:
  /// **'Failed to load inactive customers'**
  String get failedToLoadInactiveCustomers;

  /// No description provided for @restoreCustomer.
  ///
  /// In en, this message translates to:
  /// **'Restore Customer'**
  String get restoreCustomer;

  /// No description provided for @restore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get restore;

  /// No description provided for @restoreCustomerQuestion.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to restore this customer?'**
  String get restoreCustomerQuestion;

  /// No description provided for @customerRestoredSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Customer restored successfully'**
  String get customerRestoredSuccessfully;

  /// No description provided for @failedToRestoreCustomer.
  ///
  /// In en, this message translates to:
  /// **'Failed to restore customer'**
  String get failedToRestoreCustomer;

  /// No description provided for @noInactiveCustomers.
  ///
  /// In en, this message translates to:
  /// **'No inactive customers'**
  String get noInactiveCustomers;

  /// No description provided for @customerStatement.
  ///
  /// In en, this message translates to:
  /// **'Customer Statement'**
  String get customerStatement;

  /// No description provided for @loadingStatement.
  ///
  /// In en, this message translates to:
  /// **'Loading statement...'**
  String get loadingStatement;

  /// No description provided for @failedToLoadStatement.
  ///
  /// In en, this message translates to:
  /// **'Failed to load statement'**
  String get failedToLoadStatement;

  /// No description provided for @noStatementAvailable.
  ///
  /// In en, this message translates to:
  /// **'No statement available'**
  String get noStatementAvailable;

  /// No description provided for @transactions.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get transactions;

  /// No description provided for @searchTransactions.
  ///
  /// In en, this message translates to:
  /// **'Search transactions'**
  String get searchTransactions;

  /// No description provided for @noTransactionsFound.
  ///
  /// In en, this message translates to:
  /// **'No transactions found'**
  String get noTransactionsFound;

  /// No description provided for @currentBalance.
  ///
  /// In en, this message translates to:
  /// **'Current Balance'**
  String get currentBalance;

  /// No description provided for @phoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phoneLabel;

  /// No description provided for @pdfGeneratedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'PDF generated successfully'**
  String get pdfGeneratedSuccessfully;

  /// No description provided for @failedToGeneratePdf.
  ///
  /// In en, this message translates to:
  /// **'Failed to generate PDF'**
  String get failedToGeneratePdf;

  /// No description provided for @generatedByBashDafter.
  ///
  /// In en, this message translates to:
  /// **'Generated by BashDafter'**
  String get generatedByBashDafter;

  /// No description provided for @purchaseType.
  ///
  /// In en, this message translates to:
  /// **'PURCHASE'**
  String get purchaseType;

  /// No description provided for @paymentType.
  ///
  /// In en, this message translates to:
  /// **'PAYMENT'**
  String get paymentType;

  /// No description provided for @runningBalance.
  ///
  /// In en, this message translates to:
  /// **'Bal'**
  String get runningBalance;

  /// No description provided for @loadingPurchases.
  ///
  /// In en, this message translates to:
  /// **'Loading purchases...'**
  String get loadingPurchases;

  /// No description provided for @failedToLoadPurchases.
  ///
  /// In en, this message translates to:
  /// **'Failed to load purchases'**
  String get failedToLoadPurchases;

  /// No description provided for @average.
  ///
  /// In en, this message translates to:
  /// **'Average'**
  String get average;

  /// No description provided for @searchPurchases.
  ///
  /// In en, this message translates to:
  /// **'Search by date, notes or amount'**
  String get searchPurchases;

  /// No description provided for @showingPurchases.
  ///
  /// In en, this message translates to:
  /// **'purchases'**
  String get showingPurchases;

  /// No description provided for @noPurchasesFound.
  ///
  /// In en, this message translates to:
  /// **'No purchases found'**
  String get noPurchasesFound;

  /// No description provided for @purchaseDetails.
  ///
  /// In en, this message translates to:
  /// **'Purchase Details'**
  String get purchaseDetails;

  /// No description provided for @purchaseDate.
  ///
  /// In en, this message translates to:
  /// **'Purchase Date'**
  String get purchaseDate;

  /// No description provided for @totalAmount.
  ///
  /// In en, this message translates to:
  /// **'Total Amount'**
  String get totalAmount;

  /// No description provided for @noNotes.
  ///
  /// In en, this message translates to:
  /// **'No notes'**
  String get noNotes;

  /// No description provided for @items.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get items;

  /// No description provided for @addPurchase.
  ///
  /// In en, this message translates to:
  /// **'Add Purchase'**
  String get addPurchase;

  /// No description provided for @scanProductBarcode.
  ///
  /// In en, this message translates to:
  /// **'Scan Product Barcode'**
  String get scanProductBarcode;

  /// No description provided for @product.
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get product;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// No description provided for @unitPrice.
  ///
  /// In en, this message translates to:
  /// **'Unit Price'**
  String get unitPrice;

  /// No description provided for @lineTotal.
  ///
  /// In en, this message translates to:
  /// **'Line Total'**
  String get lineTotal;

  /// No description provided for @addItem.
  ///
  /// In en, this message translates to:
  /// **'Add Item'**
  String get addItem;

  /// No description provided for @purchaseItems.
  ///
  /// In en, this message translates to:
  /// **'Purchase Items'**
  String get purchaseItems;

  /// No description provided for @purchaseTotal.
  ///
  /// In en, this message translates to:
  /// **'Purchase Total'**
  String get purchaseTotal;

  /// No description provided for @savePurchase.
  ///
  /// In en, this message translates to:
  /// **'Save Purchase'**
  String get savePurchase;

  /// No description provided for @pleaseSelectProduct.
  ///
  /// In en, this message translates to:
  /// **'Please select a product'**
  String get pleaseSelectProduct;

  /// No description provided for @enterValidQuantity.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid quantity'**
  String get enterValidQuantity;

  /// No description provided for @enterValidUnitPrice.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid unit price'**
  String get enterValidUnitPrice;

  /// No description provided for @productAlreadyAdded.
  ///
  /// In en, this message translates to:
  /// **'Product already added'**
  String get productAlreadyAdded;

  /// No description provided for @availableInStock.
  ///
  /// In en, this message translates to:
  /// **'available in stock'**
  String get availableInStock;

  /// No description provided for @addAtLeastOneItem.
  ///
  /// In en, this message translates to:
  /// **'Add at least one item'**
  String get addAtLeastOneItem;

  /// No description provided for @purchaseSavedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Purchase saved successfully'**
  String get purchaseSavedSuccessfully;

  /// No description provided for @failedToSavePurchase.
  ///
  /// In en, this message translates to:
  /// **'Failed to save purchase'**
  String get failedToSavePurchase;

  /// No description provided for @noItemsAddedYet.
  ///
  /// In en, this message translates to:
  /// **'No items added yet'**
  String get noItemsAddedYet;

  /// No description provided for @loadingPayments.
  ///
  /// In en, this message translates to:
  /// **'Loading payments...'**
  String get loadingPayments;

  /// No description provided for @failedToLoadPayments.
  ///
  /// In en, this message translates to:
  /// **'Failed to load payments'**
  String get failedToLoadPayments;

  /// No description provided for @searchPayments.
  ///
  /// In en, this message translates to:
  /// **'Search by date, notes or amount'**
  String get searchPayments;

  /// No description provided for @showingPayments.
  ///
  /// In en, this message translates to:
  /// **'payments'**
  String get showingPayments;

  /// No description provided for @noPaymentsFound.
  ///
  /// In en, this message translates to:
  /// **'No payments found'**
  String get noPaymentsFound;

  /// No description provided for @paymentDetails.
  ///
  /// In en, this message translates to:
  /// **'Payment Details'**
  String get paymentDetails;

  /// No description provided for @paymentReceipt.
  ///
  /// In en, this message translates to:
  /// **'PAYMENT RECEIPT'**
  String get paymentReceipt;

  /// No description provided for @paymentAmount.
  ///
  /// In en, this message translates to:
  /// **'Payment Amount'**
  String get paymentAmount;

  /// No description provided for @paymentDate.
  ///
  /// In en, this message translates to:
  /// **'Payment Date'**
  String get paymentDate;

  /// No description provided for @paymentId.
  ///
  /// In en, this message translates to:
  /// **'Payment ID'**
  String get paymentId;

  /// No description provided for @addPayment.
  ///
  /// In en, this message translates to:
  /// **'Add Payment'**
  String get addPayment;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @paymentPreview.
  ///
  /// In en, this message translates to:
  /// **'Payment Preview'**
  String get paymentPreview;

  /// No description provided for @savePayment.
  ///
  /// In en, this message translates to:
  /// **'Save Payment'**
  String get savePayment;

  /// No description provided for @paymentAmountRequired.
  ///
  /// In en, this message translates to:
  /// **'Payment amount is required'**
  String get paymentAmountRequired;

  /// No description provided for @enterValidAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid amount'**
  String get enterValidAmount;

  /// No description provided for @amountMustBeGreaterThanZero.
  ///
  /// In en, this message translates to:
  /// **'Amount must be greater than zero'**
  String get amountMustBeGreaterThanZero;

  /// No description provided for @paymentAddedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Payment added successfully'**
  String get paymentAddedSuccessfully;

  /// No description provided for @failedToSavePayment.
  ///
  /// In en, this message translates to:
  /// **'Failed to save payment'**
  String get failedToSavePayment;

  /// No description provided for @inventoryFunctions.
  ///
  /// In en, this message translates to:
  /// **'Inventory Functions'**
  String get inventoryFunctions;

  /// No description provided for @inventoryDashboard.
  ///
  /// In en, this message translates to:
  /// **'Inventory Dashboard'**
  String get inventoryDashboard;

  /// No description provided for @inventoryDashboardDescription.
  ///
  /// In en, this message translates to:
  /// **'Inventory statistics and summary'**
  String get inventoryDashboardDescription;

  /// No description provided for @inventoryLookup.
  ///
  /// In en, this message translates to:
  /// **'Inventory Lookup'**
  String get inventoryLookup;

  /// No description provided for @inventoryLookupDescription.
  ///
  /// In en, this message translates to:
  /// **'Scan barcode and check stock'**
  String get inventoryLookupDescription;

  /// No description provided for @lowStockProducts.
  ///
  /// In en, this message translates to:
  /// **'Low Stock Products'**
  String get lowStockProducts;

  /// No description provided for @lowStockProductsDescription.
  ///
  /// In en, this message translates to:
  /// **'Products requiring replenishment'**
  String get lowStockProductsDescription;

  /// No description provided for @expiringProducts.
  ///
  /// In en, this message translates to:
  /// **'Expiring Products'**
  String get expiringProducts;

  /// No description provided for @expiringProductsDescription.
  ///
  /// In en, this message translates to:
  /// **'Products expiring soon'**
  String get expiringProductsDescription;

  /// No description provided for @topSellingProducts.
  ///
  /// In en, this message translates to:
  /// **'Top Selling Products'**
  String get topSellingProducts;

  /// No description provided for @topSellingProductsDescription.
  ///
  /// In en, this message translates to:
  /// **'Best performing products'**
  String get topSellingProductsDescription;

  /// No description provided for @inventoryHistory.
  ///
  /// In en, this message translates to:
  /// **'Inventory History'**
  String get inventoryHistory;

  /// No description provided for @inventoryHistoryDescription.
  ///
  /// In en, this message translates to:
  /// **'All inventory transactions'**
  String get inventoryHistoryDescription;

  /// No description provided for @stockAdjustments.
  ///
  /// In en, this message translates to:
  /// **'Stock Adjustments'**
  String get stockAdjustments;

  /// No description provided for @stockAdjustmentsDescription.
  ///
  /// In en, this message translates to:
  /// **'Increase or decrease stock'**
  String get stockAdjustmentsDescription;

  /// No description provided for @failedToLoadInventoryDashboard.
  ///
  /// In en, this message translates to:
  /// **'Failed to load inventory dashboard'**
  String get failedToLoadInventoryDashboard;

  /// No description provided for @noInventoryDataAvailable.
  ///
  /// In en, this message translates to:
  /// **'No inventory data available'**
  String get noInventoryDataAvailable;

  /// No description provided for @lowStock.
  ///
  /// In en, this message translates to:
  /// **'Low Stock'**
  String get lowStock;

  /// No description provided for @expiring.
  ///
  /// In en, this message translates to:
  /// **'Expiring'**
  String get expiring;

  /// No description provided for @totalProducts.
  ///
  /// In en, this message translates to:
  /// **'Total Products'**
  String get totalProducts;

  /// No description provided for @inventoryTransactions.
  ///
  /// In en, this message translates to:
  /// **'Inventory Transactions'**
  String get inventoryTransactions;

  /// No description provided for @inventoryValue.
  ///
  /// In en, this message translates to:
  /// **'Inventory Value'**
  String get inventoryValue;

  /// No description provided for @currentStockValue.
  ///
  /// In en, this message translates to:
  /// **'Current stock value'**
  String get currentStockValue;

  /// No description provided for @scanProduct.
  ///
  /// In en, this message translates to:
  /// **'Scan Product'**
  String get scanProduct;

  /// No description provided for @searchingProduct.
  ///
  /// In en, this message translates to:
  /// **'Searching product...'**
  String get searchingProduct;

  /// No description provided for @stock.
  ///
  /// In en, this message translates to:
  /// **'Stock'**
  String get stock;

  /// No description provided for @minimumStock.
  ///
  /// In en, this message translates to:
  /// **'Minimum Stock'**
  String get minimumStock;

  /// No description provided for @sellingPrice.
  ///
  /// In en, this message translates to:
  /// **'Selling Price'**
  String get sellingPrice;

  /// No description provided for @inStock.
  ///
  /// In en, this message translates to:
  /// **'IN STOCK'**
  String get inStock;

  /// No description provided for @lowStockStatus.
  ///
  /// In en, this message translates to:
  /// **'LOW STOCK'**
  String get lowStockStatus;

  /// No description provided for @adjustStock.
  ///
  /// In en, this message translates to:
  /// **'Adjust Stock'**
  String get adjustStock;

  /// No description provided for @stockUpdated.
  ///
  /// In en, this message translates to:
  /// **'Stock updated'**
  String get stockUpdated;

  /// No description provided for @currentStockLabel.
  ///
  /// In en, this message translates to:
  /// **'Current stock'**
  String get currentStockLabel;

  /// No description provided for @barcodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Barcode'**
  String get barcodeLabel;

  /// No description provided for @stockAdjustment.
  ///
  /// In en, this message translates to:
  /// **'Stock Adjustment'**
  String get stockAdjustment;

  /// No description provided for @adjustmentType.
  ///
  /// In en, this message translates to:
  /// **'Adjustment Type'**
  String get adjustmentType;

  /// No description provided for @reason.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get reason;

  /// No description provided for @saveAdjustment.
  ///
  /// In en, this message translates to:
  /// **'Save Adjustment'**
  String get saveAdjustment;

  /// No description provided for @reasonRequired.
  ///
  /// In en, this message translates to:
  /// **'Reason is required'**
  String get reasonRequired;

  /// No description provided for @stockAdjustmentSavedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Stock adjustment saved successfully'**
  String get stockAdjustmentSavedSuccessfully;

  /// No description provided for @failedToSaveStockAdjustment.
  ///
  /// In en, this message translates to:
  /// **'Failed to save stock adjustment'**
  String get failedToSaveStockAdjustment;

  /// No description provided for @selectedFromBarcodeLookup.
  ///
  /// In en, this message translates to:
  /// **'Selected from barcode lookup'**
  String get selectedFromBarcodeLookup;

  /// No description provided for @currentStock.
  ///
  /// In en, this message translates to:
  /// **'Current Stock'**
  String get currentStock;

  /// No description provided for @openingStock.
  ///
  /// In en, this message translates to:
  /// **'Opening Stock'**
  String get openingStock;

  /// No description provided for @stockIn.
  ///
  /// In en, this message translates to:
  /// **'Stock In'**
  String get stockIn;

  /// No description provided for @stockOut.
  ///
  /// In en, this message translates to:
  /// **'Stock Out'**
  String get stockOut;

  /// No description provided for @damagedStock.
  ///
  /// In en, this message translates to:
  /// **'Damaged Stock'**
  String get damagedStock;

  /// No description provided for @correction.
  ///
  /// In en, this message translates to:
  /// **'Correction'**
  String get correction;

  /// No description provided for @loadingLowStockProducts.
  ///
  /// In en, this message translates to:
  /// **'Loading low stock products...'**
  String get loadingLowStockProducts;

  /// No description provided for @failedToLoadLowStockProducts.
  ///
  /// In en, this message translates to:
  /// **'Failed to load low stock products'**
  String get failedToLoadLowStockProducts;

  /// No description provided for @searchProduct.
  ///
  /// In en, this message translates to:
  /// **'Search product'**
  String get searchProduct;

  /// No description provided for @noLowStockProducts.
  ///
  /// In en, this message translates to:
  /// **'No low stock products'**
  String get noLowStockProducts;

  /// No description provided for @current.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get current;

  /// No description provided for @minimum.
  ///
  /// In en, this message translates to:
  /// **'Minimum'**
  String get minimum;

  /// No description provided for @unknownProduct.
  ///
  /// In en, this message translates to:
  /// **'Unknown Product'**
  String get unknownProduct;

  /// No description provided for @loadingTopSellingProducts.
  ///
  /// In en, this message translates to:
  /// **'Loading top selling products...'**
  String get loadingTopSellingProducts;

  /// No description provided for @failedToLoadTopSellingProducts.
  ///
  /// In en, this message translates to:
  /// **'Failed to load top selling products'**
  String get failedToLoadTopSellingProducts;

  /// No description provided for @topSeller.
  ///
  /// In en, this message translates to:
  /// **'Top Seller'**
  String get topSeller;

  /// No description provided for @noSalesFound.
  ///
  /// In en, this message translates to:
  /// **'No sales found'**
  String get noSalesFound;

  /// No description provided for @sold.
  ///
  /// In en, this message translates to:
  /// **'Sold'**
  String get sold;

  /// No description provided for @loadingInventoryHistory.
  ///
  /// In en, this message translates to:
  /// **'Loading inventory history...'**
  String get loadingInventoryHistory;

  /// No description provided for @failedToLoadInventoryHistory.
  ///
  /// In en, this message translates to:
  /// **'Failed to load inventory history'**
  String get failedToLoadInventoryHistory;

  /// No description provided for @searchInventoryHistory.
  ///
  /// In en, this message translates to:
  /// **'Search product, type or reference'**
  String get searchInventoryHistory;

  /// No description provided for @noInventoryTransactionsFound.
  ///
  /// In en, this message translates to:
  /// **'No inventory transactions found'**
  String get noInventoryTransactionsFound;

  /// No description provided for @reference.
  ///
  /// In en, this message translates to:
  /// **'Reference'**
  String get reference;

  /// No description provided for @sale.
  ///
  /// In en, this message translates to:
  /// **'Sale'**
  String get sale;

  /// No description provided for @transactionOpening.
  ///
  /// In en, this message translates to:
  /// **'Opening'**
  String get transactionOpening;

  /// No description provided for @transactionIn.
  ///
  /// In en, this message translates to:
  /// **'Stock In'**
  String get transactionIn;

  /// No description provided for @transactionOut.
  ///
  /// In en, this message translates to:
  /// **'Stock Out'**
  String get transactionOut;

  /// No description provided for @transactionDamage.
  ///
  /// In en, this message translates to:
  /// **'Damaged'**
  String get transactionDamage;

  /// No description provided for @transactionCorrection.
  ///
  /// In en, this message translates to:
  /// **'Correction'**
  String get transactionCorrection;

  /// No description provided for @transactionSale.
  ///
  /// In en, this message translates to:
  /// **'Sale'**
  String get transactionSale;

  /// No description provided for @deactivateProduct.
  ///
  /// In en, this message translates to:
  /// **'Deactivate Product'**
  String get deactivateProduct;

  /// No description provided for @deactivateProductQuestion.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to deactivate this product?'**
  String get deactivateProductQuestion;

  /// No description provided for @productDeactivatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Product deactivated successfully'**
  String get productDeactivatedSuccessfully;

  /// No description provided for @failedToDeactivateProduct.
  ///
  /// In en, this message translates to:
  /// **'Failed to deactivate product'**
  String get failedToDeactivateProduct;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @unit.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get unit;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @noDescription.
  ///
  /// In en, this message translates to:
  /// **'No description'**
  String get noDescription;

  /// No description provided for @costPrice.
  ///
  /// In en, this message translates to:
  /// **'Cost Price'**
  String get costPrice;

  /// No description provided for @totalSold.
  ///
  /// In en, this message translates to:
  /// **'Total Sold'**
  String get totalSold;

  /// No description provided for @hasExpiry.
  ///
  /// In en, this message translates to:
  /// **'Has Expiry'**
  String get hasExpiry;

  /// No description provided for @expiryDate.
  ///
  /// In en, this message translates to:
  /// **'Expiry Date'**
  String get expiryDate;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @expired.
  ///
  /// In en, this message translates to:
  /// **'EXPIRED'**
  String get expired;

  /// No description provided for @daysRemaining.
  ///
  /// In en, this message translates to:
  /// **'days remaining'**
  String get daysRemaining;

  /// No description provided for @expiresIn.
  ///
  /// In en, this message translates to:
  /// **'Expires in'**
  String get expiresIn;

  /// No description provided for @currentStockBelowMinimum.
  ///
  /// In en, this message translates to:
  /// **'Current stock is below minimum stock level'**
  String get currentStockBelowMinimum;

  /// No description provided for @addProduct.
  ///
  /// In en, this message translates to:
  /// **'Add Product'**
  String get addProduct;

  /// No description provided for @productName.
  ///
  /// In en, this message translates to:
  /// **'Product Name'**
  String get productName;

  /// No description provided for @failedToLoadDropdownData.
  ///
  /// In en, this message translates to:
  /// **'Failed to load dropdown data'**
  String get failedToLoadDropdownData;

  /// No description provided for @pleaseSelectCategory.
  ///
  /// In en, this message translates to:
  /// **'Please select a category'**
  String get pleaseSelectCategory;

  /// No description provided for @pleaseSelectUnit.
  ///
  /// In en, this message translates to:
  /// **'Please select a unit'**
  String get pleaseSelectUnit;

  /// No description provided for @enterValidCostPrice.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid cost price'**
  String get enterValidCostPrice;

  /// No description provided for @enterValidSellingPrice.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid selling price'**
  String get enterValidSellingPrice;

  /// No description provided for @enterValidMinimumStock.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid minimum stock'**
  String get enterValidMinimumStock;

  /// No description provided for @pleaseSelectExpiryDate.
  ///
  /// In en, this message translates to:
  /// **'Please select an expiry date'**
  String get pleaseSelectExpiryDate;

  /// No description provided for @sellingPriceCannotBeLessThanCostPrice.
  ///
  /// In en, this message translates to:
  /// **'Selling price cannot be less than cost price'**
  String get sellingPriceCannotBeLessThanCostPrice;

  /// No description provided for @productAddedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Product added successfully'**
  String get productAddedSuccessfully;

  /// No description provided for @failedToSaveProduct.
  ///
  /// In en, this message translates to:
  /// **'Failed to save product'**
  String get failedToSaveProduct;

  /// No description provided for @hasExpiryDate.
  ///
  /// In en, this message translates to:
  /// **'Has Expiry Date'**
  String get hasExpiryDate;

  /// No description provided for @selectExpiryDate.
  ///
  /// In en, this message translates to:
  /// **'Select Expiry Date'**
  String get selectExpiryDate;

  /// No description provided for @saveProduct.
  ///
  /// In en, this message translates to:
  /// **'Save Product'**
  String get saveProduct;

  /// No description provided for @productNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Product name is required'**
  String get productNameRequired;

  /// No description provided for @editProduct.
  ///
  /// In en, this message translates to:
  /// **'Edit Product'**
  String get editProduct;

  /// No description provided for @productUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Product updated successfully'**
  String get productUpdatedSuccessfully;

  /// No description provided for @failedToUpdateProduct.
  ///
  /// In en, this message translates to:
  /// **'Failed to update product'**
  String get failedToUpdateProduct;

  /// No description provided for @addCategory.
  ///
  /// In en, this message translates to:
  /// **'Add Category'**
  String get addCategory;

  /// No description provided for @editCategory.
  ///
  /// In en, this message translates to:
  /// **'Edit Category'**
  String get editCategory;

  /// No description provided for @categoryName.
  ///
  /// In en, this message translates to:
  /// **'Category Name'**
  String get categoryName;

  /// No description provided for @categoryAddedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Category added successfully'**
  String get categoryAddedSuccessfully;

  /// No description provided for @categoryUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Category updated successfully'**
  String get categoryUpdatedSuccessfully;

  /// No description provided for @categoryDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Category deleted successfully'**
  String get categoryDeletedSuccessfully;

  /// No description provided for @deleteCategory.
  ///
  /// In en, this message translates to:
  /// **'Delete Category'**
  String get deleteCategory;

  /// No description provided for @deleteCategoryQuestion.
  ///
  /// In en, this message translates to:
  /// **'Delete category?'**
  String get deleteCategoryQuestion;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @noCategoriesFound.
  ///
  /// In en, this message translates to:
  /// **'No categories found'**
  String get noCategoriesFound;

  /// No description provided for @unableToDeleteCategory.
  ///
  /// In en, this message translates to:
  /// **'Unable to delete category'**
  String get unableToDeleteCategory;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @scanBarcode.
  ///
  /// In en, this message translates to:
  /// **'Scan Barcode'**
  String get scanBarcode;

  /// No description provided for @units.
  ///
  /// In en, this message translates to:
  /// **'Units'**
  String get units;

  /// No description provided for @addUnit.
  ///
  /// In en, this message translates to:
  /// **'Add Unit'**
  String get addUnit;

  /// No description provided for @editUnit.
  ///
  /// In en, this message translates to:
  /// **'Edit Unit'**
  String get editUnit;

  /// No description provided for @unitName.
  ///
  /// In en, this message translates to:
  /// **'Unit Name'**
  String get unitName;

  /// No description provided for @unitAddedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Unit added successfully'**
  String get unitAddedSuccessfully;

  /// No description provided for @unitUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Unit updated successfully'**
  String get unitUpdatedSuccessfully;

  /// No description provided for @unitDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Unit deleted successfully'**
  String get unitDeletedSuccessfully;

  /// No description provided for @deleteUnit.
  ///
  /// In en, this message translates to:
  /// **'Delete Unit'**
  String get deleteUnit;

  /// No description provided for @deleteUnitQuestion.
  ///
  /// In en, this message translates to:
  /// **'Delete unit?'**
  String get deleteUnitQuestion;

  /// No description provided for @noUnitsFound.
  ///
  /// In en, this message translates to:
  /// **'No units found'**
  String get noUnitsFound;

  /// No description provided for @unableToDeleteUnit.
  ///
  /// In en, this message translates to:
  /// **'Unable to delete unit'**
  String get unableToDeleteUnit;

  /// No description provided for @noExpiringProducts.
  ///
  /// In en, this message translates to:
  /// **'No expiring products'**
  String get noExpiringProducts;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get days;

  /// No description provided for @inactiveProducts.
  ///
  /// In en, this message translates to:
  /// **'Inactive Products'**
  String get inactiveProducts;

  /// No description provided for @failedToLoadInactiveProducts.
  ///
  /// In en, this message translates to:
  /// **'Failed to load inactive products'**
  String get failedToLoadInactiveProducts;

  /// No description provided for @restoreProduct.
  ///
  /// In en, this message translates to:
  /// **'Restore Product'**
  String get restoreProduct;

  /// No description provided for @restoreProductQuestion.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to restore this product?'**
  String get restoreProductQuestion;

  /// No description provided for @productRestoredSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Product restored successfully'**
  String get productRestoredSuccessfully;

  /// No description provided for @failedToRestoreProduct.
  ///
  /// In en, this message translates to:
  /// **'Failed to restore product'**
  String get failedToRestoreProduct;

  /// No description provided for @noInactiveProducts.
  ///
  /// In en, this message translates to:
  /// **'No inactive products'**
  String get noInactiveProducts;

  /// No description provided for @noCategory.
  ///
  /// In en, this message translates to:
  /// **'No Category'**
  String get noCategory;

  /// No description provided for @failedToLoadProfile.
  ///
  /// In en, this message translates to:
  /// **'Failed to load profile'**
  String get failedToLoadProfile;

  /// No description provided for @noProfileFound.
  ///
  /// In en, this message translates to:
  /// **'No profile found'**
  String get noProfileFound;

  /// No description provided for @profileImageUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile image updated'**
  String get profileImageUpdated;

  /// No description provided for @failedToUploadImage.
  ///
  /// In en, this message translates to:
  /// **'Failed to upload image'**
  String get failedToUploadImage;

  /// No description provided for @profileInformation.
  ///
  /// In en, this message translates to:
  /// **'Profile Information'**
  String get profileInformation;

  /// No description provided for @profileInformationDescription.
  ///
  /// In en, this message translates to:
  /// **'Application and user details'**
  String get profileInformationDescription;

  /// No description provided for @user.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// No description provided for @application.
  ///
  /// In en, this message translates to:
  /// **'Application'**
  String get application;

  /// No description provided for @role.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get role;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @lightMode.
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get lightMode;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @company.
  ///
  /// In en, this message translates to:
  /// **'Company'**
  String get company;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @updateYourAccountPassword.
  ///
  /// In en, this message translates to:
  /// **'Update your account password'**
  String get updateYourAccountPassword;

  /// No description provided for @profileImageUploadUnsupported.
  ///
  /// In en, this message translates to:
  /// **'Profile image upload is currently available in Android/Desktop versions.'**
  String get profileImageUploadUnsupported;

  /// No description provided for @applicationName.
  ///
  /// In en, this message translates to:
  /// **'BashDafter'**
  String get applicationName;

  /// No description provided for @companyName.
  ///
  /// In en, this message translates to:
  /// **'BashSoft Digital'**
  String get companyName;

  /// No description provided for @failedToLoadShopProfile.
  ///
  /// In en, this message translates to:
  /// **'Failed to load shop profile'**
  String get failedToLoadShopProfile;

  /// No description provided for @shopProfileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Shop profile updated'**
  String get shopProfileUpdated;

  /// No description provided for @failedToUpdateShopProfile.
  ///
  /// In en, this message translates to:
  /// **'Failed to update shop profile'**
  String get failedToUpdateShopProfile;

  /// No description provided for @noShopProfileFound.
  ///
  /// In en, this message translates to:
  /// **'No shop profile found'**
  String get noShopProfileFound;

  /// No description provided for @shopName.
  ///
  /// In en, this message translates to:
  /// **'Shop Name'**
  String get shopName;

  /// No description provided for @shopNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Shop name is required'**
  String get shopNameRequired;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currency;

  /// No description provided for @currencyRequired.
  ///
  /// In en, this message translates to:
  /// **'Currency is required'**
  String get currencyRequired;

  /// No description provided for @phoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone is required'**
  String get phoneRequired;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @currentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get currentPassword;

  /// No description provided for @currentPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Current password is required'**
  String get currentPasswordRequired;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @newPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'New password is required'**
  String get newPasswordRequired;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @confirmPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Confirm password is required'**
  String get confirmPasswordRequired;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @passwordChangedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Password changed successfully'**
  String get passwordChangedSuccessfully;

  /// No description provided for @failedToChangePassword.
  ///
  /// In en, this message translates to:
  /// **'Failed to change password'**
  String get failedToChangePassword;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get arabic;

  /// No description provided for @aboutDescription.
  ///
  /// In en, this message translates to:
  /// **'BashDafter helps businesses manage customers, purchases, payments, inventory, and reports.'**
  String get aboutDescription;

  /// No description provided for @businessAccountingAndInventoryManagementSystem.
  ///
  /// In en, this message translates to:
  /// **'Business accounting and inventory management system.'**
  String get businessAccountingAndInventoryManagementSystem;

  /// No description provided for @developedBy.
  ///
  /// In en, this message translates to:
  /// **'Developed by'**
  String get developedBy;

  /// No description provided for @loadingCustomerSummary.
  ///
  /// In en, this message translates to:
  /// **'Loading customer summary...'**
  String get loadingCustomerSummary;

  /// No description provided for @failedToLoadCustomerSummary.
  ///
  /// In en, this message translates to:
  /// **'Failed to load customer summary'**
  String get failedToLoadCustomerSummary;

  /// No description provided for @outstanding.
  ///
  /// In en, this message translates to:
  /// **'Outstanding'**
  String get outstanding;

  /// No description provided for @searchCustomer.
  ///
  /// In en, this message translates to:
  /// **'Search customer'**
  String get searchCustomer;

  /// No description provided for @unknownCustomer.
  ///
  /// In en, this message translates to:
  /// **'Unknown Customer'**
  String get unknownCustomer;

  /// No description provided for @loadingRecentTransactions.
  ///
  /// In en, this message translates to:
  /// **'Loading recent transactions...'**
  String get loadingRecentTransactions;

  /// No description provided for @failedToLoadTransactions.
  ///
  /// In en, this message translates to:
  /// **'Failed to load transactions'**
  String get failedToLoadTransactions;

  /// No description provided for @loadingTopDebtors.
  ///
  /// In en, this message translates to:
  /// **'Loading top debtors...'**
  String get loadingTopDebtors;

  /// No description provided for @failedToLoadTopDebtors.
  ///
  /// In en, this message translates to:
  /// **'Failed to load top debtors'**
  String get failedToLoadTopDebtors;

  /// No description provided for @debtors.
  ///
  /// In en, this message translates to:
  /// **'Debtors'**
  String get debtors;

  /// No description provided for @highestDebt.
  ///
  /// In en, this message translates to:
  /// **'Highest Debt'**
  String get highestDebt;

  /// No description provided for @searchDebtor.
  ///
  /// In en, this message translates to:
  /// **'Search debtor'**
  String get searchDebtor;

  /// No description provided for @noDebtorsFound.
  ///
  /// In en, this message translates to:
  /// **'No debtors found'**
  String get noDebtorsFound;

  /// No description provided for @only.
  ///
  /// In en, this message translates to:
  /// **'Only'**
  String get only;

  /// No description provided for @inactiveUsers.
  ///
  /// In en, this message translates to:
  /// **'Inactive Users'**
  String get inactiveUsers;

  /// No description provided for @noInactiveUsersFound.
  ///
  /// In en, this message translates to:
  /// **'No inactive users found'**
  String get noInactiveUsersFound;

  /// No description provided for @failedToLoadInactiveUsers.
  ///
  /// In en, this message translates to:
  /// **'Failed to load inactive users'**
  String get failedToLoadInactiveUsers;

  /// No description provided for @failedToRestoreUser.
  ///
  /// In en, this message translates to:
  /// **'Failed to restore user'**
  String get failedToRestoreUser;

  /// No description provided for @restoreUser.
  ///
  /// In en, this message translates to:
  /// **'Restore User'**
  String get restoreUser;

  /// No description provided for @restoreUserQuestion.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to restore {username}?'**
  String restoreUserQuestion(Object username);

  /// No description provided for @userRestoredSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'{username} restored successfully'**
  String userRestoredSuccessfully(Object username);

  /// No description provided for @userFormCreateTitle.
  ///
  /// In en, this message translates to:
  /// **'Create User'**
  String get userFormCreateTitle;

  /// No description provided for @userFormEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit User'**
  String get userFormEditTitle;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstName;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

  /// No description provided for @passwordMinLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordMinLength;

  /// No description provided for @userCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'User created successfully'**
  String get userCreatedSuccessfully;

  /// No description provided for @userUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'User updated successfully'**
  String get userUpdatedSuccessfully;

  /// No description provided for @failedToCreateUser.
  ///
  /// In en, this message translates to:
  /// **'Failed to create user'**
  String get failedToCreateUser;

  /// No description provided for @failedToUpdateUser.
  ///
  /// In en, this message translates to:
  /// **'Failed to update user'**
  String get failedToUpdateUser;

  /// No description provided for @createUser.
  ///
  /// In en, this message translates to:
  /// **'Create User'**
  String get createUser;

  /// No description provided for @adminRole.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get adminRole;

  /// No description provided for @managerRole.
  ///
  /// In en, this message translates to:
  /// **'Manager'**
  String get managerRole;

  /// No description provided for @cashierRole.
  ///
  /// In en, this message translates to:
  /// **'Cashier'**
  String get cashierRole;

  /// No description provided for @searchUsers.
  ///
  /// In en, this message translates to:
  /// **'Search Users'**
  String get searchUsers;

  /// No description provided for @noUsersFound.
  ///
  /// In en, this message translates to:
  /// **'No users found'**
  String get noUsersFound;

  /// No description provided for @editUser.
  ///
  /// In en, this message translates to:
  /// **'Edit User'**
  String get editUser;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// No description provided for @deactivateUser.
  ///
  /// In en, this message translates to:
  /// **'Deactivate User'**
  String get deactivateUser;

  /// No description provided for @failedToLoadUsers.
  ///
  /// In en, this message translates to:
  /// **'Failed to load users'**
  String get failedToLoadUsers;

  /// No description provided for @failedToResetPassword.
  ///
  /// In en, this message translates to:
  /// **'Failed to reset password'**
  String get failedToResetPassword;

  /// No description provided for @failedToDeactivateUser.
  ///
  /// In en, this message translates to:
  /// **'Failed to deactivate user'**
  String get failedToDeactivateUser;

  /// No description provided for @resetUserPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset {username}'**
  String resetUserPassword(Object username);

  /// No description provided for @resetPasswordSuccess.
  ///
  /// In en, this message translates to:
  /// **'{username} password reset successfully'**
  String resetPasswordSuccess(Object username);

  /// No description provided for @deactivateUserQuestion.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to deactivate {username}?'**
  String deactivateUserQuestion(Object username);

  /// No description provided for @userDeactivated.
  ///
  /// In en, this message translates to:
  /// **'{username} deactivated'**
  String userDeactivated(Object username);

  /// No description provided for @purchaseReceiptStatement.
  ///
  /// In en, this message translates to:
  /// **'Purchase Receipt Statement'**
  String get purchaseReceiptStatement;

  /// No description provided for @customerLabel.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get customerLabel;

  /// No description provided for @dateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get dateLabel;

  /// No description provided for @itemsLabel.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get itemsLabel;

  /// No description provided for @quantityLabel.
  ///
  /// In en, this message translates to:
  /// **'Qty'**
  String get quantityLabel;

  /// No description provided for @totalAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Total Amount'**
  String get totalAmountLabel;

  /// No description provided for @thankYouForBusiness.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your business.'**
  String get thankYouForBusiness;

  /// No description provided for @poweredByBashDafter.
  ///
  /// In en, this message translates to:
  /// **'Powered by BashDafter'**
  String get poweredByBashDafter;

  /// No description provided for @paymentReceiptStatement.
  ///
  /// In en, this message translates to:
  /// **'Payment Receipt Statement'**
  String get paymentReceiptStatement;

  /// No description provided for @paymentAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Payment Amount'**
  String get paymentAmountLabel;

  /// No description provided for @thankYouForPayment.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your payment.'**
  String get thankYouForPayment;

  /// No description provided for @customerStatementTitle.
  ///
  /// In en, this message translates to:
  /// **'Customer Statement'**
  String get customerStatementTitle;

  /// No description provided for @currentBalanceLabel.
  ///
  /// In en, this message translates to:
  /// **'Current Balance'**
  String get currentBalanceLabel;

  /// No description provided for @transactionsLabel.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get transactionsLabel;

  /// No description provided for @purchaseReceiptType.
  ///
  /// In en, this message translates to:
  /// **'PURCHASE'**
  String get purchaseReceiptType;

  /// No description provided for @paymentReceiptType.
  ///
  /// In en, this message translates to:
  /// **'PAYMENT'**
  String get paymentReceiptType;

  /// No description provided for @customer.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get customer;

  /// No description provided for @statementNumber.
  ///
  /// In en, this message translates to:
  /// **'Statement #'**
  String get statementNumber;

  /// No description provided for @generatedDate.
  ///
  /// In en, this message translates to:
  /// **'Generated'**
  String get generatedDate;

  /// No description provided for @transactionDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get transactionDate;

  /// No description provided for @transactionType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get transactionType;

  /// No description provided for @transactionAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get transactionAmount;

  /// No description provided for @totalTransactions.
  ///
  /// In en, this message translates to:
  /// **'Total Transactions'**
  String get totalTransactions;

  /// No description provided for @preparedBy.
  ///
  /// In en, this message translates to:
  /// **'Prepared By'**
  String get preparedBy;

  /// No description provided for @authorizedSignature.
  ///
  /// In en, this message translates to:
  /// **'Authorized Signature'**
  String get authorizedSignature;

  /// No description provided for @pageOf.
  ///
  /// In en, this message translates to:
  /// **'Page {current} of {total}'**
  String pageOf(int current, int total);

  /// No description provided for @customerStatementNoTransactions.
  ///
  /// In en, this message translates to:
  /// **'No transactions available'**
  String get customerStatementNoTransactions;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
