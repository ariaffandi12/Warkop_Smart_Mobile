import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';

class AttendanceResult {
  final bool success;
  final String message;
  final String? errorCode;

  AttendanceResult({
    required this.success,
    required this.message,
    this.errorCode,
  });
}

class AttendanceProvider with ChangeNotifier {
  bool _isLoading = false;
  Map<String, dynamic>? _todayAttendance;

  bool get isLoading => _isLoading;
  Map<String, dynamic>? get todayAttendance => _todayAttendance;

  Future<AttendanceResult> checkIn(int userId, File photo) async {
    _isLoading = true;
    notifyListeners();

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(AppConstants.checkinUrl),
      );
      request.fields['user_id'] = userId.toString();
      request.files.add(await http.MultipartFile.fromPath('photo', photo.path));

      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      var data = json.decode(responseData);

      _isLoading = false;
      notifyListeners();

      if (data['status'] == 'success') {
        return AttendanceResult(
          success: true,
          message: data['message'] ?? 'Check-in berhasil!',
        );
      } else {
        return AttendanceResult(
          success: false,
          message: data['message'] ?? 'Gagal check-in',
          errorCode: data['error_code'],
        );
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return AttendanceResult(success: false, message: 'Terjadi kesalahan: $e');
    }
  }

  Future<AttendanceResult> checkOut(int userId, File photo) async {
    _isLoading = true;
    notifyListeners();

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(AppConstants.checkoutUrl),
      );
      request.fields['user_id'] = userId.toString();
      request.files.add(await http.MultipartFile.fromPath('photo', photo.path));

      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      var data = json.decode(responseData);

      _isLoading = false;
      notifyListeners();

      if (data['status'] == 'success') {
        return AttendanceResult(
          success: true,
          message: data['message'] ?? 'Check-out berhasil!',
        );
      } else {
        return AttendanceResult(
          success: false,
          message: data['message'] ?? 'Gagal check-out',
          errorCode: data['error_code'],
        );
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return AttendanceResult(success: false, message: 'Terjadi kesalahan: $e');
    }
  }

  Future<void> fetchTodayStatus(int userId) async {
    // Note: The backend doesn't have a specific status endpoint yet,
    // but we can infer it from the report/attendance log.
    // For now, let's keep it simple.
  }
}
