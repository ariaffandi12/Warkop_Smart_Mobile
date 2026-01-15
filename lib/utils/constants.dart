import 'package:flutter/material.dart';

class AppConstants {
  // Available modes: 'emulator', 'hp', 'web'
  static const String mode = 'hp';

  static String get baseUrl {
    switch (mode) {
      case 'hp':
        return "http://10.10.10.116/warkop_api"; // HP Android real with Port 8080
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
  static String get deleteAttendanceUrl =>
      "$baseUrl/attendance/delete_attendance.php";

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

class AppColors {
  // Brand Colors (Fintech Dark Modern)
  static const Color primary = Color(0xFF7C5CFF); // Deep Purple Neon
  static const Color secondary = Color(0xFF22D3EE); // Cyan Neon
  static const Color accent = Color(0xFFEC4899); // Pink Neon
  static const Color success = Color(0xFF22C55E); // Green Neon
  static const Color warning = Color(0xFFF59E0B); // Amber Neon
  static const Color error = Color(0xFFEF4444); // Red Neon

  // Background Colors
  static const Color background = Color(0xFF0B0F1A);
  static const Color surface = Color(0xFF12172A);
  static const Color card = Color(0xFF171C34);
  static const Color subCard = Color(0xFF1E293B);

  // Text Colors
  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF64748B);

  // Gradients
  static const List<Color> mainGradient = [
    Color(0xFF0B0F1A),
    Color(0xFF171C34),
  ];

  static const List<Color> primaryGradient = [
    Color(0xFF7C5CFF),
    Color(0xFF5E36FF),
  ];
}
