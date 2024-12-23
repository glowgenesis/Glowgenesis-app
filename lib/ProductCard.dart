import 'package:flutter/material.dart';
import 'package:glowgenesis/CartProvider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductCard extends StatefulWidget {
  final String name;
  final String category;
  final String description;
  final double rating;
  final int reviews;
  final int price;
  final String imagePath;

  const ProductCard({
    super.key,
    required this.name,
    required this.category,
    required this.description,
    required this.rating,
    required this.reviews,
    required this.price,
    required this.imagePath,
  });

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  int quantity = 0;

  @override
  void initState() {
    super.initState();
    _loadQuantity();
  }

  Future<void> _loadQuantity() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      quantity = prefs.getInt(widget.name) ?? 0;
    });
  }

  Future<void> _saveQuantity(int qty) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(widget.name, qty);
  }

  void _incrementQuantity(BuildContext context) {
    setState(() {
      quantity++;
    });
    _saveQuantity(quantity);

    final cartController = Provider.of<CartController>(context, listen: false);
    cartController.addToCart({
      'name': widget.name,
      'category': widget.category,
      'description': widget.description,
      'price': widget.price,
      'image': widget.imagePath,
      'quantity': 1, // Increment by 1
    });
  }

  void _decrementQuantity(BuildContext context) {
    if (quantity > 0) {
      setState(() {
        quantity--;
      });
      _saveQuantity(quantity);

      final cartController =
          Provider.of<CartController>(context, listen: false);
      if (quantity == 0) {
        cartController.removeFromCart(widget.name);
      } else {
        cartController.updateQuantity(widget.name, quantity);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartController = Provider.of<CartController>(context);
    quantity = cartController.getQuantity(widget.name);

    return SizedBox(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
              child: Image.asset(
                widget.imagePath,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Chip(
                    label: Text(
                      widget.category,
                      style: const TextStyle(fontSize: 8),
                    ),
                    backgroundColor: Colors.green.shade50,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    widget.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "₹${widget.price}",
                    style: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    widget.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 5),
                      Text("${widget.rating}", style: const TextStyle(fontSize: 12)),
                      Text(" (${widget.reviews} Reviews)",
                          style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 5),
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: widget.price == 0
                  ? ElevatedButton(
                      onPressed: null, // Button disabled for "Coming Soon"
                      style: ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(10),
                          ),
                        ),
                        backgroundColor: Colors.grey,
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(
                          "Coming Soon",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  : quantity == 0
                      ? ElevatedButton(
                          onPressed: () => _incrementQuantity(context),
                          style: ElevatedButton.styleFrom(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(10),
                              ),
                            ),
                            backgroundColor: Colors.orange,
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.0),
                            child: Text(
                              "Add to Cart",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove, color: Colors.red),
                              onPressed: () => _decrementQuantity(context),
                            ),
                            Text(
                              "$quantity",
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add, color: Colors.green),
                              onPressed: () => _incrementQuantity(context),
                            ),
                          ],
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
