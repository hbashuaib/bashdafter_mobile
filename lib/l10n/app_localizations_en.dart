// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'BashDafter';

  @override
  String get products => 'Products';

  @override
  String get customers => 'Customers';

  @override
  String get payments => 'Payments';

  @override
  String get purchases => 'Purchases';

  @override
  String get reports => 'Reports';

  @override
  String get inventory => 'Inventory';

  @override
  String get settings => 'Settings';

  @override
  String get search => 'Search';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get loading => 'Loading...';

  @override
  String get noDataFound => 'No data found';

  @override
  String get profileNotFound => 'Profile not found';

  @override
  String get userManagement => 'User Management';

  @override
  String get manageSystemUsers => 'Manage system users';

  @override
  String get productCategories => 'Product Categories';

  @override
  String get manageProductCategories => 'Manage product categories';

  @override
  String get productUnits => 'Product Units';

  @override
  String get manageProductUnits => 'Manage product units';

  @override
  String get manageApplicationPreferences =>
      'Manage application preferences and information';

  @override
  String get shopProfile => 'Shop Profile';

  @override
  String get manageShopInformation => 'Manage shop information';

  @override
  String get profile => 'Profile';

  @override
  String get userAndApplicationDetails => 'User and application details';

  @override
  String get language => 'Language';

  @override
  String get changeApplicationLanguage => 'Change application language';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get darkModeEnabled => 'Dark mode enabled';

  @override
  String get lightModeEnabled => 'Light mode enabled';

  @override
  String get about => 'About';

  @override
  String get applicationInformation => 'Application information';

  @override
  String get logout => 'Logout';

  @override
  String get signOut => 'Sign out of the application';

  @override
  String get areYouSureLogout => 'Are you sure you want to logout?';

  @override
  String get welcomeBack => 'Welcome Back';

  @override
  String get signInToContinue => 'Sign in to continue';

  @override
  String get username => 'Username';

  @override
  String get password => 'Password';

  @override
  String get usernameRequired => 'Username is required';

  @override
  String get passwordRequired => 'Password is required';

  @override
  String get invalidUsernameOrPassword => 'Invalid username or password';

  @override
  String get login => 'Login';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get failedToLoadDashboard => 'Failed to load dashboard';

  @override
  String get noDashboardDataAvailable => 'No dashboard data available';

  @override
  String get businessDashboard => 'Business Dashboard';

  @override
  String get businessDashboardDescription =>
      'Monitor customers, purchases, payments and inventory';

  @override
  String get customersCount => 'Customers';

  @override
  String get balance => 'Balance';

  @override
  String get businessOverview => 'Business Overview';

  @override
  String get totalPurchases => 'Total Purchases';

  @override
  String get totalPayments => 'Total Payments';

  @override
  String get quickActions => 'Quick Actions';

  @override
  String get inventoryManagement => 'Inventory Management';

  @override
  String get inventoryManagementDescription =>
      'Manage stock operations and inventory reports';

  @override
  String get voiceEntry => 'Voice Entry';

  @override
  String get voiceEntryDescription => 'Record customer transactions';

  @override
  String get loadingProducts => 'Loading products...';

  @override
  String get failedToLoadProducts => 'Failed to load products';

  @override
  String get total => 'Total';

  @override
  String get active => 'Active';

  @override
  String get inactive => 'Inactive';

  @override
  String get searchProducts => 'Search by name, category, or barcode';

  @override
  String get all => 'All';

  @override
  String showingProducts(int filtered, int total) {
    return 'Showing $filtered of $total products';
  }

  @override
  String get productNotFound => 'Product not found';

  @override
  String get noProductsFound => 'No products found';

  @override
  String get barcode => 'Barcode';

  @override
  String get showing => 'Showing';

  @override
  String get outOf => 'of';

  @override
  String get productsLabel => 'products';

  @override
  String get loadingCustomers => 'Loading customers...';

  @override
  String get failedToLoadCustomers => 'Failed to load customers';

  @override
  String get searchCustomers => 'Search by name or phone';

  @override
  String get showingCustomers => 'customers';

  @override
  String get noCustomersFound => 'No customers found';

  @override
  String get reportsCenter => 'Reports Center';

  @override
  String get customerAndFinancialReports => 'Customer and financial reports';

  @override
  String get customerSummary => 'Customer Summary';

  @override
  String get customerBalancesAndAccounts => 'Customer balances and accounts';

  @override
  String get topDebtors => 'Top Debtors';

  @override
  String get customersWithHighestBalances => 'Customers with highest balances';

  @override
  String get recentTransactions => 'Recent Transactions';

  @override
  String get latestPurchasesAndPayments => 'Latest purchases and payments';

  @override
  String get failedToLoadCustomer => 'Failed to load customer';

  @override
  String get cannotDeactivate => 'Cannot Deactivate';

  @override
  String get customerBalanceMustBeZero =>
      'Customer balance must be zero before deactivation.';

  @override
  String get ok => 'OK';

  @override
  String get deactivateCustomer => 'Deactivate Customer';

  @override
  String get deactivate => 'Deactivate';

  @override
  String get deactivateCustomerQuestion => 'Deactivate customer?';

  @override
  String get customerDeactivatedSuccessfully =>
      'Customer deactivated successfully';

  @override
  String get failedToDeactivateCustomer => 'Failed to deactivate customer';

  @override
  String get customerReactivatedSuccessfully =>
      'Customer reactivated successfully';

  @override
  String get failedToReactivateCustomer => 'Failed to reactivate customer';

  @override
  String get purchase => 'Purchase';

  @override
  String get payment => 'Payment';

  @override
  String get records => 'Records';

  @override
  String get statement => 'Statement';

  @override
  String get addCustomer => 'Add Customer';

  @override
  String get name => 'Name';

  @override
  String get phone => 'Phone';

  @override
  String get address => 'Address';

  @override
  String get notes => 'Notes';

  @override
  String get saveCustomer => 'Save Customer';

  @override
  String get customerNameRequired => 'Customer name is required';

  @override
  String get phoneNumberRequired => 'Phone number is required';

  @override
  String get enterValidPhoneNumber => 'Enter a valid phone number';

  @override
  String get customerAddedSuccessfully => 'Customer added successfully';

  @override
  String get failedToSaveCustomer => 'Failed to save customer';

  @override
  String get editCustomer => 'Edit Customer';

  @override
  String get activeStatus => 'Active';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get customerUpdatedSuccessfully => 'Customer updated successfully';

  @override
  String get failedToUpdateCustomer => 'Failed to update customer';

  @override
  String get inactiveCustomers => 'Inactive Customers';

  @override
  String get failedToLoadInactiveCustomers =>
      'Failed to load inactive customers';

  @override
  String get restoreCustomer => 'Restore Customer';

  @override
  String get restore => 'Restore';

  @override
  String get restoreCustomerQuestion =>
      'Are you sure you want to restore this customer?';

  @override
  String get customerRestoredSuccessfully => 'Customer restored successfully';

  @override
  String get failedToRestoreCustomer => 'Failed to restore customer';

  @override
  String get noInactiveCustomers => 'No inactive customers';

  @override
  String get customerStatement => 'Customer Statement';

  @override
  String get loadingStatement => 'Loading statement...';

  @override
  String get failedToLoadStatement => 'Failed to load statement';

  @override
  String get noStatementAvailable => 'No statement available';

  @override
  String get transactions => 'Transactions';

  @override
  String get searchTransactions => 'Search transactions';

  @override
  String get noTransactionsFound => 'No transactions found';

  @override
  String get currentBalance => 'Current Balance';

  @override
  String get phoneLabel => 'Phone';

  @override
  String get pdfGeneratedSuccessfully => 'PDF generated successfully';

  @override
  String get failedToGeneratePdf => 'Failed to generate PDF';

  @override
  String get generatedByBashDafter => 'Generated by BashDafter';

  @override
  String get purchaseType => 'PURCHASE';

  @override
  String get paymentType => 'PAYMENT';

  @override
  String get runningBalance => 'Bal';

  @override
  String get loadingPurchases => 'Loading purchases...';

  @override
  String get failedToLoadPurchases => 'Failed to load purchases';

  @override
  String get average => 'Average';

  @override
  String get searchPurchases => 'Search by date, notes or amount';

  @override
  String get showingPurchases => 'purchases';

  @override
  String get noPurchasesFound => 'No purchases found';

  @override
  String get purchaseDetails => 'Purchase Details';

  @override
  String get purchaseDate => 'Purchase Date';

  @override
  String get totalAmount => 'Total Amount';

  @override
  String get noNotes => 'No notes';

  @override
  String get items => 'Items';

  @override
  String get addPurchase => 'Add Purchase';

  @override
  String get scanProductBarcode => 'Scan Product Barcode';

  @override
  String get product => 'Product';

  @override
  String get quantity => 'Quantity';

  @override
  String get unitPrice => 'Unit Price';

  @override
  String get lineTotal => 'Line Total';

  @override
  String get addItem => 'Add Item';

  @override
  String get purchaseItems => 'Purchase Items';

  @override
  String get purchaseTotal => 'Purchase Total';

  @override
  String get savePurchase => 'Save Purchase';

  @override
  String get pleaseSelectProduct => 'Please select a product';

  @override
  String get enterValidQuantity => 'Enter a valid quantity';

  @override
  String get enterValidUnitPrice => 'Enter a valid unit price';

  @override
  String get productAlreadyAdded => 'Product already added';

  @override
  String get availableInStock => 'available in stock';

  @override
  String get addAtLeastOneItem => 'Add at least one item';

  @override
  String get purchaseSavedSuccessfully => 'Purchase saved successfully';

  @override
  String get failedToSavePurchase => 'Failed to save purchase';

  @override
  String get noItemsAddedYet => 'No items added yet';

  @override
  String get loadingPayments => 'Loading payments...';

  @override
  String get failedToLoadPayments => 'Failed to load payments';

  @override
  String get searchPayments => 'Search by date, notes or amount';

  @override
  String get showingPayments => 'payments';

  @override
  String get noPaymentsFound => 'No payments found';

  @override
  String get paymentDetails => 'Payment Details';

  @override
  String get paymentReceipt => 'PAYMENT RECEIPT';

  @override
  String get paymentAmount => 'Payment Amount';

  @override
  String get paymentDate => 'Payment Date';

  @override
  String get paymentId => 'Payment ID';

  @override
  String get addPayment => 'Add Payment';

  @override
  String get amount => 'Amount';

  @override
  String get paymentPreview => 'Payment Preview';

  @override
  String get savePayment => 'Save Payment';

  @override
  String get paymentAmountRequired => 'Payment amount is required';

  @override
  String get enterValidAmount => 'Enter a valid amount';

  @override
  String get amountMustBeGreaterThanZero => 'Amount must be greater than zero';

  @override
  String get paymentAddedSuccessfully => 'Payment added successfully';

  @override
  String get failedToSavePayment => 'Failed to save payment';

  @override
  String get inventoryFunctions => 'Inventory Functions';

  @override
  String get inventoryDashboard => 'Inventory Dashboard';

  @override
  String get inventoryDashboardDescription =>
      'Inventory statistics and summary';

  @override
  String get inventoryLookup => 'Inventory Lookup';

  @override
  String get inventoryLookupDescription => 'Scan barcode and check stock';

  @override
  String get lowStockProducts => 'Low Stock Products';

  @override
  String get lowStockProductsDescription => 'Products requiring replenishment';

  @override
  String get expiringProducts => 'Expiring Products';

  @override
  String get expiringProductsDescription => 'Products expiring soon';

  @override
  String get topSellingProducts => 'Top Selling Products';

  @override
  String get topSellingProductsDescription => 'Best performing products';

  @override
  String get inventoryHistory => 'Inventory History';

  @override
  String get inventoryHistoryDescription => 'All inventory transactions';

  @override
  String get stockAdjustments => 'Stock Adjustments';

  @override
  String get stockAdjustmentsDescription => 'Increase or decrease stock';

  @override
  String get failedToLoadInventoryDashboard =>
      'Failed to load inventory dashboard';

  @override
  String get noInventoryDataAvailable => 'No inventory data available';

  @override
  String get lowStock => 'Low Stock';

  @override
  String get expiring => 'Expiring';

  @override
  String get totalProducts => 'Total Products';

  @override
  String get inventoryTransactions => 'Inventory Transactions';

  @override
  String get inventoryValue => 'Inventory Value';

  @override
  String get currentStockValue => 'Current stock value';

  @override
  String get scanProduct => 'Scan Product';

  @override
  String get searchingProduct => 'Searching product...';

  @override
  String get stock => 'Stock';

  @override
  String get minimumStock => 'Minimum Stock';

  @override
  String get sellingPrice => 'Selling Price';

  @override
  String get inStock => 'IN STOCK';

  @override
  String get lowStockStatus => 'LOW STOCK';

  @override
  String get adjustStock => 'Adjust Stock';

  @override
  String get stockUpdated => 'Stock updated';

  @override
  String get currentStockLabel => 'Current stock';

  @override
  String get barcodeLabel => 'Barcode';

  @override
  String get stockAdjustment => 'Stock Adjustment';

  @override
  String get adjustmentType => 'Adjustment Type';

  @override
  String get reason => 'Reason';

  @override
  String get saveAdjustment => 'Save Adjustment';

  @override
  String get reasonRequired => 'Reason is required';

  @override
  String get stockAdjustmentSavedSuccessfully =>
      'Stock adjustment saved successfully';

  @override
  String get failedToSaveStockAdjustment => 'Failed to save stock adjustment';

  @override
  String get selectedFromBarcodeLookup => 'Selected from barcode lookup';

  @override
  String get currentStock => 'Current Stock';

  @override
  String get openingStock => 'Opening Stock';

  @override
  String get stockIn => 'Stock In';

  @override
  String get stockOut => 'Stock Out';

  @override
  String get damagedStock => 'Damaged Stock';

  @override
  String get correction => 'Correction';

  @override
  String get loadingLowStockProducts => 'Loading low stock products...';

  @override
  String get failedToLoadLowStockProducts =>
      'Failed to load low stock products';

  @override
  String get searchProduct => 'Search product';

  @override
  String get noLowStockProducts => 'No low stock products';

  @override
  String get current => 'Current';

  @override
  String get minimum => 'Minimum';

  @override
  String get unknownProduct => 'Unknown Product';

  @override
  String get loadingTopSellingProducts => 'Loading top selling products...';

  @override
  String get failedToLoadTopSellingProducts =>
      'Failed to load top selling products';

  @override
  String get topSeller => 'Top Seller';

  @override
  String get noSalesFound => 'No sales found';

  @override
  String get sold => 'Sold';

  @override
  String get loadingInventoryHistory => 'Loading inventory history...';

  @override
  String get failedToLoadInventoryHistory => 'Failed to load inventory history';

  @override
  String get searchInventoryHistory => 'Search product, type or reference';

  @override
  String get noInventoryTransactionsFound => 'No inventory transactions found';

  @override
  String get reference => 'Reference';

  @override
  String get sale => 'Sale';

  @override
  String get transactionOpening => 'Opening';

  @override
  String get transactionIn => 'Stock In';

  @override
  String get transactionOut => 'Stock Out';

  @override
  String get transactionDamage => 'Damaged';

  @override
  String get transactionCorrection => 'Correction';

  @override
  String get transactionSale => 'Sale';

  @override
  String get deactivateProduct => 'Deactivate Product';

  @override
  String get deactivateProductQuestion =>
      'Are you sure you want to deactivate this product?';

  @override
  String get productDeactivatedSuccessfully =>
      'Product deactivated successfully';

  @override
  String get failedToDeactivateProduct => 'Failed to deactivate product';

  @override
  String get category => 'Category';

  @override
  String get unit => 'Unit';

  @override
  String get description => 'Description';

  @override
  String get noDescription => 'No description';

  @override
  String get costPrice => 'Cost Price';

  @override
  String get totalSold => 'Total Sold';

  @override
  String get hasExpiry => 'Has Expiry';

  @override
  String get expiryDate => 'Expiry Date';

  @override
  String get status => 'Status';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get expired => 'EXPIRED';

  @override
  String get daysRemaining => 'days remaining';

  @override
  String get expiresIn => 'Expires in';

  @override
  String get currentStockBelowMinimum =>
      'Current stock is below minimum stock level';

  @override
  String get addProduct => 'Add Product';

  @override
  String get productName => 'Product Name';

  @override
  String get failedToLoadDropdownData => 'Failed to load dropdown data';

  @override
  String get pleaseSelectCategory => 'Please select a category';

  @override
  String get pleaseSelectUnit => 'Please select a unit';

  @override
  String get enterValidCostPrice => 'Enter a valid cost price';

  @override
  String get enterValidSellingPrice => 'Enter a valid selling price';

  @override
  String get enterValidMinimumStock => 'Enter a valid minimum stock';

  @override
  String get pleaseSelectExpiryDate => 'Please select an expiry date';

  @override
  String get sellingPriceCannotBeLessThanCostPrice =>
      'Selling price cannot be less than cost price';

  @override
  String get productAddedSuccessfully => 'Product added successfully';

  @override
  String get failedToSaveProduct => 'Failed to save product';

  @override
  String get hasExpiryDate => 'Has Expiry Date';

  @override
  String get selectExpiryDate => 'Select Expiry Date';

  @override
  String get saveProduct => 'Save Product';

  @override
  String get productNameRequired => 'Product name is required';

  @override
  String get editProduct => 'Edit Product';

  @override
  String get productUpdatedSuccessfully => 'Product updated successfully';

  @override
  String get failedToUpdateProduct => 'Failed to update product';

  @override
  String get addCategory => 'Add Category';

  @override
  String get editCategory => 'Edit Category';

  @override
  String get categoryName => 'Category Name';

  @override
  String get categoryAddedSuccessfully => 'Category added successfully';

  @override
  String get categoryUpdatedSuccessfully => 'Category updated successfully';

  @override
  String get categoryDeletedSuccessfully => 'Category deleted successfully';

  @override
  String get deleteCategory => 'Delete Category';

  @override
  String get deleteCategoryQuestion => 'Delete category?';

  @override
  String get update => 'Update';

  @override
  String get noCategoriesFound => 'No categories found';

  @override
  String get unableToDeleteCategory => 'Unable to delete category';

  @override
  String get categories => 'Categories';

  @override
  String get scanBarcode => 'Scan Barcode';

  @override
  String get units => 'Units';

  @override
  String get addUnit => 'Add Unit';

  @override
  String get editUnit => 'Edit Unit';

  @override
  String get unitName => 'Unit Name';

  @override
  String get unitAddedSuccessfully => 'Unit added successfully';

  @override
  String get unitUpdatedSuccessfully => 'Unit updated successfully';

  @override
  String get unitDeletedSuccessfully => 'Unit deleted successfully';

  @override
  String get deleteUnit => 'Delete Unit';

  @override
  String get deleteUnitQuestion => 'Delete unit?';

  @override
  String get noUnitsFound => 'No units found';

  @override
  String get unableToDeleteUnit => 'Unable to delete unit';

  @override
  String get noExpiringProducts => 'No expiring products';

  @override
  String get days => 'days';

  @override
  String get inactiveProducts => 'Inactive Products';

  @override
  String get failedToLoadInactiveProducts => 'Failed to load inactive products';

  @override
  String get restoreProduct => 'Restore Product';

  @override
  String get restoreProductQuestion =>
      'Are you sure you want to restore this product?';

  @override
  String get productRestoredSuccessfully => 'Product restored successfully';

  @override
  String get failedToRestoreProduct => 'Failed to restore product';

  @override
  String get noInactiveProducts => 'No inactive products';

  @override
  String get noCategory => 'No Category';

  @override
  String get failedToLoadProfile => 'Failed to load profile';

  @override
  String get noProfileFound => 'No profile found';

  @override
  String get profileImageUpdated => 'Profile image updated';

  @override
  String get failedToUploadImage => 'Failed to upload image';

  @override
  String get profileInformation => 'Profile Information';

  @override
  String get profileInformationDescription => 'Application and user details';

  @override
  String get user => 'User';

  @override
  String get application => 'Application';

  @override
  String get role => 'Role';

  @override
  String get email => 'Email';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get theme => 'Theme';

  @override
  String get lightMode => 'Light Mode';

  @override
  String get version => 'Version';

  @override
  String get company => 'Company';

  @override
  String get changePassword => 'Change Password';

  @override
  String get updateYourAccountPassword => 'Update your account password';

  @override
  String get profileImageUploadUnsupported =>
      'Profile image upload is currently available in Android/Desktop versions.';

  @override
  String get applicationName => 'BashDafter';

  @override
  String get companyName => 'BashSoft Digital';

  @override
  String get failedToLoadShopProfile => 'Failed to load shop profile';

  @override
  String get shopProfileUpdated => 'Shop profile updated';

  @override
  String get failedToUpdateShopProfile => 'Failed to update shop profile';

  @override
  String get noShopProfileFound => 'No shop profile found';

  @override
  String get shopName => 'Shop Name';

  @override
  String get shopNameRequired => 'Shop name is required';

  @override
  String get currency => 'Currency';

  @override
  String get currencyRequired => 'Currency is required';

  @override
  String get phoneRequired => 'Phone is required';

  @override
  String get city => 'City';

  @override
  String get currentPassword => 'Current Password';

  @override
  String get currentPasswordRequired => 'Current password is required';

  @override
  String get newPassword => 'New Password';

  @override
  String get newPasswordRequired => 'New password is required';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get confirmPasswordRequired => 'Confirm password is required';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get passwordChangedSuccessfully => 'Password changed successfully';

  @override
  String get failedToChangePassword => 'Failed to change password';

  @override
  String get english => 'English';

  @override
  String get arabic => 'العربية';

  @override
  String get aboutDescription =>
      'BashDafter helps businesses manage customers, purchases, payments, inventory, and reports.';

  @override
  String get businessAccountingAndInventoryManagementSystem =>
      'Business accounting and inventory management system.';

  @override
  String get developedBy => 'Developed by';

  @override
  String get loadingCustomerSummary => 'Loading customer summary...';

  @override
  String get failedToLoadCustomerSummary => 'Failed to load customer summary';

  @override
  String get outstanding => 'Outstanding';

  @override
  String get searchCustomer => 'Search customer';

  @override
  String get unknownCustomer => 'Unknown Customer';

  @override
  String get loadingRecentTransactions => 'Loading recent transactions...';

  @override
  String get failedToLoadTransactions => 'Failed to load transactions';

  @override
  String get loadingTopDebtors => 'Loading top debtors...';

  @override
  String get failedToLoadTopDebtors => 'Failed to load top debtors';

  @override
  String get debtors => 'Debtors';

  @override
  String get highestDebt => 'Highest Debt';

  @override
  String get searchDebtor => 'Search debtor';

  @override
  String get noDebtorsFound => 'No debtors found';

  @override
  String get only => 'Only';

  @override
  String get inactiveUsers => 'Inactive Users';

  @override
  String get noInactiveUsersFound => 'No inactive users found';

  @override
  String get failedToLoadInactiveUsers => 'Failed to load inactive users';

  @override
  String get failedToRestoreUser => 'Failed to restore user';

  @override
  String get restoreUser => 'Restore User';

  @override
  String restoreUserQuestion(Object username) {
    return 'Are you sure you want to restore $username?';
  }

  @override
  String userRestoredSuccessfully(Object username) {
    return '$username restored successfully';
  }

  @override
  String get userFormCreateTitle => 'Create User';

  @override
  String get userFormEditTitle => 'Edit User';

  @override
  String get firstName => 'First Name';

  @override
  String get lastName => 'Last Name';

  @override
  String get passwordMinLength => 'Password must be at least 6 characters';

  @override
  String get userCreatedSuccessfully => 'User created successfully';

  @override
  String get userUpdatedSuccessfully => 'User updated successfully';

  @override
  String get failedToCreateUser => 'Failed to create user';

  @override
  String get failedToUpdateUser => 'Failed to update user';

  @override
  String get createUser => 'Create User';

  @override
  String get adminRole => 'Admin';

  @override
  String get managerRole => 'Manager';

  @override
  String get cashierRole => 'Cashier';

  @override
  String get searchUsers => 'Search Users';

  @override
  String get noUsersFound => 'No users found';

  @override
  String get editUser => 'Edit User';

  @override
  String get resetPassword => 'Reset Password';

  @override
  String get deactivateUser => 'Deactivate User';

  @override
  String get failedToLoadUsers => 'Failed to load users';

  @override
  String get failedToResetPassword => 'Failed to reset password';

  @override
  String get failedToDeactivateUser => 'Failed to deactivate user';

  @override
  String resetUserPassword(Object username) {
    return 'Reset $username';
  }

  @override
  String resetPasswordSuccess(Object username) {
    return '$username password reset successfully';
  }

  @override
  String deactivateUserQuestion(Object username) {
    return 'Are you sure you want to deactivate $username?';
  }

  @override
  String userDeactivated(Object username) {
    return '$username deactivated';
  }

  @override
  String get purchaseReceiptStatement => 'Purchase Receipt Statement';

  @override
  String get customerLabel => 'Customer';

  @override
  String get dateLabel => 'Date';

  @override
  String get itemsLabel => 'Items';

  @override
  String get quantityLabel => 'Qty';

  @override
  String get totalAmountLabel => 'Total Amount';

  @override
  String get thankYouForBusiness => 'Thank you for your business.';

  @override
  String get poweredByBashDafter => 'Powered by BashDafter';

  @override
  String get paymentReceiptStatement => 'Payment Receipt Statement';

  @override
  String get paymentAmountLabel => 'Payment Amount';

  @override
  String get thankYouForPayment => 'Thank you for your payment.';

  @override
  String get customerStatementTitle => 'Customer Statement';

  @override
  String get currentBalanceLabel => 'Current Balance';

  @override
  String get transactionsLabel => 'Transactions';

  @override
  String get purchaseReceiptType => 'PURCHASE';

  @override
  String get paymentReceiptType => 'PAYMENT';

  @override
  String get customer => 'Customer';

  @override
  String get statementNumber => 'Statement #';

  @override
  String get generatedDate => 'Generated';

  @override
  String get transactionDate => 'Date';

  @override
  String get transactionType => 'Type';

  @override
  String get transactionAmount => 'Amount';

  @override
  String get totalTransactions => 'Total Transactions';

  @override
  String get preparedBy => 'Prepared By';

  @override
  String get authorizedSignature => 'Authorized Signature';

  @override
  String pageOf(int current, int total) {
    return 'Page $current of $total';
  }

  @override
  String get customerStatementNoTransactions => 'No transactions available';

  @override
  String get englishName => 'English Name';

  @override
  String get arabicName => 'Arabic Name';

  @override
  String get fieldRequired => 'This field is required';

  @override
  String get englishNameRequired => 'English name is required';

  @override
  String get voicePurchase => 'Voice Purchase';

  @override
  String get voicePurchaseInstructions =>
      'Say the customer name and what they bought. For example: \"Ahmed Ali bought 2 milks today.\"';

  @override
  String get voicePurchaseAndroidOnly =>
      'Voice purchase input is currently enabled on Android.';

  @override
  String get voicePreparingSpeechRecognition =>
      'Preparing speech recognition...';

  @override
  String get voiceListeningInstructions =>
      'Listening. Say the customer and purchase details.';

  @override
  String voiceSpeakInEnglish(Object language) {
    return 'Speak in English. Selected language: $language';
  }

  @override
  String get voiceRecognitionNotReady => 'Speech recognition is not ready.';

  @override
  String get voiceRecognitionUnavailable =>
      'Speech recognition is unavailable. Check the Android speech service and microphone permission.';

  @override
  String get voiceNoEnglishLanguageInstalled =>
      'No English speech language is installed on this device.';

  @override
  String voiceStartFailed(Object error) {
    return 'Could not start speech recognition: $error';
  }

  @override
  String voiceListeningFailed(Object error) {
    return 'Could not start listening: $error';
  }

  @override
  String voiceStopFailed(Object error) {
    return 'Could not stop listening: $error';
  }

  @override
  String get voicePreparing => 'Preparing...';

  @override
  String get voiceStartSpeaking => 'Start Speaking';

  @override
  String get voiceStopListening => 'Stop Listening';

  @override
  String get voiceClearTranscript => 'Clear Transcript';

  @override
  String get voiceTranscript => 'Transcript';

  @override
  String get voiceTranscriptHint => 'Your recognized words will appear here.';

  @override
  String get voiceRecording => 'Voice Recording';

  @override
  String get customerRequiredBeforeRecording =>
      'Please select a customer first';

  @override
  String get recording => 'Recording...';

  @override
  String get ready => 'Ready';

  @override
  String get startRecording => 'Start Recording';

  @override
  String get stopRecording => 'Stop Recording';

  @override
  String get recordingSaved => 'Recording Saved';

  @override
  String get playRecording => 'Play Recording';

  @override
  String get newRecording => 'New Recording';

  @override
  String get listening => 'Listening...';

  @override
  String get recognizedText => 'Recognized Text';

  @override
  String get detectedItems => 'Detected Items';

  @override
  String get removeItem => 'Remove Item';

  @override
  String removeItemQuestion(Object itemName) {
    return 'Remove $itemName?';
  }

  @override
  String get remove => 'Remove';

  @override
  String get productNotFoundSuggested =>
      'Product Not Found. Suggested products:';

  @override
  String multipleProductsFound(Object productName) {
    return 'Multiple products found for \"$productName\". Please select one:';
  }

  @override
  String get price => 'Price';

  @override
  String get insufficientStock => 'Insufficient Stock';

  @override
  String get purchaseSummary => 'Purchase Summary';

  @override
  String get createPurchase => 'Create Purchase';

  @override
  String get purchaseDraft => 'Purchase Draft';

  @override
  String get confirmPurchase => 'Confirm Purchase';

  @override
  String get saving => 'Saving...';

  @override
  String get noValidProductsFound => 'No valid products found';

  @override
  String get voicePurchaseSavedSuccessfully =>
      'Voice Purchase Saved Successfully';

  @override
  String get createdFromVoicePurchase => 'Created from Voice Purchase';

  @override
  String get speechRecognitionUnavailable => 'Speech recognition unavailable';

  @override
  String get priceLabel => 'Price';

  @override
  String get stockLabel => 'Stock';
}
