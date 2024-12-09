import 'package:flutter/material.dart';

class CartProvider with ChangeNotifier {
  final List<Map<String, dynamic>> _cartItems = [];
  final ValueNotifier<int> cartCount = ValueNotifier<int>(0); // Added

  List<Map<String, dynamic>> get cartItems => _cartItems;

  void addToCart(Map<String, dynamic> item) {
    int index =
        _cartItems.indexWhere((element) => element['name'] == item['name']);
    if (index >= 0) {
      _cartItems[index]['quantity'] += item['quantity'];
    } else {
      _cartItems.add(item);
    }
    cartCount.value = _cartItems.length; // Update cart count
    notifyListeners();
  }

  void removeFromCart(String name) {
    _cartItems.removeWhere((item) => item['name'] == name);
    cartCount.value = _cartItems.length; // Update cart count
    notifyListeners();
  }

  void updateQuantity(int index, int change) {
    _cartItems[index]['quantity'] += change;
    if (_cartItems[index]['quantity'] <= 0) {
      _cartItems.removeAt(index);
    }
    cartCount.value = _cartItems.length; // Update cart count
    notifyListeners();
  }

  double calculateSubTotal() {
    return _cartItems.fold(
        0.0, (total, item) => total + item['price'] * item['quantity']);
  }

  double calculateShippingFee(double subTotal) {
    return subTotal > 500 ? 0 : 50; // Free shipping for orders above ₹500
  }
}
