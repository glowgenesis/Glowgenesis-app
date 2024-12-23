import 'package:flutter/material.dart';
import 'package:glowgenesis/mydetailspage.dart';
import 'myorderpage.dart';
import 'addresspage.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

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
      body: ListView(
        children: [
          _buildListTile(context,
              icon: Icons.shopping_bag_outlined, title: 'My Orders', onTap: () {
            // Navigate to My Orders page
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyOrdersPage()),
            );
          }),
          _buildListTile(
            context,
            icon: Icons.person_outline,
            title: 'My Details',
            onTap: () {
              // Navigate to My Details page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyDetailsPage()),
              );
            },
          ),
          _buildListTile(
            context,
            icon: Icons.home_outlined,
            title: 'Address Book',
            onTap: () {
              // Navigate to Address Book page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddressPage()),
              );
            },
          ),
          // _buildListTile(
          //   context,
          //   icon: Icons.payment_outlined,
          //   title: 'Payment Methods',
          //   onTap: () {
          //     // Navigate to Payment Methods page
          //   },
          // ),
          // _buildListTile(
          //   context,
          //   icon: Icons.notifications_outlined,
          //   title: 'Notifications',
          //   onTap: () {
          //     // Navigate to Notifications page
          //   },
          // ),
          const Divider(height: 10, thickness: 1),
          _buildListTile(
            context,
            icon: Icons.help_outline,
            title: 'FAQs',
            onTap: () {
              // Navigate to FAQs page
            },
          ),
          _buildListTile(
            context,
            icon: Icons.headset_mic_outlined,
            title: 'Help Center',
            onTap: () {
              // Navigate to Help Center page
            },
          ),
          const Divider(height: 10, thickness: 1),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
            onTap: () {
              // Handle logout
            },
          ),
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
