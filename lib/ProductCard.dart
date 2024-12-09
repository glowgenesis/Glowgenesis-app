import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'CartProvider.dart';

class ProductCard extends StatefulWidget {
  final String name;
  final String category;
  final String description;
  final double rating;
  final int reviews;
  final int price;
  final String imagePath;

  const ProductCard({
    Key? key,
    required this.name,
    required this.category,
    required this.description,
    required this.rating,
    required this.reviews,
    required this.price,
    required this.imagePath,
  }) : super(key: key);

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

    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    cartProvider.addToCart({
      'name': widget.name,
      'category': widget.category,
      'description': widget.description,
      'price': widget.price,
      'image': widget.imagePath,
      'quantity': 1, // Always add 1 to the cart
    });
  }

  void _decrementQuantity(BuildContext context) {
    if (quantity > 0) {
      setState(() {
        quantity--;
      });
      _saveQuantity(quantity);

      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      if (quantity == 0) {
        cartProvider.removeFromCart(widget.name);
      } else {
        cartProvider.addToCart({
          'name': widget.name,
          'category': widget.category,
          'description': widget.description,
          'price': widget.price,
          'image': widget.imagePath,
          'quantity': quantity,
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
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
                      style: TextStyle(fontSize: 10),
                    ),
                    backgroundColor: Colors.green.shade50,
                  ),
                  SizedBox(height: 5),
                  Text(
                    widget.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    widget.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 16),
                      SizedBox(width: 5),
                      Text("${widget.rating}", style: TextStyle(fontSize: 12)),
                      Text(" (${widget.reviews} Reviews)",
                          style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                  SizedBox(height: 5),
                ],
              ),
            ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: quantity == 0
                  ? ElevatedButton(
                      onPressed: () => _incrementQuantity(context),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(10),
                          ),
                        ),
                        backgroundColor: Colors.orange,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
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
                          icon: Icon(Icons.remove, color: Colors.red),
                          onPressed: () => _decrementQuantity(context),
                        ),
                        Text(
                          "$quantity",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: Icon(Icons.add, color: Colors.green),
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
