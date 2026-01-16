import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';

class CartItem {
  final int productId;
  final String productName;
  final int price;
  int quantity;

  CartItem({
    required this.productId,
    required this.productName,
    required this.price,
    this.quantity = 1,
  });

  Map<String, dynamic> toJson() {
    return {'product_id': productId, 'quantity': quantity, 'price': price};
  }
}

class SalesProvider with ChangeNotifier {
  List<CartItem> _cart = [];
  bool _isLoading = false;

  List<CartItem> get cart => _cart;
  bool get isLoading => _isLoading;
  int get totalAmount =>
      _cart.fold(0, (sum, item) => sum + (item.price * item.quantity));

  void addToCart(int productId, String name, int price, {int maxStock = 999}) {
    final index = _cart.indexWhere((item) => item.productId == productId);
    if (index != -1) {
      // Check stock limit
      if (_cart[index].quantity < maxStock) {
        _cart[index].quantity++;
      }
    } else {
      _cart.add(
        CartItem(productId: productId, productName: name, price: price),
      );
    }
    notifyListeners();
  }

  void incrementQuantity(int productId, {int maxStock = 999}) {
    final index = _cart.indexWhere((item) => item.productId == productId);
    if (index != -1 && _cart[index].quantity < maxStock) {
      _cart[index].quantity++;
      notifyListeners();
    }
  }

  void decrementQuantity(int productId) {
    final index = _cart.indexWhere((item) => item.productId == productId);
    if (index != -1) {
      if (_cart[index].quantity > 1) {
        _cart[index].quantity--;
      } else {
        _cart.removeAt(index);
      }
      notifyListeners();
    }
  }

  int getQuantityInCart(int productId) {
    final index = _cart.indexWhere((item) => item.productId == productId);
    if (index != -1) {
      return _cart[index].quantity;
    }
    return 0;
  }

  void removeFromCart(int productId) {
    _cart.removeWhere((item) => item.productId == productId);
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  Future<bool> processSale(int userId) async {
    if (_cart.isEmpty) return false;

    _isLoading = true;
    notifyListeners();

    try {
      final body = {
        'user_id': userId,
        'total_price': totalAmount,
        'items': _cart.map((item) => item.toJson()).toList(),
      };

      final response = await http.post(
        Uri.parse(AppConstants.addSaleUrl),
        body: json.encode(body),
        headers: {'Content-Type': 'application/json'},
      );

      final data = json.decode(response.body);
      if ((response.statusCode == 200 || response.statusCode == 201) &&
          data['status'] == 'success') {
        clearCart();
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
}
