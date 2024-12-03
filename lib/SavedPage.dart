import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'ProductDetailsPage.dart'; // Make sure to import the ProductDetailsPage

class SavedPage extends StatelessWidget {
  final List<Map<String, dynamic>> likedProducts; // Receiving list of liked products

  SavedPage({required this.likedProducts});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Saved Items',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04,
          vertical: screenHeight * 0.02,
        ),
        child: Column(
          children: [
            Expanded(
              child: likedProducts.isEmpty
                  ? Center(
                      child: Text(
                        'No saved products yet!',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    )
                  : GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: screenWidth > 600 ? 3 : 2,
                        mainAxisSpacing: screenHeight * 0.02,
                        crossAxisSpacing: screenWidth * 0.04,
                        childAspectRatio: 0.7,
                      ),
                      itemCount: likedProducts.length,
                      itemBuilder: (context, index) {
                        final product = likedProducts[index];

                        return GestureDetector(
                          onTap: () {
                            // Navigate to ProductDetailsPage with product details
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductDetailsPage(
                                  productName: product['name'],
                                  productImage: product['image'],
                                  productDescription: 'Description goes here...', // You can update this with actual description if available
                                  productPrice: product['price'],
                                  productRating: 4.0, // Use actual rating if available
                                  reviewCount: 10, // Use actual review count if available
                                  isLiked: true, // Since it's in saved items, it's liked
                                  toggleLike: () {
                                    // Implement toggle like functionality if needed
                                  },
                                ),
                              ),
                            );
                          },
                          child: Card(
                            color: Color.fromRGBO(247, 242, 250, 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(screenWidth * 0.04),
                            ),
                            elevation: 3,
                            shadowColor: Colors.black12,
                            child: Stack(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(screenWidth * 0.04),
                                          topRight: Radius.circular(screenWidth * 0.04),
                                        ),
                                        child: product['image'].toString().startsWith('http')
                                            // For remote images, use Image.network
                                            ? Image.network(
                                                product['image'],
                                                fit: BoxFit.cover,
                                                width: double.infinity,
                                                errorBuilder: (context, error, stackTrace) {
                                                  return Icon(Icons.error, size: 50);
                                                },
                                              )
                                            // For local images, use Image.asset
                                            : Image.asset(
                                                product['image'],
                                                fit: BoxFit.cover,
                                                width: double.infinity,
                                                errorBuilder: (context, error, stackTrace) {
                                                  return Icon(Icons.error, size: 50);
                                                },
                                              ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(
                                        screenWidth * 0.03,
                                        screenHeight * 0.01,
                                        screenWidth * 0.03,
                                        screenHeight * 0.005,
                                      ),
                                      child: Text(
                                        product['name'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: screenWidth * 0.04,
                                          color: Colors.black87,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: screenWidth * 0.03,
                                      ),
                                      child: Text(
                                        '₹${product['price'].toStringAsFixed(2)}',
                                        style: TextStyle(
                                          color: Colors.green.shade700,
                                          fontWeight: FontWeight.w600,
                                          fontSize: screenWidth * 0.037,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: screenHeight * 0.01),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
