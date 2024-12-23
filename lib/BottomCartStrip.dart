import 'package:flutter/material.dart';
import 'package:glowgenesis/CartProvider.dart';
import 'package:provider/provider.dart';

class BottomCartStrip extends StatelessWidget {
  const BottomCartStrip({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = Provider.of<CartController>(context);
    final cartItemCount = cartController.cartItems.values
        .fold<int>(0, (sum, item) => sum + (item['quantity'] as int));

    if (cartItemCount == 0) return const SizedBox.shrink(); // Hide when cart is empty

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
            onPressed: () {
              Navigator.pushNamed(context, '/cart');
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
