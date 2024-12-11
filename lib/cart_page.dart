import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'CartProvider.dart'; // Import CartProvider

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.cartItems;
    final subTotal = cartProvider.calculateSubTotal();
    final shippingFee = cartProvider.calculateShippingFee(subTotal);
    final total = subTotal + shippingFee;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 2,
          centerTitle: true,
          title: Text(
            'My Cart',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: cartItems.isEmpty
            ? Center(child: Text('Your cart is empty!'))
            : Column(
                children: [
                  // Free Shipping Progress
                  Container(
                    padding: EdgeInsets.all(12),
                    color: Colors.orange.shade50,
                    child: Column(
                      children: [
                        Text(
                          'You are ₹60.00 away from FREE shipping.',
                          style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: 0.7, // Example progress
                          color: Colors.orange,
                          backgroundColor: Colors.orange.shade100,
                        ),
                      ],
                    ),
                  ),

                  // Cart Items
                  Expanded(
                    child: ListView.builder(
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        final item = cartItems[index];
                        return Card(
                          margin: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    // Product Image
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        item['image'],
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    SizedBox(width: 12),

                                    // Product Details
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item['name'],
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            '₹${item['price'].toStringAsFixed(2)}',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Quantity Controls
                                    Column(
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.add_circle,
                                              color: Colors.green),
                                          onPressed: () => cartProvider
                                              .updateQuantity(index, 1),
                                        ),
                                        Text('${item['quantity']}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            )),
                                        IconButton(
                                          icon: Icon(Icons.remove_circle,
                                              color: Colors.red),
                                          onPressed: () => cartProvider
                                              .updateQuantity(index, -1),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                // Divider
                                Divider(),
                                Row(
                                  children: [
                                    Icon(Icons.timer,
                                        color: Colors.orange, size: 16),
                                    SizedBox(width: 8),
                                    Text('Limited Time Deal: 1m 39s left',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        )),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Cart Summary and Checkout Button
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, -2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Subtotal', style: TextStyle(fontSize: 16)),
                            Text('₹${subTotal.toStringAsFixed(2)}',
                                style: TextStyle(fontSize: 16)),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Shipping Fee',
                                style: TextStyle(fontSize: 16)),
                            Text('₹${shippingFee.toStringAsFixed(2)}',
                                style: TextStyle(fontSize: 16)),
                          ],
                        ),
                        Divider(height: 24, thickness: 1),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Total',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                )),
                            Text('₹${total.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                )),
                          ],
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Proceeding to Checkout...'),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            backgroundColor: Colors.orange,
                          ),
                          child: Text(
                            'Checkout',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
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
