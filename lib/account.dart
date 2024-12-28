import 'package:flutter/material.dart';
import 'package:glowgenesis/api.dart';
import 'package:glowgenesis/bottmnavbar.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'mydetailspage.dart';
import 'myorderpage.dart';
import 'addresspage.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  Map<String, dynamic>? userDetails;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchUserDetails();
    _isTokenValid(context);
  }

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

  Future<void> fetchUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    final url =
        '${Api.backendApi}/user/details'; // Replace with your actual API URL

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode({'email': email}),
      );
      print(response.body);
      if (response.statusCode == 200) {
        setState(() {
          userDetails = json.decode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load user details.';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'An error occurred: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Add notification functionality here
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(child: Text(errorMessage!))
              : ListView(
                  children: [
                    if (userDetails?['user']?['address']?['fullName'] != null)
                      ListTile(
                        leading: const Icon(Icons.person),
                        title: Text(
                            'Name: ${userDetails?['user']?['address']?['fullName']}'),
                      ),
                    if (userDetails?['user']?['email'] != null)
                      ListTile(
                        leading: const Icon(Icons.email),
                        title: Text('Email: ${userDetails?['user']?['email']}'),
                      ),
                    if (userDetails?['user']?['address']?['phoneNumber'] !=
                        null)
                      ListTile(
                        leading: const Icon(Icons.phone),
                        title: Text(
                            'Phone: ${userDetails?['user']?['address']?['phoneNumber']}'),
                      ),
                    _buildListTile(context,
                        icon: Icons.shopping_bag_outlined,
                        title: 'My Orders', onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MyOrdersPage()),
                      );
                    }),
                    // _buildListTile(context,
                    //     icon: Icons.person_outline,
                    //     title: 'My Details', onTap: () {
                    //   Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => MyDetailsPage()),
                    //   );
                    // }),
                    // _buildListTile(context,
                    //     icon: Icons.home_outlined,
                    //     title: 'Address Book', onTap: () {
                    //   Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => const AddressPage()),
                    //   );
                    // }),
                    const Divider(height: 10, thickness: 1),
                    _buildListTile(context,
                        icon: Icons.help_outline, title: 'FAQs', onTap: () {}),
                    _buildListTile(context,
                        icon: Icons.headset_mic_outlined,
                        title: 'Help Center',
                        onTap: () {}),
                    const Divider(height: 10, thickness: 1),
                    ListTile(
                      leading: const Icon(Icons.logout, color: Colors.red),
                      title: const Text(
                        'Logout',
                        style: TextStyle(color: Colors.red),
                      ),
                      onTap: () async {
                        // Clear shared preferences
                        final prefs = await SharedPreferences.getInstance();
                        await prefs
                            .clear(); // This clears all the data in SharedPreferences

                        // Navigate to HomePage
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  MainNavigation()), // Replace with your HomePage widget
                        );
                      },
                    )
                  ],
                ),
    );
  }

  Widget _buildListTile(BuildContext context,
      {required IconData icon,
      required String title,
      required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, size: 28),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 18),
      onTap: onTap,
    );
  }
}
