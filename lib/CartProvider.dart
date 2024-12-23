import 'package:flutter/material.dart';

class CartController extends ChangeNotifier {
  final Map<String, Map<String, dynamic>> _cartItems = {};

  Map<String, Map<String, dynamic>> get cartItems => _cartItems;

  int quantity = 0;

  void addToCart(Map<String, dynamic> item) {
    String name = item['name'];
    if (_cartItems.containsKey(name)) {
      _cartItems[name]!['quantity'] += item['quantity'];
    } else {
      _cartItems[name] = {...item};
    }
    notifyListeners();
  }

  void updateQuantity(String name, int quantity) {
    if (_cartItems.containsKey(name)) {
      if (quantity > 0) {
        _cartItems[name]!['quantity'] = quantity;
      } else {
        _cartItems.remove(name);
      }
      notifyListeners();
    }
  }

  void removeFromCart(String name) {
    if (_cartItems.containsKey(name)) {
      _cartItems.remove(name);
      notifyListeners();
    }
  }

  int getQuantity(String name) {
    return _cartItems[name]?['quantity'] ?? 0;
  }
}
