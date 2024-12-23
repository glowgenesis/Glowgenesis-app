import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthToken();
  }

  Future<void> _checkAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');

    if (token != null) {
      try {
        // Validate the token with the backend
        final response = await http.post(
          Uri.parse(
              'http://localhost:5000/route/validateToken'), // Update the URL
          headers: {
            'Content-Type': 'application/json',
            'Authorization': token,
          },
        );

        if (response.statusCode == 200) {
          // Parse response if needed
          final responseData = json.decode(response.body);
          print(response.body);

          if (responseData['message'] == 'Token is valid') {
            // Token is valid, navigate to home
            Navigator.pushReplacementNamed(context, '/home');
          } else {
            // Unexpected message, treat as invalid token
            await _clearAuthTokenAndRedirect();
          }
        } else {
          // Invalid token or other server error
          await _clearAuthTokenAndRedirect();
        }
      } catch (e) {
        // Handle network or server errors
        print('Error validating token: $e');
        await _clearAuthTokenAndRedirect();
      }
    } else {
      // No token, navigate to login
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  Future<void> _clearAuthTokenAndRedirect() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('authToken');
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(), // Show a loading spinner
      ),
    );
  }
}
