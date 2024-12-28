// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:glowgenesis/HomePage.dart';
// import 'package:provider/provider.dart';
// import 'package:glowgenesis/cart_page.dart';
// import 'CartProvider.dart';
// import 'Account.dart';

// class MainNavigation extends StatefulWidget {
//   const MainNavigation({super.key});

//   @override
//   _MainNavigationState createState() => _MainNavigationState();
// }

// class _MainNavigationState extends State<MainNavigation> {
//   int _selectedIndex = 0;

//   final List<Widget> _pages = [
//     HomePage(),
//     // SavedPage(
//     //   likedProducts: [],
//     // ),
//     CartPage(),
//     AccountPage(),
//   ];

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _pages[_selectedIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         showUnselectedLabels: true,
//         type: BottomNavigationBarType.fixed,
//         items: [
//           const BottomNavigationBarItem(
//               icon: Icon(FontAwesomeIcons.home), label: 'Home'),
//           // const BottomNavigationBarItem(
//           //     icon: Icon(FontAwesomeIcons.solidHeart), label: 'Saved'),
//           BottomNavigationBarItem(
//             icon: Stack(
//               clipBehavior: Clip.none,
//               children: [
//                 const Icon(FontAwesomeIcons.shoppingCart),
//                 Positioned(
//                   top: -5, // Adjusts the vertical position
//                   right: -10, // Adjusts the horizontal position
//                   child: Consumer<CartController>(
//                     builder: (context, cartController, _) {
//                       int? cartItemCount = cartController.cartItems.length;
//                       return cartItemCount > 0
//                           ? Container(
//                               padding: const EdgeInsets.all(4.0),
//                               decoration: const BoxDecoration(
//                                 color: Colors.red,
//                                 shape: BoxShape.circle,
//                               ),
//                               child: Text(
//                                 '$cartItemCount',
//                                 style: const TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 10,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             )
//                           : const SizedBox.shrink();
//                     },
//                   ),
//                 ),
//               ],
//             ),
//             label: 'Cart',
//           ),
//           const BottomNavigationBarItem(
//               icon: Icon(FontAwesomeIcons.user), label: 'Account'),
//         ],
//         currentIndex: _selectedIndex,
//         selectedItemColor: Colors.black,
//         unselectedItemColor: Colors.grey,
//         backgroundColor: Colors.white,
//         onTap: _onItemTapped,
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:glowgenesis/HomePage.dart';
import 'package:glowgenesis/api.dart';
import 'package:provider/provider.dart';
import 'package:glowgenesis/cart_page.dart';
import 'CartProvider.dart';
import 'Account.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    // SavedPage(
    //   likedProducts: [],
    // ),
    CartPage(),
    AccountPage(),
  ];

  Future<bool> _isTokenValid(BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString('authToken');

      if (authToken == null) {
        return false; // Token is missing
      }

      final response = await http.post(
        Uri.parse(
            '${Api.backendApi}/token-validate'), // Replace with your API URL
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );
      print(response.body);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData['message'] ==
            'Token validated'; // Updated condition
      }
    } catch (e) {
      print('Error validating token: $e');
    }

    return false; // Default to invalid token
  }

  void _onItemTapped(int index) async {
    if (index == 1) {
      // Cart tab
      bool isValidToken = await _isTokenValid(context);
      if (isValidToken) {
        setState(() {
          _selectedIndex = index;
        });
      } else {
        Navigator.pushReplacementNamed(context, '/login');
      }
    } else if (index == 2) {
      // Account tab
      bool isValidToken = await _isTokenValid(context);
      if (isValidToken) {
        setState(() {
          _selectedIndex = index;
        });
      } else {
        Navigator.pushReplacementNamed(context, '/login');
      }
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: [
          const BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.home), label: 'Home'),
          // const BottomNavigationBarItem(
          //     icon: Icon(FontAwesomeIcons.solidHeart), label: 'Saved'),
          BottomNavigationBarItem(
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(FontAwesomeIcons.shoppingCart),
                Positioned(
                  top: -5, // Adjusts the vertical position
                  right: -10, // Adjusts the horizontal position
                  child: Consumer<CartController>(
                      builder: (context, cartController, _) {
                    int cartItemCount = cartController.cartItems.length;
                    return cartItemCount > 0
                        ? Container(
                            padding: const EdgeInsets.all(4.0),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '$cartItemCount',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        : const SizedBox.shrink();
                  }),
                ),
              ],
            ),
            label: 'Cart',
          ),
          const BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.user), label: 'Account'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }
}
