import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'orders_screen.dart';
import 'package:project_flutter/main.dart';
import 'package:project_flutter/screens/orders_screen.dart';

class OpeningScreen extends StatelessWidget {
  const OpeningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFF4B3A), Color(0xFFFF4B3A), Color(0xFFFF8329)],
          ),
        ),
        child: Column(
          children: [
            const Spacer(),
            Text(
              'DeliGo',
              style: GoogleFonts.pacifico(fontSize: 48, color: Colors.white),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const MainScreen()),
                  );
                },

                child: Text(
                  'Get Started',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    color: Color(0xFFFF460A),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
