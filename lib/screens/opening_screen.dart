import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_flutter/screens/signin_page.dart';
import 'orders_screen.dart';
import '../models/partner_profile.dart';

class OpeningScreen extends StatefulWidget {
  const OpeningScreen({super.key});

  @override
  State<OpeningScreen> createState() => _OpeningScreenState();
}

class _OpeningScreenState extends State<OpeningScreen> {

  final FirestoreService _firestoreService = FirestoreService();

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
                onPressed: () async {
                  String check = await _firestoreService.checkLogin();
                  if(check.isNotEmpty){
                    Navigator.push(context, 
                      MaterialPageRoute(builder: (context)=> OrdersScreen(partnerId: check))
                    );
                  }
                  else{
                    Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SignInScreen())
                    );
                  }
                },
                child: Text(
                  'Get Started',
                  style: GoogleFonts.lato(
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
