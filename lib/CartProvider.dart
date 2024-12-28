// import 'package:flutter/material.dart';

// class CartController extends ChangeNotifier {
//   final Map<String, Map<String, dynamic>> _cartItems = {};

//   Map<String, Map<String, dynamic>> get cartItems => _cartItems;
//   String? _deliveryAddress;

//   int quantity = 0;

//   String? get deliveryAddress => _deliveryAddress;

//   void updateDeliveryAddress(String address) {
//     _deliveryAddress = address;
//     notifyListeners();
//   }

//   void addToCart(Map<String, dynamic> item) {
//     String name = item['name'];
//     if (_cartItems.containsKey(name)) {
//       _cartItems[name]!['quantity'] += item['quantity'];
//     } else {
//       _cartItems[name] = {...item};
//     }
//     notifyListeners();
//   }

//   void updateQuantity(String name, int quantity) {
//     if (_cartItems.containsKey(name)) {
//       if (quantity > 0) {
//         _cartItems[name]!['quantity'] = quantity;
//       } else {
//         _cartItems.remove(name);
//       }
//       notifyListeners();
//     }
//   }

//   void removeFromCart(String name) {
//     if (_cartItems.containsKey(name)) {
//       _cartItems.remove(name);
//       notifyListeners();
//     }
//   }

//   int getQuantity(String name) {
//     return _cartItems[name]?['quantity'] ?? 0;
//   }

//   void clearCart() {
//     _cartItems.clear();
//     notifyListeners();
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartController extends ChangeNotifier {
  final Map<String, Map<String, dynamic>> _cartItems = {};
  String? _deliveryAddress;

  String? get deliveryAddress => _deliveryAddress;
  Map<String, Map<String, dynamic>> get cartItems => _cartItems;

  // Load cart from SharedPreferences
  Future<void> loadCartFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cartJson = prefs.getString('cart_items');
    if (cartJson != null) {
      List<dynamic> cartList = jsonDecode(cartJson);
      for (var item in cartList) {
        _cartItems[item['name']] = Map<String, dynamic>.from(item);
      }
    }
    notifyListeners();
  }

  // Save cart to SharedPreferences
  Future<void> _saveCartToPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String cartJson = jsonEncode(_cartItems.values.toList());
    await prefs.setString('cart_items', cartJson);
  }

  Future<void> clearCartFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs
        .remove('cart_items'); // Remove cart_items from SharedPreferences
    _cartItems.clear(); // Clear the local cart data as well
    notifyListeners();
  }

  // Add item to cart
  void addToCart(Map<String, dynamic> item) {
    String name = item['name'];
    if (_cartItems.containsKey(name)) {
      _cartItems[name]!['quantity'] += item['quantity'];
    } else {
      _cartItems[name] = {...item};
    }
    _saveCartToPreferences(); // Save the updated cart
    notifyListeners();
  }

  // Update item quantity in the cart
  void updateQuantity(String name, int quantity) {
    if (_cartItems.containsKey(name)) {
      if (quantity > 0) {
        _cartItems[name]!['quantity'] = quantity;
      } else {
        _cartItems.remove(name);
      }
      _saveCartToPreferences(); // Save the updated cart
      notifyListeners();
    }
  }

  // Remove item from cart
  void removeFromCart(String name) {
    if (_cartItems.containsKey(name)) {
      _cartItems.remove(name);
      _saveCartToPreferences(); // Save the updated cart
      notifyListeners();
    }
  }

  // Get the quantity of an item in the cart
  int getQuantity(String name) {
    return _cartItems[name]?['quantity'] ?? 0;
  }

  // Clear the entire cart
  void clearCart() {
    _cartItems.clear();
    _saveCartToPreferences(); // Clear cart from SharedPreferences
    notifyListeners();
  }
}
