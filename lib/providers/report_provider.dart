import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';

class ReportProvider with ChangeNotifier {
  Map<String, dynamic>? _salesSummary;
  List<dynamic> _recentSales = [];
  List<dynamic> _attendanceRecords = [];
  bool _isLoading = false;

  Map<String, dynamic>? get salesSummary => _salesSummary;
  List<dynamic> get recentSales => _recentSales;
  List<dynamic> get attendanceRecords => _attendanceRecords;
  bool get isLoading => _isLoading;

  Future<void> fetchSalesReport({String type = 'today'}) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse("${AppConstants.salesReportUrl}?type=$type"),
      );
      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['status'] == 'success') {
        _salesSummary = data['summary'];
        _recentSales = data['data'];
      }
    } catch (e) {
      debugPrint("Error fetching sales report: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchAttendanceReport() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse(AppConstants.attendanceReportUrl),
      );
      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['status'] == 'success') {
        _attendanceRecords = data['data'];
      }
    } catch (e) {
      debugPrint("Error fetching attendance report: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
