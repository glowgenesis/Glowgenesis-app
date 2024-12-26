// import 'package:flutter/material.dart';
// import 'package:glowgenesis/CartProvider.dart';
// import 'package:provider/provider.dart';

// class BottomCartStrip extends StatelessWidget {
//   const BottomCartStrip({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final cartController = Provider.of<CartController>(context);
//     final cartItemCount = cartController.cartItems.values
//         .fold<int>(0, (sum, item) => sum + (item['quantity'] as int));

//     if (cartItemCount == 0) return const SizedBox.shrink(); // Hide when cart is empty

//     return Container(
//       color: Colors.blueAccent,
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             "$cartItemCount items in cart",
//             style: const TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pushNamed(context, '/cart');
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.white,
//               foregroundColor: Colors.blueAccent,
//             ),
//             child: const Text(
//               "View Cart",
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:glowgenesis/CartProvider.dart';
import 'package:glowgenesis/api.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class BottomCartStrip extends StatelessWidget {
  const BottomCartStrip({super.key});

  Future<bool> _isTokenValid(BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString('authToken');

      if (authToken == null) {
        return false; // Token is missing
      }

      final response = await http.post(
        Uri.parse(
            '${Api.backendApi}/token-validate'), // Replace with your API URL
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );
      print(response.body);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData['message'] ==
            'Token validated'; // Updated condition
      }
    } catch (e) {
      print('Error validating token: $e');
    }

    return false; // Default to invalid token
  }

  @override
  Widget build(BuildContext context) {
    final cartController = Provider.of<CartController>(context);
    final cartItemCount = cartController.cartItems.values
        .fold<int>(0, (sum, item) => sum + (item['quantity'] as int));

    if (cartItemCount == 0)
      return const SizedBox.shrink(); // Hide when cart is empty

    return Container(
      color: Colors.blueAccent,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "$cartItemCount items in cart",
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              final isValid = await _isTokenValid(context);
              print("is valid ${isValid}");
              if (isValid) {
                Navigator.pushNamed(context, '/cart'); // Navigate to cart
              } else {
                Navigator.pushReplacementNamed(
                    context, '/login'); // Navigate to login
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.blueAccent,
            ),
            child: const Text(
              "View Cart",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
