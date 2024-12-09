import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'CartProvider.dart';

class BottomCartStrip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return ValueListenableBuilder<int>(
      valueListenable: cartProvider.cartCount, // Listen to cartCount changes
      builder: (context, count, child) {
        if (count == 0) return SizedBox.shrink(); // Hide if no items in cart
        return Container(
          color: Colors.blueAccent,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "$count items in cart",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              ElevatedButton(
                onPressed: () {
                  // Navigate to Cart with custom animation
                  Navigator.pushNamed(context, '/cart');
                },
                child: Text(
                  "View Cart",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
