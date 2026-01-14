import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../utils/constants.dart';

class AuthProvider with ChangeNotifier {
  UserModel? _user;
  bool _isLoading = false;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;

  AuthProvider() {
    _loadUser();
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('user_data');
    if (userData != null) {
      _user = UserModel.fromJson(json.decode(userData));
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse(AppConstants.loginUrl),
        body: json.encode({'email': email, 'password': password}),
        headers: {'Content-Type': 'application/json'},
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['status'] == 'success') {
        _user = UserModel.fromJson(data['user']);

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_data', json.encode(data['user']));

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    _user = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_data');
    notifyListeners();
  }
}
