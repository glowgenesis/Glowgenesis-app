import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:glowgenesis/CartProvider.dart';
import 'package:glowgenesis/api.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductDetailsPage extends StatefulWidget {
  final String productId;

  const ProductDetailsPage({super.key, required this.productId});

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  late Future<Map<String, dynamic>> productDetails;

  @override
  void initState() {
    super.initState();
    productDetails = fetchProductDetails(widget.productId);
  }

  Future<Map<String, dynamic>> fetchProductDetails(String id) async {
    final url = Uri.parse('${Api.backendApi}/products/$id');
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');
    final response = await http.get(
      url,
      headers: {'Authorization': '$token'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['product'];
    } else {
      throw Exception('Failed to load product details');
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartController = Provider.of<CartController>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Product Details"),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: productDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("Product not found"));
          }

          final product = snapshot.data!;
          final isInCart =
              cartController.cartItems.containsKey(product['name']);

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          product['image'] ?? 'assets/images/placeholder.png',
                          height: 250,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.image_not_supported,
                              size: 250,
                              color: Colors.grey,
                            );
                          },
                        ),
                        const SizedBox(height: 10),
                        Text(
                          product['name'] ?? 'No name available',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "₹${product['price'] ?? '0'}",
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.orange,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          product['shortDescription'] ??
                              'No short description available',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          product['longDescription'] ??
                              'No long description available',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Highlights:",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        ...List<Widget>.generate(
                          (product['highlights'] as List<dynamic>?)?.length ??
                              0,
                          (index) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2.0),
                            child: Row(
                              children: [
                                const Icon(Icons.check, color: Colors.green),
                                const SizedBox(width: 5),
                                Expanded(
                                  child: Text(
                                    product['highlights'][index] ?? '',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber),
                            Text("${product['rating'] ?? '0.0'}"),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.grey)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (isInCart) {
                            Navigator.pushNamed(context, '/cart'); // Go to cart
                          } else {
                            cartController.addToCart({
                              'name': product['name'] ?? 'Unknown Product',
                              'price': product['price'] ?? 0,
                              'quantity': 1,
                              'image': product['image']
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              isInCart ? Colors.blue : Colors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: Text(
                          isInCart ? "Go to Cart" : "Add to Cart",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigate to payment or checkout page
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: const Text(
                          "Buy Now",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
