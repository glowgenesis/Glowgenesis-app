import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:glowgenesis/BottomCartStrip.dart';
import 'package:glowgenesis/ProductCard.dart';

class CartNotifier {
  static final ValueNotifier<int> cartCount = ValueNotifier<int>(0);
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // cartCount defined inside HomePage as a static ValueNotifier
  static ValueNotifier<int> cartCount = ValueNotifier<int>(0);

  final List<Map<String, dynamic>> products = [
    {
      "id": "676ef6d2ea05f868a64aef43",
      "name": "Body Moisturizer",
      "category": "Deep Nourishment",
      "description":
          "Intensely moisturizes | Smoothens rough skin | Long-lasting hydration",
      "rating": 4.85,
      "reviews": 268,
      "price": 289,
      "image": "assets/images/moisturizer.png",
    },
    {
      "id": "676ef697ea05f868a64aef41",
      "name": "Anti Acne Face Wash",
      "category": "Acne & Pimples",
      "description":
          "Clears acne & pimples | Deeply cleanses | Unclogs pores effectively",
      "rating": 4.75,
      "reviews": 415,
      "price": 195,
      "image": "assets/images/Anitacne.jpeg",
    },
    {
      "id": "676ef6f7ddaae5af90acd4f1",
      "name": "Sunscreen Cream SPF 50",
      "category": "UV Protection",
      "description":
          "Protects from harmful UV rays | Lightweight & Non-Greasy | Hydrates Skin",
      "rating": 4.9,
      "reviews": 512,
      "price": 0,
      "image": "assets/images/sunscreen.jpeg",
    },
    {
      "id": "676ef6e9ea05f868a64aef47",
      "name": "Aloe Vera Gel - 200ml",
      "category": "Hydration & Soothing",
      "description":
          "Soothes skin irritation | Hydrates & Nourishes | Multipurpose Gel",
      "rating": 4.8,
      "reviews": 420,
      "price": 0,
      "image": "assets/images/aloeveragel.jpeg",
    },
    {
      "id": "676ef6dfea05f868a64aef45",
      "name": "Vitamin C Face Wash",
      "category": "Brightening & Refreshing",
      "description":
          "Boosts skin radiance | Gently exfoliates | Removes impurities",
      "rating": 4.7,
      "reviews": 375,
      "price": 0,
      "image": "assets/images/vitaminc.jpeg",
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadCartCount();
  }

  Future<void> _loadCartCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int totalCartItems = 0;

    // Calculate total cart count from SharedPreferences
    prefs.getKeys().forEach((key) {
      // Only add to totalCartItems if the value is an integer
      if (prefs.get(key) is int) {
        totalCartItems += prefs.getInt(key) ?? 0;
      }
    });

    cartCount.value = totalCartItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false, // This removes the back button
        title: Image.asset('assets/logo.png', height: 30),
        actions: const [
          Icon(Icons.menu, color: Colors.black),
          SizedBox(width: 14),
        ],
      ),
      body: Stack(
        children: [
          ValueListenableBuilder<int>(
            valueListenable: cartCount,
            builder: (context, count, child) {
              // Calculate bottom padding dynamically based on BottomCartStrip visibility
              double bottomPadding = count > 0 ? 50 : 0;

              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(bottom: bottomPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Search Bar
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search',
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            filled: true,
                            fillColor: Colors.grey[200],
                          ),
                        ),
                      ),
                      // Banner
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            double itemWidth = 160;
                            int itemsPerRow =
                                (constraints.maxWidth / itemWidth).floor();

                            // Ensure at least one item per row
                            itemsPerRow = itemsPerRow > 0 ? itemsPerRow : 1;

                            double calculatedWidth = (constraints.maxWidth -
                                    (10 * (itemsPerRow - 1))) /
                                itemsPerRow;

                            return Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              alignment: WrapAlignment.start,
                              children: products.map((product) {
                                return SizedBox(
                                  width: calculatedWidth,
                                  child: ProductCard(
                                    id: product["id"],
                                    name: product["name"],
                                    category: product["category"],
                                    description: product["description"],
                                    rating: product["rating"],
                                    reviews: product["reviews"],
                                    price: product["price"],
                                    imagePath: product["image"],
                                  ),
                                );
                              }).toList(),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0, // Place the BottomCartStrip at the bottom
            child: ValueListenableBuilder<int>(
              valueListenable: cartCount,
              builder: (context, count, child) {
                return count > 0 ? BottomCartStrip() : const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
