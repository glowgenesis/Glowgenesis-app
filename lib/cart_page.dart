import 'dart:convert';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:glowgenesis/address/address.dart';
import 'package:glowgenesis/api.dart';
import 'package:glowgenesis/razorpay_web.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:glowgenesis/CartProvider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';

import 'package:slider_button/slider_button.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  Map<String, dynamic>? address;
  bool isPaymentInProgress = false;
  @override
  void initState() {
    super.initState();
    fetchUserAddress();
    _loadCartFromPrefs();
  }

  Future<void> _loadCartFromPrefs() async {
    final cartController = Provider.of<CartController>(context, listen: false);
    await cartController.loadCartFromPreferences(); // Load cart into controller
  }

  void setPaymentProgressIfAddressIsNull() {
    setState(() {
      if (address == null) {
        isPaymentInProgress = true;
      } else {
        isPaymentInProgress = false;
      }
    });
  }

  Future<void> placeOrder(
      {required List<String> productIds, required double billAmount}) async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    final url = Uri.parse(
        '${Api.backendApi}/order'); // Replace with your actual API URL

    try {
      // Create the body for the POST request
      final body = json.encode({
        'productId': productIds,
        'billAmount': billAmount,
        'email': email,
      });

      // Set the headers for the request
      final headers = {
        'Content-Type': 'application/json',
      };

      // Make the POST request
      final response = await http.post(url, body: body, headers: headers);

      if (response.statusCode == 201) {
        // Order placed successfully
        print('Order placed successfully!');
        final responseData = json.decode(response.body);
        print('Order Data: ${responseData['order']}');
      } else {
        // Something went wrong
        print('Failed to place order. Status code: ${response.statusCode}');
        print('Error: ${response.body}');
      }
    } catch (error) {
      print('Error placing order: $error');
    }
  }

  Future<Map<String, dynamic>> fetchUserAddress() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    final url = Uri.parse(
        '${Api.backendApi}/user/address'); // Replace with your actual API URL

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({'email': email}),
      );

      print(response.body);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        setState(() {
          address = data['address']; // Store the fetched address
        });

        if (data['success'] == true) {
          return {'success': true, 'address': data['address']};
        } else {
          return {'success': false, 'message': data['message']};
        }
      } else {
        setPaymentProgressIfAddressIsNull();
        print(isPaymentInProgress);
        return {
          'success': false,
          'message':
              'Failed to fetch address. HTTP Status: ${response.statusCode}'
        };
      }
    } catch (error) {
      return {'success': false, 'message': 'Error: $error'};
    }
  }

  Future<Map<String, dynamic>> createOrder(
      int amount, String currency, String receipt) async {
    final response = await http.post(
      Uri.parse('${Api.backendApi}/create-order'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'amount': amount,
        'currency': currency,
        'receipt': receipt,
      }),
    );

    print('Response Status: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      if (responseData['success'] == true) {
        return responseData['order']; // Return the order object
      } else {
        throw Exception('Order creation failed: ${responseData['message']}');
      }
    } else {
      throw Exception('Failed to create order: ${response.body}');
    }
  }

  Future<bool> verifyPayment(
      String orderId, String paymentId, String signature) async {
    final response = await http.post(
      Uri.parse('${Api.backendApi}/verify-payment'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'razorpay_order_id': orderId,
        'razorpay_payment_id': paymentId,
        'razorpay_signature': signature,
      }),
    );

    print(response.body);

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to verify payment: ${response.body}');
    }
  }

  void _refreshAddressList() {
    // Call the API to get updated address list or refresh local data
    setState(() {
      // Update state here to refresh the page, e.g., loading new addresses
      fetchUserAddress();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartController = Provider.of<CartController>(context);
    final cartItems = cartController.cartItems.values.toList();
    final subTotal = cartItems.fold<double>(
      0.0,
      (sum, item) => sum + (item['price'] * item['quantity']),
    );
    final shippingFee = subTotal > 500 ? 0.0 : 50.0;
    final total = subTotal + shippingFee;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 2,
          centerTitle: true,
          title: const Text(
            'My Cart',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios, // iOS-style back button
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/home');
            },
          ),
        ),
        body: cartItems.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.shopping_cart_outlined,
                      size: 80,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Your cart is empty!',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/home');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 24),
                      ),
                      child: const Text('Start Shopping'),
                    ),
                  ],
                ),
              )
            : Column(
                children: [
                  // Address Section
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(
                        top: 12,
                        left: 16,
                        right: 16,
                        bottom: 4), // Adjusted margin
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: address != null && address!.isNotEmpty
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Deliver to:',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      // Navigate to edit address screen
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              AddDeliveryAddressPage(),
                                        ),
                                      ).then((refresh) {
                                        if (refresh != null &&
                                            refresh == true) {
                                          // Trigger refresh or re-initialization of the previous page
                                          _refreshAddressList();
                                        }
                                      });
                                    },
                                    child: const Text(
                                      'Change',
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                "${address!['fullName']}\n${address!['houseDetails']}, ${address!['roadDetails']}, ${address!['landmark']}, ${address!['city']}, ${address!['state']} - ${address!['pincode']}\n${address!['phoneNumber']}",
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          )
                        : Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                'No delivery address added.',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  // Navigate to add address screen
                                  Navigator.pushNamed(context, '/add-address');
                                },
                                icon: const Icon(
                                  Icons.add,
                                  color: Colors.blue,
                                ),
                                tooltip: 'Add Address',
                              ),
                            ],
                          ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 4), // Reduced vertical margin
                    child: Column(
                      children: [
                        Text(
                          subTotal >= 500
                              ? 'You have unlocked FREE shipping!'
                              : 'Spend ₹${(500 - subTotal).clamp(0, 500).toStringAsFixed(2)} more for FREE shipping.',
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: (subTotal / 500).clamp(0, 1),
                          color: subTotal >= 500 ? Colors.green : Colors.orange,
                          backgroundColor: Colors.orange.shade100,
                        ),
                      ],
                    ),
                  ),

                  // Cart Items
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(8),
                      children: [
                        // Cart Items
                        ...cartItems.map((item) {
                          return Dismissible(
                            key: Key(item['name'] ?? ''),
                            direction: DismissDirection.endToStart,
                            onDismissed: (_) {
                              cartController.removeFromCart(item['name'] ?? '');
                            },
                            background: Container(
                              alignment: Alignment.centerRight,
                              color: Colors.red,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child:
                                  const Icon(Icons.delete, color: Colors.white),
                            ),
                            child: Card(
                              elevation: 4,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  children: [
                                    // Product Image
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: item['image'] != null &&
                                              item['image'].isNotEmpty
                                          ? Image.asset(
                                              item['image'],
                                              width: 80,
                                              height: 80,
                                              fit: BoxFit.cover,
                                            )
                                          : Container(
                                              width: 80,
                                              height: 80,
                                              color: Colors.grey.shade200,
                                              child: const Icon(
                                                Icons.image_not_supported,
                                                size: 40,
                                                color: Colors.grey,
                                              ),
                                            ),
                                    ),
                                    const SizedBox(width: 12),

                                    // Product Details
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item['name'] ?? 'Unknown Product',
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '₹${(item['price'] ?? 0).toStringAsFixed(2)}',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Quantity Controls
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.remove_circle,
                                              color: Colors.red),
                                          onPressed: () =>
                                              cartController.updateQuantity(
                                                  item['name'] ?? '',
                                                  (item['quantity'] ?? 0) - 1),
                                        ),
                                        Text('${item['quantity'] ?? 0}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            )),
                                        IconButton(
                                          icon: const Icon(Icons.add_circle,
                                              color: Colors.green),
                                          onPressed: () =>
                                              cartController.addToCart({
                                            ...item,
                                            'quantity': 1,
                                          }),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),

                        // Summary Section
                        Container(
                          padding: const EdgeInsets.all(
                              16), // Padding for the entire summary section
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment
                                .start, // Align text to the start
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Subtotal',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    '₹${subTotal.toStringAsFixed(2)}',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Shipping Fee',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    shippingFee == 0
                                        ? 'FREE'
                                        : '₹${shippingFee.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: shippingFee == 0
                                          ? Colors.green
                                          : Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(
                                  height: 24,
                                  thickness: 1), // Separator for clarity
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Total',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '₹${total.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // // Summary Section
                  // Container(
                  //   padding: const EdgeInsets.all(
                  //       16), // Padding for the entire summary section
                  //   margin:
                  //       const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  //   decoration: BoxDecoration(
                  //     color: Colors.white,
                  //     borderRadius: BorderRadius.circular(8),
                  //     boxShadow: [
                  //       BoxShadow(
                  //         color: Colors.black12,
                  //         blurRadius: 6,
                  //         offset: const Offset(0, 2),
                  //       ),
                  //     ],
                  //   ),
                  //   child: Column(
                  //     crossAxisAlignment:
                  //         CrossAxisAlignment.start, // Align text to the start
                  //     children: [
                  //       Row(
                  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //         children: [
                  //           const Text(
                  //             'Subtotal',
                  //             style: TextStyle(fontSize: 16),
                  //           ),
                  //           Text(
                  //             '₹${subTotal.toStringAsFixed(2)}',
                  //             style: const TextStyle(fontSize: 16),
                  //           ),
                  //         ],
                  //       ),
                  //       const SizedBox(height: 8),
                  //       Row(
                  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //         children: [
                  //           const Text(
                  //             'Shipping Fee',
                  //             style: TextStyle(fontSize: 16),
                  //           ),
                  //           Text(
                  //             shippingFee == 0
                  //                 ? 'FREE'
                  //                 : '₹${shippingFee.toStringAsFixed(2)}',
                  //             style: TextStyle(
                  //               fontSize: 16,
                  //               color: shippingFee == 0
                  //                   ? Colors.green
                  //                   : Colors.black,
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //       const Divider(
                  //           height: 24, thickness: 1), // Separator for clarity
                  //       Row(
                  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //         children: [
                  //           const Text(
                  //             'Total',
                  //             style: TextStyle(
                  //               fontSize: 18,
                  //               fontWeight: FontWeight.bold,
                  //             ),
                  //           ),
                  //           Text(
                  //             '₹${total.toStringAsFixed(2)}',
                  //             style: const TextStyle(
                  //               fontSize: 18,
                  //               fontWeight: FontWeight.bold,
                  //               color: Colors.green,
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ],
                  //   ),
                  // ),

                  // SliderButton for Slide to Checkout
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: SliderButton(
                        action: () async {
                          try {
                            // Check if the address is null
                            if (address == null) {
                              ElegantNotification.error(
                                title: Text('Warning!'),
                                description: Text('Add adress to proceed!'),
                              ).show(context);
                              return;
                            }

                            double totalInRupees =
                                total ?? 0.0; // Ensure `total` is not null

                            if (totalInRupees <= 0) {
                              ElegantNotification.error(
                                title: Text('Warning!'),
                                description: Text('Invalid payment amount.!'),
                              ).show(context);
                              return;
                            }

                            // Step 1: Create Order
                            final order = await createOrder(
                              (totalInRupees * 100).toInt(), // Convert to paise
                              'INR',
                              'receipt_${DateTime.now().millisecondsSinceEpoch}',
                            );

                            if (order == null ||
                                !order.containsKey('id') ||
                                !order.containsKey('amount')) {
                              ElegantNotification.error(
                                title: Text('Error!'),
                                description: Text('Failed to create order.'),
                              ).show(context);
                              return;
                            }

                            // Step 2: Open Razorpay Checkout
                            RazorpayHelper.openCheckout(
                              apiKey: order['key_id'] ?? '',
                              amount: order['amount']?.toString() ??
                                  "0", // Default to "0" if null
                              currency: order['currency'] ??
                                  'INR', // Default to 'INR'
                              name: "Glowgenesis",
                              description: "Payment for Order",
                              orderId:
                                  order['id'] ?? '', // Default to empty string
                              onSuccess: (paymentId, signatureId) async {
                                print(
                                    "Payment Successful. Payment ID: $paymentId");
                                bool isVerified = await verifyPayment(
                                  order['id'] ?? '',
                                  paymentId,
                                  signatureId,
                                );
                                if (isVerified) {
                                  ElegantNotification.success(
                                    // title: Text('Success!'),
                                    description:
                                        Text('Order Placed Successfully'),
                                  ).show(context);
                                  final productIds = List<String>.from(
                                    cartItems.map(
                                        (item) => item['productId'] as String),
                                  );

                                  final dborder = placeOrder(
                                      productIds:
                                          productIds, // List<String> of productIds
                                      billAmount:
                                          totalInRupees // billAmount as a double (no need to cast to List<String>)
                                      );
                                  if (dborder == null) {
                                    ElegantNotification.error(
                                      title: Text('Error!'),
                                      description:
                                          Text('Failed to create order.'),
                                    ).show(context);
                                    return;
                                  }

                                  cartController.clearCart();
                                  cartController.clearCartFromPreferences();
                                  Navigator.pushReplacementNamed(
                                      context, '/home');
                                } else {
                                  // Payment verification failed

                                  ElegantNotification.error(
                                    title: Text('Error!'),
                                    description: Text('Failed to Place order.'),
                                  ).show(context);
                                }
                              },
                              onFailure: (error) {
                                print("Payment Failed. Error: $error");
                              },
                            );
                          } catch (e) {
                            // Handle general errors

                            print(e.toString());
                          }
                        },
                        label: !isPaymentInProgress
                            ? Text(
                                'Slide to Pay',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : Text(
                                'Add  Address to pay',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                        icon: const Icon(
                          Icons.payment,
                          color: Colors.white,
                        ),
                        buttonColor: Colors.orange,
                        backgroundColor: Colors.grey.shade400,
                        highlightedColor: Colors.green,
                        disable: isPaymentInProgress,
                      ),
                    ),
                  ),

                  // Cart Summary and Checkout Button
                  // Container(
                  //   padding: const EdgeInsets.all(16),
                  //   decoration: const BoxDecoration(
                  //     color: Colors.white,
                  //     borderRadius: BorderRadius.vertical(
                  //       top: Radius.circular(16),
                  //     ),
                  //     boxShadow: [
                  //       BoxShadow(
                  //         color: Colors.black12,
                  //         blurRadius: 8,
                  //         offset: Offset(0, -2),
                  //       ),
                  //     ],
                  //   ),
                  //   child:
                  // ),
                ],
              ),
      ),
    );
  }
}
