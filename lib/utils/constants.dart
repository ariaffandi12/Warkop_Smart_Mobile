import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;

class AppConstants {
  // Base URLs untuk setiap platform
  static const String _webUrl = "http://127.0.0.1/warkop_api";
  static const String _emulatorUrl = "http://10.0.2.2/warkop_api";
  static const String _hpUrl =
      "http://10.16.42.133/warkop_api"; // Ganti IP sesuai WiFi buka cmd ipconfig get ipv4

  // AUTO-DETECT PLATFORM 🚀
  static String get baseUrl {
    if (kIsWeb) {
      // Running di browser
      return _webUrl;
    } else if (Platform.isAndroid) {
      //catatan saya untuk hp real maka ubah aja ip nya manual karena tidak bisa auto detect ipconig
      // Running di Android (emulator atau HP asli)
      // Untuk HP asli, pastikan komputer & HP di WiFi yang sama
      // dan ganti _hpUrl dengan IP komputer kamu
      // return _emulatorUrl; // Untuk emulator
      return _hpUrl; // Untuk HP asli
    } else {
      // iOS atau platform lain
      return _webUrl;
    }
  }

  // Auth Endpoints
  static String get loginUrl => "$baseUrl/auth/login.php";
  static String get getEmployeesUrl => "$baseUrl/auth/get_employees.php";
  static String get registerEmployeeUrl => "$baseUrl/auth/register.php";
  static String get updatePasswordUrl => "$baseUrl/auth/update_password.php";
  static String get deleteEmployeeUrl => "$baseUrl/auth/delete_employee.php";

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
