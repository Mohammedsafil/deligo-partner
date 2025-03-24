// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../widgets/bottom_navbar.dart';

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'DeliGo Partner',
//           style: GoogleFonts.lato(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         backgroundColor: const Color(0xFFFF4B3A),
//         elevation: 0,
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [_buildHeader(), _buildOrdersList()],
//         ),
//       ),
//       bottomNavigationBar: BottomNavBar(
//         currentIndex: 0,
//         onTap: (index) {
//           if (index == 2) {
//             Navigator.pushReplacementNamed(context, '/profile');
//           }
//         },
//       ),
//     );
//   }

//   Widget _buildHeader() {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: const BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//           colors: [Color(0xFFFF4B3A), Color(0xFFFF8329)],
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Today\'s Earnings',
//                     style: GoogleFonts.lato(
//                       fontSize: 16,
//                       color: Colors.white70,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     '₹ 850.00',
//                     style: GoogleFonts.lato(
//                       fontSize: 32,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ],
//               ),
//               Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 16,
//                   vertical: 8,
//                 ),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Row(
//                   children: [
//                     const Icon(Icons.circle, color: Colors.green, size: 12),
//                     const SizedBox(width: 8),
//                     Text(
//                       'Online',
//                       style: GoogleFonts.lato(
//                         color: const Color(0xFFFF4B3A),
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 20),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               _buildStatCard('5', 'Deliveries'),
//               _buildStatCard('95%', 'Success Rate'),
//               _buildStatCard('4.8', 'Rating'),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildStatCard(String value, String label) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.2),
//         borderRadius: BorderRadius.circular(15),
//       ),
//       child: Column(
//         children: [
//           Text(
//             value,
//             style: GoogleFonts.lato(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             label,
//             style: GoogleFonts.lato(fontSize: 12, color: Colors.white70),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildOrdersList() {
//     return Padding(
//       padding: const EdgeInsets.all(20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Active Orders',
//             style: GoogleFonts.lato(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: Colors.grey[800],
//             ),
//           ),
//           const SizedBox(height: 16),
//           _buildOrderCard(
//             orderNumber: '#1234',
//             restaurantName: 'Pizza House',
//             status: 'Pickup',
//             address: '123 Main St, City',
//             amount: '₹450',
//             time: '15 mins',
//           ),
//           const SizedBox(height: 16),
//           _buildOrderCard(
//             orderNumber: '#1235',
//             restaurantName: 'Burger King',
//             status: 'On the way',
//             address: '456 Park Ave, City',
//             amount: '₹350',
//             time: '25 mins',
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildOrderCard({
//     required String orderNumber,
//     required String restaurantName,
//     required String status,
//     required String address,
//     required String amount,
//     required String time,
//   }) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(15),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             spreadRadius: 2,
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 'Order $orderNumber',
//                 style: GoogleFonts.lato(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                   color: const Color(0xFFFF4B3A),
//                 ),
//               ),
//               Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 12,
//                   vertical: 6,
//                 ),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFFF4B3A).withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Text(
//                   status,
//                   style: GoogleFonts.lato(
//                     color: const Color(0xFFFF4B3A),
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           Text(
//             restaurantName,
//             style: GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.w600),
//           ),
//           const SizedBox(height: 8),
//           Row(
//             children: [
//               const Icon(
//                 Icons.location_on_outlined,
//                 size: 16,
//                 color: Colors.grey,
//               ),
//               const SizedBox(width: 4),
//               Expanded(
//                 child: Text(
//                   address,
//                   style: GoogleFonts.lato(color: Colors.grey[600]),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 amount,
//                 style: GoogleFonts.lato(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               Row(
//                 children: [
//                   const Icon(Icons.access_time, size: 16, color: Colors.grey),
//                   const SizedBox(width: 4),
//                   Text(time, style: GoogleFonts.lato(color: Colors.grey[600])),
//                 ],
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
