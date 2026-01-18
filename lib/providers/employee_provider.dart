import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';

class EmployeeProvider with ChangeNotifier {
  List<Map<String, dynamic>> _employees = [];
  bool _isLoading = false;

  List<Map<String, dynamic>> get employees => _employees;
  bool get isLoading => _isLoading;

  Future<void> fetchEmployees() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http
          .get(Uri.parse(AppConstants.getEmployeesUrl))
          .timeout(const Duration(seconds: 15));

      debugPrint('📋 Fetching employees...');
      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['status'] == 'success') {
        _employees = List<Map<String, dynamic>>.from(data['data'] ?? []);
        debugPrint('✅ Found ${_employees.length} employees');
      } else {
        debugPrint('❌ Failed to fetch employees: ${data['message']}');
      }
    } catch (e) {
      debugPrint('💥 Error fetching employees: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> registerEmployee({
    required String name,
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      debugPrint('👤 Registering new employee: $name');

      final response = await http
          .post(
            Uri.parse(AppConstants.registerEmployeeUrl),
            body: json.encode({
              'name': name,
              'email': email,
              'password': password,
              'role': 'employee',
            }),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 15));

      final data = json.decode(response.body);

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          data['status'] == 'success') {
        debugPrint('✅ Employee registered successfully');
        await fetchEmployees(); // Refresh list
        return true;
      } else {
        debugPrint('❌ Registration failed: ${data['message']}');
        return false;
      }
    } catch (e) {
      debugPrint('💥 Error registering employee: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateEmployeePassword({
    required int employeeId,
    required String newPassword,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      debugPrint('🔑 Updating password for employee ID: $employeeId');

      final response = await http
          .post(
            Uri.parse(AppConstants.updatePasswordUrl),
            body: json.encode({
              'user_id': employeeId,
              'new_password': newPassword,
            }),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 15));

      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['status'] == 'success') {
        debugPrint('✅ Password updated successfully');
        return true;
      } else {
        debugPrint('❌ Password update failed: ${data['message']}');
        return false;
      }
    } catch (e) {
      debugPrint('💥 Error updating password: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteEmployee({required int employeeId}) async {
    _isLoading = true;
    notifyListeners();

    try {
      debugPrint('🗑️ Deleting employee ID: $employeeId');

      final response = await http
          .post(
            Uri.parse(AppConstants.deleteEmployeeUrl),
            body: json.encode({'user_id': employeeId}),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 15));

      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['status'] == 'success') {
        debugPrint('✅ Employee deleted successfully');
        // Remove from local list
        _employees.removeWhere(
          (emp) => emp['id'].toString() == employeeId.toString(),
        );
        notifyListeners();
        return true;
      } else {
        debugPrint('❌ Delete failed: ${data['message']}');
        return false;
      }
    } catch (e) {
      debugPrint('💥 Error deleting employee: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
