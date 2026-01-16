import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';

class ReportProvider with ChangeNotifier {
  Map<String, dynamic>? _salesSummary;
  Map<String, dynamic>? _yesterdaySummary;
  List<dynamic> _recentSales = [];
  List<dynamic> _attendanceRecords = [];
  bool _isLoading = false;
  String _currentFilterType = 'today'; // Track current filter

  Map<String, dynamic>? get salesSummary => _salesSummary;
  Map<String, dynamic>? get yesterdaySummary => _yesterdaySummary;
  List<dynamic> get recentSales => _recentSales;
  List<dynamic> get attendanceRecords => _attendanceRecords;
  bool get isLoading => _isLoading;
  String get currentFilterType => _currentFilterType;

  // Get filter label for display
  String get filterLabel {
    switch (_currentFilterType) {
      case 'today':
        return 'Hari Ini';
      case 'monthly':
        return 'Bulan Ini';
      default:
        return 'Hari Ini';
    }
  }

  // Change filter and fetch new data
  Future<void> changeFilter(String filterType) async {
    _currentFilterType = filterType;
    await fetchSalesReport(type: filterType);
  }

  Future<void> fetchSalesReport({String type = 'today'}) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse("${AppConstants.salesReportUrl}?type=$type"),
      );
      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['status'] == 'success') {
        if (type == 'yesterday') {
          _yesterdaySummary = data['summary'];
        } else {
          _salesSummary = data['summary'];
          _recentSales = data['data'];
        }
      }
    } catch (e) {
      debugPrint("Error fetching sales report: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchComparisonReport() async {
    _isLoading = true;
    notifyListeners();

    await Future.wait([
      fetchSalesReport(type: 'today'),
      fetchSalesReport(type: 'yesterday'),
    ]);

    _isLoading = false;
    notifyListeners();
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

  Future<bool> deleteAttendanceRecord(int id) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse(AppConstants.deleteAttendanceUrl),
        body: json.encode({'id': id}),
        headers: {'Content-Type': 'application/json'},
      );
      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['status'] == 'success') {
        // Refresh the list after successful deletion
        await fetchAttendanceReport();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("Error deleting attendance record: $e");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
