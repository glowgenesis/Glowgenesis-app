import 'package:flutter/material.dart';
import 'trackorder.dart';

class MyOrdersPage extends StatefulWidget {
  @override
  _MyOrdersPageState createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Orders', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.black),
            onPressed: () {
              // Handle notifications
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.black,
          tabs: [
            Tab(text: 'Ongoing'),
            Tab(text: 'Completed'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOngoingOrders(),
          _buildCompletedOrders(),
        ],
      ),
    );
  }

  Widget _buildOngoingOrders() {
    // Hardcoded data for ongoing orders
    List<Map<String, String>> ongoingOrders = [
      {
        "title": "Anti Acne Face Wash",
        "size": "M",
        "price": "\$1,190",
        "status": "In Transit"
      },
      {
        "title": "Vitamin C Face Wash",
        "size": "L",
        "price": "\$1,100",
        "status": "Picked"
      },
    ];

    if (ongoingOrders.isEmpty) {
      return _buildEmptyOrders('No Ongoing Orders!',
          'You don’t have any ongoing orders at this time.');
    }

    return ListView.builder(
      itemCount: ongoingOrders.length,
      itemBuilder: (context, index) {
        final order = ongoingOrders[index];
        return Card(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  color: Colors.grey[200],
                  child: Icon(Icons.image, size: 40, color: Colors.grey),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(order['title']!,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      Text('Size ${order['size']!}',
                          style: TextStyle(color: Colors.grey)),
                      Text(order['price']!,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(order['status']!,
                          style: TextStyle(fontSize: 12)),
                    ),
                    SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        // Handle track order
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => TrackOrderPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text('Track Order'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCompletedOrders() {
    // Mock data for completed orders
    List<Map<String, dynamic>> completedOrders = [
      {
        "title": "Anti Acne Face Wash",
        "size": "M",
        "price": "\$1,190",
        "rating": null
      },
      {
        "title": "Vitamin C Face Wash",
        "size": "L",
        "price": "\$1,100",
        "rating": 4.5
      },
    ];

    if (completedOrders.isEmpty) {
      return _buildEmptyOrders('No Completed Orders!',
          'You don’t have any completed orders at this time.');
    }

    return ListView.builder(
      itemCount: completedOrders.length,
      itemBuilder: (context, index) {
        final order = completedOrders[index];
        return Card(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  color: Colors.grey[200],
                  child: Icon(Icons.image, size: 40, color: Colors.grey),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(order['title'],
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      Text('Size ${order['size']}',
                          style: TextStyle(color: Colors.grey)),
                      Text(order['price'],
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                ),
                order['rating'] == null
                    ? ElevatedButton(
                        onPressed: () {
                          _showReviewDialog(context, order['title']);
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        child: Text('Leave Review'),
                      )
                    : Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 16),
                          SizedBox(width: 4),
                          Text('${order['rating']}/5',
                              style: TextStyle(color: Colors.grey)),
                        ],
                      ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyOrders(String title, String subtitle) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox, size: 80, color: Colors.grey),
          SizedBox(height: 16),
          Text(title,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
          SizedBox(height: 8),
          Text(subtitle, style: TextStyle(fontSize: 14, color: Colors.grey)),
        ],
      ),
    );
  }

  void _showReviewDialog(BuildContext context, String productTitle) {
    showDialog(
      context: context,
      builder: (context) {
        int selectedRating = 0;
        final TextEditingController reviewController = TextEditingController();

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Leave a Review'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('How was your order?'),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        onPressed: () {
                          setState(() {
                            selectedRating = index + 1;
                          });
                        },
                        icon: Icon(
                          Icons.star,
                          color: index < selectedRating
                              ? Colors.amber
                              : Colors.grey,
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: reviewController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Write your review...',
                    ),
                    maxLines: 3,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Handle review submission
                    print(
                        'Review for $productTitle: Rating - $selectedRating, Review - ${reviewController.text}');
                    Navigator.pop(context);
                  },
                  child: Text('Submit'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
