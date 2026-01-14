import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';
import '../utils/constants.dart';

class ProductProvider with ChangeNotifier {
  List<ProductModel> _products = [];
  bool _isLoading = false;

  List<ProductModel> get products => _products;
  bool get isLoading => _isLoading;

  Future<void> fetchProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse(AppConstants.getProductsUrl));
      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['status'] == 'success') {
        _products = (data['data'] as List)
            .map((item) => ProductModel.fromJson(item))
            .toList();
      }
    } catch (e) {
      debugPrint("Error fetching products: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addProduct(
    String name,
    int price,
    int stock,
    File? image,
  ) async {
    _isLoading = true;
    notifyListeners();

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(AppConstants.addProductUrl),
      );
      request.fields['name'] = name;
      request.fields['price'] = price.toString();
      request.fields['stock'] = stock.toString();

      if (image != null) {
        request.files.add(
          await http.MultipartFile.fromPath('image', image.path),
        );
      }

      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      var data = json.decode(responseData);

      if (response.statusCode == 201 && data['status'] == 'success') {
        await fetchProducts();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateStock(int id, int newStock) async {
    try {
      final response = await http.post(
        Uri.parse(AppConstants.updateStockUrl),
        body: json.encode({'id': id, 'stock': newStock}),
        headers: {'Content-Type': 'application/json'},
      );
      final data = json.decode(response.body);
      if (response.statusCode == 200 && data['status'] == 'success') {
        await fetchProducts();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
