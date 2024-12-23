import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:glowgenesis/api.dart';
import 'package:glowgenesis/bottmnavbar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'HomePage.dart';
import 'Login/login.dart';
import 'cart_page.dart';
import 'CartProvider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartController()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  String? _authToken;

  MyApp({super.key});

  String? get authToken => _authToken;

  Future<void> loadAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    _authToken = prefs.getString('authToken');
  }

  // Check if the token is valid
  Future<void> validateToken(BuildContext context) async {
    if (_authToken != null) {
      try {
        final response = await http.post(
          Uri.parse('${Api.backendApi}/token-validate'), // Update the URL
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $_authToken', // Correctly add Bearer
          },
        );

        if (response.statusCode == 200) {
          final responseData = json.decode(response.body);

          if (responseData['message'] == 'Token is valid') {
            // Token is valid, do nothing and notify listeners
            return;
          } else {
            await _clearAuthToken();
            Navigator.pushReplacementNamed(context, '/login');
          }
        } else {
          await _clearAuthToken();
          Navigator.pushReplacementNamed(context, '/login');
        }
      } catch (e) {
        // Handle network or server errors
        print('Error validating token: $e');
        await _clearAuthToken();
        Navigator.pushReplacementNamed(context, '/login');
      }
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  // Clear auth token and navigate to login
  Future<void> _clearAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('authToken');
  }

  // Set new auth token after login
  Future<void> setAuthToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('authToken', token);
    _authToken = token;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(), // Start with the splash screen
      routes: {
        '/login': (context) => LoginPage(),
        '/cart': (context) => CartPage(),
        '/home': (context) => MainNavigation(),
      },
    );
  }
}
