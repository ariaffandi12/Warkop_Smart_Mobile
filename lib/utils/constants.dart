import 'package:flutter/foundation.dart';

class AppConstants {
  // Use 10.0.2.2 for Android Emulator, or 127.0.0.1 for Web/Desktop
  static String get baseUrl {
    if (kIsWeb) {
      return "http://127.0.0.1/warkop_api";
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      return "http://10.0.2.2/warkop_api";
    } else {
      return "http://127.0.0.1/warkop_api";
    }
  }

  // Auth Endpoints
  static String get loginUrl => "$baseUrl/auth/login.php";

  // Products Endpoints
  static String get getProductsUrl => "$baseUrl/products/get_products.php";
  static String get addProductUrl => "$baseUrl/products/add_product.php";
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
}
