class AppConstants {
  // Available modes: 'emulator', 'hp', 'web'
  static const String mode = 'hp';

  static String get baseUrl {
    switch (mode) {
      case 'hp':
        return "http://192.168.100.14/warkop_api"; // HP Android real with Port 8080
      case 'web':
        return "http://127.0.0.1/warkop_api";
      case 'emulator':
      default:
        // Fallback or default emulator address
        return "http://10.0.2.2/warkop_api";
    }
  }

  // Auth Endpoints
  static String get loginUrl => "$baseUrl/auth/login.php";

  // Products Endpoints
  static String get getProductsUrl => "$baseUrl/products/get_products.php";
  static String get addProductUrl => "$baseUrl/products/add_product.php";
  static String get updateProductUrl => "$baseUrl/products/update_product.php";
  static String get deleteProductUrl => "$baseUrl/products/delete_product.php";
  static String get updateStockUrl => "$baseUrl/products/update_stock.php";

  // Attendance Endpoints
  static String get checkinUrl => "$baseUrl/attendance/checkin.php";
  static String get checkoutUrl => "$baseUrl/attendance/checkout.php";

  // Sales Endpoints
  static String get addSaleUrl => "$baseUrl/sales/add_sale.php";

  // Reports Endpoints
  static String get salesReportUrl => "$baseUrl/reports/sales_report.php";
  static String get attendanceReportUrl =>
      "$baseUrl/reports/attendance_report.php";

  // Uploads Path
  static String get productImagesUrl => "$baseUrl/uploads/products/";
  static String get attendanceImagesInUrl =>
      "$baseUrl/uploads/attendance/masuk/";
  static String get attendanceImagesOutUrl =>
      "$baseUrl/uploads/attendance/pulang/";
  static String get profileImagesUrl => "$baseUrl/uploads/profiles/";
  static String get updateProfileUrl => "$baseUrl/auth/update_profile.php";
}
