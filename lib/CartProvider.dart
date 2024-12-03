import 'package:flutter/foundation.dart';

class CartProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _cartItems = [];

  List<Map<String, dynamic>> get cartItems => _cartItems;

  // Add item to cart
  void addItem(Map<String, dynamic> product) {
    final existingIndex = _cartItems.indexWhere((item) => item['name'] == product['name']);
    if (existingIndex != -1) {
      // If the product already exists, increase the quantity
      _cartItems[existingIndex]['quantity'] += product['quantity'];
    } else {
      // Add new product
      _cartItems.add(product);
    }
    notifyListeners(); // Notify listeners about the change
  }

  // Update the quantity of an item
  void updateQuantity(int index, int delta) {
    if (_cartItems[index]['quantity'] + delta > 0) {
      _cartItems[index]['quantity'] += delta;
    } else {
      _cartItems.removeAt(index);
    }
    notifyListeners();
  }

  // Remove an item from the cart
  void removeItem(int index) {
    _cartItems.removeAt(index);
    notifyListeners();
  }

  // Calculate subtotal
  double calculateSubTotal() {
    return _cartItems.fold(0, (sum, item) => sum + (item['price'] * item['quantity']));
  }

  // Calculate shipping fee
  double calculateShippingFee(double subTotal) {
    return subTotal > 500 ? 0 : 50; // Free shipping for orders over ₹500
  }
}
