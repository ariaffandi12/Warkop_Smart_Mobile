import 'package:flutter/foundation.dart';

class AppConstants {
  // Use 10.0.2.2 for Android Emulator, or 127.0.0.1 for Web/Desktop
  static const String baseUrl = kIsWeb
      ? "http://127.0.0.1/warkop_api"
      : "http://10.0.2.2/warkop_api";

  // Auth Endpoints
  static const String loginUrl = "$baseUrl/auth/login.php";

  // Products Endpoints
  static const String getProductsUrl = "$baseUrl/products/get_products.php";
  static const String addProductUrl = "$baseUrl/products/add_product.php";
  static const String updateStockUrl = "$baseUrl/products/update_stock.php";

  // Attendance Endpoints
  static const String checkinUrl = "$baseUrl/attendance/checkin.php";
  static const String checkoutUrl = "$baseUrl/attendance/checkout.php";

  // Sales Endpoints
  static const String addSaleUrl = "$baseUrl/sales/add_sale.php";

  // Reports Endpoints
  static const String salesReportUrl = "$baseUrl/reports/sales_report.php";
  static const String attendanceReportUrl =
      "$baseUrl/reports/attendance_report.php";

  // Uploads Path
  static const String productImagesUrl = "$baseUrl/uploads/products/";
  static const String attendanceImagesInUrl =
      "$baseUrl/uploads/attendance/masuk/";
  static const String attendanceImagesOutUrl =
      "$baseUrl/uploads/attendance/pulang/";
}
