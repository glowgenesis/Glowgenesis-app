import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'CartProvider.dart'; // Import CartProvider for state management

class ProductDetailsPage extends StatefulWidget {
  final String productName;
  final String productImage;
  final String productDescription;
  final double productPrice;
  final double productRating;
  final int reviewCount;
  final bool isLiked;
  final Function toggleLike;

  ProductDetailsPage({
    required this.productName,
    required this.productImage,
    required this.productDescription,
    required this.productPrice,
    required this.productRating,
    required this.reviewCount,
    required this.isLiked,
    required this.toggleLike,
  });

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  // Function to add an item to the cart via CartProvider
  void addToCart() {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    // Add the product to the cart
    cartProvider.addItem({
      'name': widget.productName,
      'image': widget.productImage,
      'price': widget.productPrice,
      'quantity': 1,
    });

    // Show a snackbar confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.productName} added to cart'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Details',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(
              widget.isLiked
                  ? Icons.favorite
                  : Icons.favorite_border,
              size: 24,
              color: widget.isLiked ? Colors.redAccent : Colors.black,
            ),
            onPressed: () {
              widget.toggleLike();
            },
          ),
        ],
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Display product image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(screenWidth * 0.05),
                    child: widget.productImage.startsWith('http')
                        ? Image.network(
                            widget.productImage,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: screenHeight * 0.35,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.error, size: 50),
                          )
                        : Image.asset(
                            widget.productImage,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: screenHeight * 0.35,
                          ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Text(
                    widget.productName,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: screenWidth * 0.05,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.yellow.shade700,
                        size: screenWidth * 0.04,
                      ),
                      Text(
                        ' ${widget.productRating} | ${widget.reviewCount} Reviews',
                        style: TextStyle(
                          fontSize: screenWidth * 0.04,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Text(
                    '₹${widget.productPrice.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: screenWidth * 0.05,
                      color: Colors.green.shade700,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Text(
                    widget.productDescription,
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05,
              vertical: screenHeight * 0.02,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '₹${widget.productPrice.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: screenWidth * 0.05,
                    color: const Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.015,
                      horizontal: screenWidth * 0.1,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(screenWidth * 0.02),
                    ),
                  ),
                  onPressed: () {
                    addToCart(); // Add product to cart
                  },
                  child: const Text(
                    'Add to Cart',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
