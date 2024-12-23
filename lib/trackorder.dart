import 'package:flutter/material.dart';

class TrackOrderPage extends StatelessWidget {
  const TrackOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Track Order', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.black),
            onPressed: () {
              // Handle notifications
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Map placeholder
          Container(
            height: 250,
            color: Colors.grey[300],
            child: Center(
              child: Icon(Icons.map, size: 100, color: Colors.grey[600]),
            ),
          ),

          // Order Status Section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Order Status', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.grey),
                        onPressed: () {
                          // Handle close
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Order status timeline
                  Expanded(
                    child: ListView(
                      children: [
                        _buildStatusItem(
                          context,
                          status: 'Packing',
                          isCompleted: true,
                          address: '2336 Jack Warren Rd, Delta Junction, Alaska 99737',
                        ),
                        _buildStatusItem(
                          context,
                          status: 'Picked',
                          isCompleted: true,
                          address: '2417 Tongass Ave #111, Ketchikan, Alaska 99901',
                        ),
                        _buildStatusItem(
                          context,
                          status: 'In Transit',
                          isCompleted: false,
                          address: '16 Rr 2, Ketchikan, Alaska 99901, USA',
                        ),
                        _buildStatusItem(
                          context,
                          status: 'Delivered',
                          isCompleted: false,
                          address: '925 S Chugach St #APT 10, Alaska 99645',
                        ),
                      ],
                    ),
                  ),

                  // Delivery guy details
                  const Divider(height: 24),
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.grey[300],
                        radius: 30,
                        child: Icon(Icons.person, color: Colors.grey[600], size: 40),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Jacob Jones', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            Text('Delivery Guy', style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.phone, color: Colors.black),
                        onPressed: () {
                          // Handle call
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusItem(BuildContext context,
      {required String status, required bool isCompleted, required String address}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Icon(
              isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
              color: isCompleted ? Colors.green : Colors.grey,
            ),
            Container(
              height: 40,
              width: 2,
              color: Colors.grey,
            ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(status, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(address, style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }
}
