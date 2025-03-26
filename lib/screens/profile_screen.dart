import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/bottom_navbar.dart';
import './payment_screen.dart';
import './orders_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/partner_profile.dart';

class ProfileScreen extends StatefulWidget {
  final String partnerId = "partnerId1";

  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Stream<DocumentSnapshot> _profileStream;
  final FirestoreService _firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    _profileStream = _firestoreService.getProfileStream(widget.partnerId);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: _profileStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Profile not found'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Create a sample profile for testing
                      _firestoreService.createProfile(
                        widget.partnerId,
                        'John Doe',
                        '+91 9876543210',
                        156,
                        4.8,
                        95.0,
                        'Duke 350',
                        'TN 01 AB 1234',
                        'DL98765432109876',
                      );
                    },
                    child: const Text('Create Sample Profile'),
                  ),
                ],
              ),
            ),
          );
        }

        try {
          final profileData = snapshot.data!.data() as Map<String, dynamic>;
          // print(profileData.values);
          print(profileData['name']);
          // print(profileData['delivery_statistics']);
          // print(profileData['vehicle']);
          final deliveryStats =
              profileData['delivery_statistics'] as Map<String, dynamic>? ?? {};
          final vehicleInfo =
              profileData['vehicle'] as Map<String, dynamic>? ?? {};

          print(vehicleInfo['bike_name']);
          print(vehicleInfo['license']);
          print(vehicleInfo['number_plate']);
          print(deliveryStats['deliveries']);
          print(deliveryStats['on_time_percentage']);
          print(deliveryStats['rating']);

          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Profile',
                style: GoogleFonts.pacifico(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: const Color(0xFFFF4B3A),
              elevation: 0,
              actions: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.white),
                  onPressed: () {
                    // TODO: Implement edit profile
                  },
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        _buildProfileSection(profileData),
                        const SizedBox(height: 30),
                        _buildDeliveryStats(deliveryStats),
                        const SizedBox(height: 30),
                        _buildVehicleInfo(vehicleInfo),
                        const SizedBox(height: 30),
                        _buildSupportSection(),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: BottomNavBar(
              currentIndex: 2,
              onTap: (currentIndex) {
                if (currentIndex == 1) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PaymentScreen(),
                    ),
                  );
                } else if (currentIndex == 0) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const OrdersScreen(),
                    ),
                  );
                }
              },
            ),
          );
        } catch (e) {
          return Scaffold(
            body: Center(
              child: Text(
                'Error parsing profile data: $e',
                style: const TextStyle(color: Colors.red),
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildProfileSection(Map<String, dynamic> profileData) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFF4B3A), Color(0xFFFF8329)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 45, color: Color(0xFFFF4B3A)),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profileData['name'],
                      // 'John Doe',
                      style: GoogleFonts.lato(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'ID: ${profileData['id']}',
                      style: GoogleFonts.lato(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.phone,
                          color: Colors.white70,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          profileData['mobile_no'],
                          // '1234567890',
                          style: GoogleFonts.lato(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryStats(Map<String, dynamic> deliveryStats) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Delivery Statistics',
            style: GoogleFonts.lato(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xFFFF4B3A),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                deliveryStats['deliveries']?.toString() ?? '0',
                'Deliveries',
              ),
              _buildStatItem(
                deliveryStats['rating']?.toString() ?? '0',
                'Rating',
              ),
              _buildStatItem(
                deliveryStats['on_time_percentage']?.toString() ?? '0',
                'On-time',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    IconData? icon;
    String displayValue = value;

    // Determine icon and format value based on label
    if (label == 'Rating') {
      icon = Icons.star;
    } else if (label == 'On-time') {
      icon = Icons.timer;
      displayValue = '$value%';
    } else if (label == 'Deliveries') {
      icon = Icons.delivery_dining;
    }

    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, color: const Color(0xFFFF4B3A), size: 20),
              const SizedBox(width: 4),
            ],
            Text(
              displayValue,
              style: GoogleFonts.lato(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.lato(fontSize: 14, color: Colors.black54),
        ),
      ],
    );
  }

  Widget _buildVehicleInfo(Map<String, dynamic> vehicleInfo) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Vehicle Information',
            style: GoogleFonts.lato(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xFFFF4B3A),
            ),
          ),
          const SizedBox(height: 16),
          _buildVehicleInfoItem(
            Icons.two_wheeler,
            vehicleInfo['bike_name'] ?? '',
          ),
          _buildVehicleInfoItem(
            Icons.numbers,
            vehicleInfo['license'].toString() ?? '',
          ),
          _buildVehicleInfoItem(
            Icons.badge,
            vehicleInfo['number_plate'].toString() ?? '',
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleInfoItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[600], size: 20),
          const SizedBox(width: 12),
          Text(
            text,
            style: GoogleFonts.lato(fontSize: 16, color: Colors.grey[800]),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFF4B3A),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'FAQ',
            style: GoogleFonts.lato(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFF4B3A),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'HELP',
            style: GoogleFonts.lato(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSOSSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFF4B3A),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'SOS',
            style: GoogleFonts.lato(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportSection() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SUPPORT',
            style: GoogleFonts.lato(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xFFFF4B3A),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildFAQSection(),
              const SizedBox(width: 40),
              _buildHelpSection(),
              const SizedBox(width: 40),
              _buildSOSSection(),
            ],
          ),
        ],
      ),
    );
  }
}
