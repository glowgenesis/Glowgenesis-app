import 'package:flutter/material.dart';

Widget buildSkincarePage(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color(0xFFFFFFFF), // Set background color to white
    body: LayoutBuilder(
      builder: (context, constraints) {
        // Get screen height and width
        final screenHeight = constraints.maxHeight;
        final screenWidth = constraints.maxWidth;

        return Stack(
          children: [
            // Content at the top
            Positioned.fill(
              top: screenHeight * .06,
              left: screenWidth * .01,
              right: screenWidth * .23,
              child: Align(
                alignment: Alignment.center, // Ensure the column is centered
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.start, // Center vertically
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Center horizontally
                  children: [
                    Text(
                      "Your",
                      style: TextStyle(
                        fontSize:
                            screenWidth * 0.16, // Adjusted font size for "Your"
                        fontWeight: FontWeight.bold,
                        color: Colors.black, // Ensured text color is black
                        height: .9, // Tighter line height
                      ),
                    ),
                    Text(
                      "skincare",
                      style: TextStyle(
                        fontSize: screenWidth * 0.13,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        height: .9,
                      ),
                    ),
                    Text(
                      "tailored just",
                      style: TextStyle(
                        fontSize:
                            screenWidth * 0.13, // Slightly smaller font size
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        height: .9,
                      ),
                    ),
                    Text(
                      "for you.",
                      style: TextStyle(
                        fontSize:
                            screenWidth * 0.13, // Same size as "tailored just"
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        height: .9,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Positioned image at the bottom-right
            Positioned(
              bottom: screenHeight * 0.13, // Adjust based on button position
              right: screenWidth * 0.05, // Slight padding from the right
              child: Image.asset(
                'assets/getstarted.jpg', // Replace with actual path
                width: screenWidth * 0.8, // Adjust size dynamically
                fit: BoxFit.contain,
              ),
            ),

            // Get Started button
            Positioned(
              bottom: screenHeight * 0.05,
              left: screenWidth * 0.05,
              right: screenWidth * 0.05,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, screenHeight * 0.07),
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 0.02),
                  ),
                ),
                onPressed: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Get Started",
                      style: TextStyle(
                          fontSize: screenWidth * 0.045, color: Colors.white),
                    ),
                    SizedBox(width: screenWidth * 0.02),
                    Icon(
                      Icons.arrow_forward,
                      size: screenWidth * 0.05,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    ),
  );
}
