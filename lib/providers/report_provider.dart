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

  // Personal Attendance for Employee
  List<dynamic> _personalAttendance = [];
  Map<String, dynamic> _attendanceSummary = {};
  String _selectedMonth = '';

  List<dynamic> get personalAttendance => _personalAttendance;
  Map<String, dynamic> get attendanceSummary => _attendanceSummary;
  String get selectedMonth => _selectedMonth;

  Future<void> fetchPersonalAttendance(String userName, {String? month}) async {
    _isLoading = true;
    if (month != null) _selectedMonth = month;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse(AppConstants.attendanceReportUrl),
      );
      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['status'] == 'success') {
        List<dynamic> allRecords = data['data'];

        debugPrint('📊 Total records from API: ${allRecords.length}');
        debugPrint('🔍 Looking for userName: $userName');

        // Filter by karyawan_name (matching the logged-in user's name)
        _personalAttendance = allRecords.where((record) {
          String? recordName = record['karyawan_name']
              ?.toString()
              .toLowerCase();
          return recordName == userName.toLowerCase();
        }).toList();

        debugPrint(
          '✅ Filtered records for user: ${_personalAttendance.length}',
        );

        // Filter by month if specified
        if (_selectedMonth.isNotEmpty) {
          _personalAttendance = _personalAttendance.where((record) {
            String checkIn = record['check_in'] ?? '';
            return checkIn.startsWith(_selectedMonth);
          }).toList();
        }

        // Calculate summary
        int totalHadir = _personalAttendance.length;
        int totalSelesai = _personalAttendance
            .where((r) => r['status'] == 'selesai')
            .length;

        // Calculate average work hours
        double totalHours = 0;
        int countWithCheckout = 0;
        for (var record in _personalAttendance) {
          if (record['check_out'] != null) {
            try {
              DateTime checkIn = DateTime.parse(record['check_in']);
              DateTime checkOut = DateTime.parse(record['check_out']);
              totalHours += checkOut.difference(checkIn).inMinutes / 60;
              countWithCheckout++;
            } catch (_) {}
          }
        }

        _attendanceSummary = {
          'total_hadir': totalHadir,
          'total_selesai': totalSelesai,
          'rata_jam': countWithCheckout > 0
              ? (totalHours / countWithCheckout)
              : 0,
        };
      }
    } catch (e) {
      debugPrint("Error fetching personal attendance: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
