// import 'package:flutter/material.dart';

// class FlippingCard extends StatefulWidget {
//   const FlippingCard({super.key});

//   @override
//   _FlippingCardState createState() => _FlippingCardState();
// }

// class _FlippingCardState extends State<FlippingCard> {
//   bool isFlipped = false;

//   void _flipCard() {
//     setState(() {
//       isFlipped = !isFlipped;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: _flipCard,
//       child: AnimatedSwitcher(
//         duration: const Duration(milliseconds: 500),
//         child: isFlipped ? _buildBackCard() : _buildFrontCard(),
//       ),
//     );
//   }
// }
