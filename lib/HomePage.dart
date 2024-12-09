import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:glowgenesis/BottomCartStrip.dart';
import 'package:glowgenesis/ProductCard.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // cartCount defined inside HomePage as a static ValueNotifier
  static ValueNotifier<int> cartCount = ValueNotifier<int>(0);

  final List<Map<String, dynamic>> products = [
    {
      "name": "Sunscreen Cream SPF 50 PA+++",
      "category": "UV Protection",
      "description":
          "Protects from harmful UV rays | Lightweight & Non-Greasy | Hydrates Skin",
      "rating": 4.9,
      "reviews": 512,
      "price": 499,
      "image": "assets/antiacne.png",
    },
    {
      "name": "Aloe Vera Gel - 200ml",
      "category": "Hydration & Soothing",
      "description":
          "Soothes skin irritation | Hydrates & Nourishes | Multipurpose Gel",
      "rating": 4.8,
      "reviews": 420,
      "price": 299,
      "image": "assets/antiacne.png",
    },
    {
      "name": "Vitamin C Face Wash",
      "category": "Brightening & Refreshing",
      "description":
          "Boosts skin radiance | Gently exfoliates | Removes impurities",
      "rating": 4.7,
      "reviews": 375,
      "price": 399,
      "image": "assets/antiacne.png",
    },
    {
      "name": "Body Moisturizer - Cocoa Butter",
      "category": "Deep Nourishment",
      "description":
          "Intensely moisturizes | Smoothens rough skin | Long-lasting hydration",
      "rating": 4.85,
      "reviews": 268,
      "price": 349,
      "image": "assets/antiacne.png",
    },
    {
      "name": "Anti Acne Face Wash",
      "category": "Acne & Pimples",
      "description":
          "Clears acne & pimples | Deeply cleanses | Unclogs pores effectively",
      "rating": 4.75,
      "reviews": 415,
      "price": 399,
      "image": "assets/antiacne.png",
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
      totalCartItems += prefs.getInt(key) ?? 0;
    });

    cartCount.value = totalCartItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        
        title: Image.asset('assets/logo.png', height: 30),
        actions: [
          Icon(Icons.person, color: Colors.black),
          SizedBox(width: 10),
          Icon(Icons.menu, color: Colors.black),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search Bar
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search',
                      prefixIcon: Icon(Icons.search),
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
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      'assets/Offers/offers.jpg',
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Product Grid
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: products.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.515,
                    ),
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return ProductCard(
                        name: product["name"],
                        category: product["category"],
                        description: product["description"],
                        rating: product["rating"],
                        reviews: product["reviews"],
                        price: product["price"],
                        imagePath: product["image"],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0, // Place the BottomCartStrip at the bottom
            child: ValueListenableBuilder<int>(
              valueListenable: cartCount,
              builder: (context, count, child) {
                return count > 0 ? BottomCartStrip() : SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
