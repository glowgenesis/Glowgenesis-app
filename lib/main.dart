import 'package:flutter/material.dart';
import 'package:glowgenesis/cart_page.dart';
import 'package:glowgenesis/getstarted.dart';
import 'package:provider/provider.dart';
import 'CartProvider.dart'; // Import the CartProvider

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: buildSkincarePage(context),
      routes: {
        '/cart': (context) => CartPage(),
      },
    );
  }
}
