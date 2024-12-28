// import 'package:flutter/material.dart';

// class CustomSliderButton extends StatefulWidget {
//   final Future<void> Function() action;
//   final String label;
//   final Color sliderColor;
//   final Color backgroundColor;
//   final Color completedColor;
//   final IconData icon;

//   const CustomSliderButton({
//     required this.action,
//     required this.label,
//     this.sliderColor = Colors.orange,
//     this.backgroundColor = Colors.grey,
//     this.completedColor = Colors.green,
//     this.icon = Icons.arrow_forward,
//     Key? key,
//   }) : super(key: key);

//   @override
//   _CustomSliderButtonState createState() => _CustomSliderButtonState();
// }

// class _CustomSliderButtonState extends State<CustomSliderButton> {
//   double sliderPosition = 0.0;
//   bool actionTriggered = false;

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final sliderWidth = screenWidth * 0.85;

//     return GestureDetector(
//       onPanUpdate: (details) {
//         if (actionTriggered) return;

//         setState(() {
//           sliderPosition += details.delta.dx;
//           sliderPosition = sliderPosition.clamp(0.0, sliderWidth - 60);
//         });
//       },
//       onPanEnd: (details) async {
//         if (sliderPosition >= sliderWidth - 60) {
//           setState(() => actionTriggered = true);
//           try {
//             await widget.action();
//             setState(() =>
//                 sliderPosition = sliderWidth - 60); // Lock slider in place
//           } catch (e) {
//             debugPrint('Error executing action: $e');
//             setState(() {
//               sliderPosition = 0.0; // Reset slider on failure
//               actionTriggered = false;
//             });
//           }
//         } else {
//           setState(() => sliderPosition = 0.0); // Reset the slider
//         }
//       },
//       child: Stack(
//         children: [
//           // Background
//           Container(
//             width: sliderWidth,
//             height: 60,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(30),
//               gradient: LinearGradient(
//                 colors: actionTriggered
//                     ? [widget.completedColor, widget.completedColor]
//                     : [widget.completedColor, widget.backgroundColor],
//                 stops: actionTriggered
//                     ? [1.0, 1.0]
//                     : [
//                         (sliderPosition / (sliderWidth - 60)).clamp(0.0, 1.0),
//                         (sliderPosition / (sliderWidth - 60)).clamp(0.0, 1.0)
//                       ],
//               ),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black12,
//                   blurRadius: 6,
//                   offset: const Offset(0, 3),
//                 ),
//               ],
//             ),
//             child: Center(
//               child: Text(
//                 widget.label,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),
//           // Slider button
//           Positioned(
//             left: sliderPosition,
//             child: GestureDetector(
//               onPanUpdate: (details) {
//                 if (actionTriggered) return;
//                 setState(() {
//                   sliderPosition += details.delta.dx;
//                   sliderPosition = sliderPosition.clamp(0.0, sliderWidth - 60);
//                 });
//               },
//               child: Container(
//                 width: 60,
//                 height: 60,
//                 decoration: BoxDecoration(
//                   color: widget.sliderColor,
//                   shape: BoxShape.circle,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black26,
//                       blurRadius: 6,
//                       offset: const Offset(0, 2),
//                     ),
//                   ],
//                 ),
//                 child: Icon(
//                   widget.icon,
//                   color: Colors.white,
//                   size: 28,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
