import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:project_flutter/screens/payment_screen.dart';
import 'package:project_flutter/screens/profile_screen.dart';
//import 'screens/opening_screen.dart';
// import 'screens/otp_verification.dart';
import 'widgets/bottom_navbar.dart';
import 'screens/orders_screen.dart';
import 'screens/opening_screen.dart';
// safil//
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DeliGo',
      theme: ThemeData(primarySwatch: Colors.orange),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final List<Widget> _screens = const [
    OrdersScreen(),
    PaymentScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const OpeningScreen(),
    );
  }
}
