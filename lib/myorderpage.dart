import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:glowgenesis/api.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class MyOrdersPage extends StatefulWidget {
  const MyOrdersPage({super.key});

  @override
  _MyOrdersPageState createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage> {
  List<Order> _orders = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');

    if (email == null) {
      setState(() {
        _errorMessage = 'No email found in preferences';
        _isLoading = false;
      });
      return;
    }

    final url = Uri.parse('${Api.backendApi}/orders/$email');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['orders'];
        setState(() {
          _orders = data.map((order) => Order.fromJson(order)).toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to fetch orders: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        _errorMessage = 'Error: $error';
        _isLoading = false;
      });
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy, hh:mm a').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: _orders.length,
                    itemBuilder: (context, index) {
                      final order = _orders[index];
                      return Card(
                        elevation: 4.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Order #${order.id}',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                'Order Date: ${_formatDate(order.createdAt)}',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 16.0),
                              ...order.productId.map((product) => Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.shopping_cart,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        const SizedBox(width: 8.0),
                                        Expanded(
                                          child: Text(
                                            product.name,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium
                                                ?.copyWith(
                                                    fontWeight:
                                                        FontWeight.w600),
                                          ),
                                        ),
                                        Text(
                                          '₹${product.price}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge,
                                        ),
                                      ],
                                    ),
                                  )),
                              const Divider(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Total: ₹${order.billAmount}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green,
                                        ),
                                  ),
                                  // ElevatedButton(
                                  //   onPressed: () {},
                                  //   style: ElevatedButton.styleFrom(
                                  //     padding: const EdgeInsets.symmetric(
                                  //         horizontal: 16.0, vertical: 10.0),
                                  //     backgroundColor: Colors.blue,
                                  //     shape: RoundedRectangleBorder(
                                  //       borderRadius:
                                  //           BorderRadius.circular(8.0),
                                  //     ),
                                  //   ),
                                  //   child: const Text('View Details'),
                                  // ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}

class Order {
  final String id;
  final List<Product> productId;
  final double billAmount;
  final String email;
  final DateTime createdAt;

  Order({
    required this.id,
    required this.productId,
    required this.billAmount,
    required this.email,
    required this.createdAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    var productsList = (json['productId'] as List)
        .map((item) => Product.fromJson(item))
        .toList();

    return Order(
      id: json['_id'],
      productId: productsList,
      billAmount: json['billAmount'].toDouble(),
      email: json['email'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class Product {
  final String id;
  final String name;
  final double price;
  final String shortDescription;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.shortDescription,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'],
      name: json['name'],
      price: json['price'].toDouble(),
      shortDescription: json['shortDescription'],
    );
  }
}
