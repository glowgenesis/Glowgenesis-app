import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:glowgenesis/BottomCartStrip.dart';
import 'package:glowgenesis/ProductCard.dart';
import 'package:carousel_slider/carousel_slider.dart';

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
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> products = [
    {
      "id": "676ef6d2ea05f868a64aef43",
      "name": "Body Moisturizer",
      "category": "Deep Nourishment",
      "description":
          "Intensely moisturizes | Smoothens rough skin | Long-lasting hydration",
      "rating": 0,
      "reviews": 0,
      "price": 289,
      "image": "assets/images/moisturizer.png",
    },
    {
      "id": "676ef697ea05f868a64aef41",
      "name": "Anti Acne Face Wash",
      "category": "Acne & Pimples",
      "description":
          "Clears acne & pimples | Deeply cleanses | Unclogs pores effectively",
      "rating": 0,
      "reviews": 0,
      "price": 195,
      "image": "assets/images/Anitacne.jpeg",
    },
    {
      "id": "676ef6f7ddaae5af90acd4f1",
      "name": "Sunscreen Cream SPF 50",
      "category": "UV Protection",
      "description":
          "Protects from harmful UV rays | Lightweight & Non-Greasy | Hydrates Skin",
      "rating": 0,
      "reviews": 0,
      "price": 0,
      "image": "assets/images/sunscreen.jpeg",
    },
    {
      "id": "676ef6e9ea05f868a64aef47",
      "name": "Aloe Vera Gel - 200ml",
      "category": "Hydration & Soothing",
      "description":
          "Soothes skin irritation | Hydrates & Nourishes | Multipurpose Gel",
      "rating": 0,
      "reviews": 0,
      "price": 0,
      "image": "assets/images/aloeveragel.jpeg",
    },
    {
      "id": "676ef6dfea05f868a64aef45",
      "name": "Vitamin C Face Wash",
      "category": "Brightening & Refreshing",
      "description":
          "Boosts skin radiance | Gently exfoliates | Removes impurities",
      "rating": 0,
      "reviews": 0,
      "price": 0,
      "image": "assets/images/vitaminc.jpeg",
    },
  ];

  List<Map<String, dynamic>> filteredProducts = [];

  @override
  void initState() {
    super.initState();
    _loadCartCount();
    filteredProducts = products; // Initialize filtered products
    _searchController.addListener(_filterProducts);
  }

  void _filterProducts() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      filteredProducts = products
          .where((product) => product["name"].toLowerCase().contains(query))
          .toList();
    });
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
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            SizedBox(
              height: 50, // Specify the desired height for the logo
              width:
                  50, // Optional: Specify width to control the logo size further
              child: Image.asset(
                'assets/Glowgenesislogo.png',
                fit: BoxFit
                    .contain, // Adjusts the image to fit within the box while maintaining aspect ratio
              ),
            ),
            if (_isSearching)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextField(
                    controller: _searchController,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      hintStyle: TextStyle(color: Colors.grey[600]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isSearching ? Icons.close : Icons.search,
              color: Colors.black,
            ),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  filteredProducts = products; // Reset the filter
                }
              });
            },
          ),
          const SizedBox(width: 14),
        ],
      ),
      body: Stack(
        children: [
          ValueListenableBuilder<int>(
            valueListenable: cartCount,
            builder: (context, count, child) {
              double bottomPadding = count > 0 ? 50 : 0;

              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(bottom: bottomPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Search Bar
                      // Padding(
                      //   padding: const EdgeInsets.all(10.0),
                      //   child: TextField(
                      //     decoration: InputDecoration(
                      //       hintText: 'Search',
                      //       prefixIcon: const Icon(Icons.search),
                      //       border: OutlineInputBorder(
                      //         borderRadius: BorderRadius.circular(30),
                      //       ),
                      //       filled: true,
                      //       fillColor: Colors.grey[200],
                      //     ),
                      //   ),
                      // ),
                      // Auto-Sliding Banners
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: CarouselSlider(
                          options: CarouselOptions(
                            height: 200,
                            autoPlay: true,
                            autoPlayInterval: const Duration(seconds: 3),
                            autoPlayAnimationDuration:
                                const Duration(milliseconds: 800),
                            enlargeCenterPage: true,
                            viewportFraction: 1.0,
                            aspectRatio: 16 / 9,
                          ),
                          items: [
                            'assets/Offers/sale50-2.jpg',
                            'assets/Offers/sale50-3.jpg', // Add more images as needed
                            'assets/Offers/sale50-1.jpg',
                          ].map((imagePath) {
                            return Builder(
                              builder: (BuildContext context) {
                                return Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 5.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    image: DecorationImage(
                                      image: AssetImage(imagePath),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              },
                            );
                          }).toList(),
                        ),
                      ),
                      // Products Grid
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            double itemWidth = 160;
                            int itemsPerRow =
                                (constraints.maxWidth / itemWidth).floor();

                            itemsPerRow = itemsPerRow > 0 ? itemsPerRow : 1;

                            double calculatedWidth = (constraints.maxWidth -
                                    (10 * (itemsPerRow - 1))) /
                                itemsPerRow;

                            return Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              alignment: WrapAlignment.start,
                              children: filteredProducts.map((product) {
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
