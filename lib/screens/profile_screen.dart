import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/bottom_navbar.dart';
import './payment_screen.dart';
import './orders_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                  _buildProfileSection(),
                  const SizedBox(height: 30),
                  _buildDeliveryStats(),
                  const SizedBox(height: 30),
                  _buildVehicleInfo(),
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
              MaterialPageRoute(builder: (context) => const PaymentScreen()),
            );
          } else if (currentIndex == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => OrdersScreen()),
            );
          }
        },
      ),
    );
  }

  Widget _buildProfileSection() {
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
                      'Md Safil',
                      style: GoogleFonts.lato(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'ID: 11118008',
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
                          '+91 9789378657',
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

  Widget _buildDeliveryStats() {
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
              _buildStatItem('156', 'Deliveries'),
              _buildStatItem('4.8 ⭐', 'Rating'),
              _buildStatItem('95%', 'On-time'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.lato(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: const Color(0xFFFF4B3A),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.lato(fontSize: 14, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildVehicleInfo() {
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
          _buildVehicleInfoItem(Icons.two_wheeler, 'Duke 350'),
          _buildVehicleInfoItem(Icons.numbers, 'TN 01 AB 1234'),
          _buildVehicleInfoItem(Icons.badge, 'DL98765432109876'),
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
