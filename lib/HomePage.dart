import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:glowgenesis/account.dart';
import 'package:glowgenesis/cart_page.dart';
import 'ProductDetailsPage.dart';
import 'SavedPage.dart';
import 'SearchPage.dart';

class Homepage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<Homepage> {
  int _selectedIndex = 0;
  List<Map<String, dynamic>> likedProducts = []; // List to store liked products

  final List<String> productImages = [
    'assets/anti acne face wash 2.png',
    'assets/anti acne face wash 3.jpg',
    'assets/anti acne face wash 4.jpg',
    'assets/anti acne face wash.jpg',
    'assets/body moisturizer 2.jpg',
    'assets/body moisturizer.jpg',
  ];

  final List<String> productNames = [
    'Anti Acne Face Wash',
    'Anti Acne Face Wash',
    'Anti Acne Face Wash',
    'Anti Acne Face Wash',
    'Body Moisturizer',
    'Body Moisturizer',
  ];

  final List<String> productDescriptions = [
    'A gentle face wash that helps clear acne and maintain skin moisture balance.',
    'Another variant of anti-acne face wash with added vitamins.',
    'This face wash fights acne and nourishes the skin.',
    'Helps cleanse and hydrate the skin, reducing acne.',
    'Moisturizer to keep your body hydrated and smooth.',
    'Lightweight moisturizer with nourishing ingredients.',
  ];

  final List<double> productPrices = [
    1190.0,
    1250.0,
    990.0,
    1090.0,
    850.0,
    800.0,
  ];

  final List<double> productRatings = [
    4.0,
    4.5,
    3.8,
    4.2,
    4.0,
    4.1,
  ];

  final List<int> reviewCounts = [
    45,
    30,
    50,
    60,
    40,
    38,
  ];

  // Function to toggle the liked state of a product
  void _toggleLike(int index) {
    setState(() {
      if (likedProducts
          .any((product) => product['name'] == productNames[index])) {
        // If product is already liked, remove it from the list
        likedProducts
            .removeWhere((product) => product['name'] == productNames[index]);
      } else {
        // If product is not liked, add it to the list
        likedProducts.add({
          'name': productNames[index],
          'image': productImages[index],
          'price': productPrices[index],
        });
      }
    });
  }

  void _onItemTapped(int index) {
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SearchPage()),
      );
    } else if (index == 2) {
      // Pass the liked products to SavedPage
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SavedPage(likedProducts: likedProducts),
        ),
      );
    } else if (index == 3) {
      // Navigate to the CartPage when the cart button is clicked
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CartPage(),
        ),
      );
    } else if (index == 4) {
      // Navigate to the CartPage when the cart button is clicked
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AccountPage(),
        ),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Discover',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 40)),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(FontAwesomeIcons.solidBell, size: 30),
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(screenWidth * 0.04),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(FontAwesomeIcons.search),
                      hintText: 'Search for clothes...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(screenWidth * 0.03),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: screenWidth * 0.02),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(Icons.tune),
                    onPressed: () {},
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: screenWidth > 600 ? 3 : 2,
                childAspectRatio: screenWidth / (screenHeight / 1.5),
                crossAxisSpacing: screenWidth * 0.02,
                mainAxisSpacing: screenHeight * 0.02,
              ),
              itemCount: productImages.length,
              itemBuilder: (context, index) {
                bool isLiked = likedProducts
                    .any((product) => product['name'] == productNames[index]);

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailsPage(
                          productName: productNames[index],
                          productImage: productImages[index],
                          productDescription: productDescriptions[index],
                          productPrice: productPrices[index],
                          productRating: productRatings[index],
                          reviewCount: reviewCounts[index],
                          isLiked: isLiked,
                          toggleLike: () => _toggleLike(index),
                        ),
                      ),
                    );
                  },
                  child: _buildProductCard(
                      screenWidth, screenHeight, index, isLiked),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.solidHeart),
            label: 'Saved',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.shoppingCart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.user),
            label: 'Account',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildProductCard(
      double screenWidth, double screenHeight, int index, bool isLiked) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(screenWidth * 0.03),
      ),
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(screenWidth * 0.03),
              ),
              child: Image.asset(
                productImages[index],
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(screenWidth * 0.02),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productNames[index],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth * 0.04,
                  ),
                ),
                Text(
                  '\₹${productPrices[index]}',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: screenWidth * 0.035,
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
