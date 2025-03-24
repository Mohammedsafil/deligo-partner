import 'package:flutter/material.dart';
import 'package:project_flutter/screens/opening_screen.dart';
import 'package:project_flutter/screens/orders_screen.dart';
import 'package:project_flutter/screens/payment_screen.dart';
import 'package:project_flutter/screens/profile_screen.dart';
import 'package:project_flutter/widgets/bottom_navbar.dart';

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
      home: const OpeningScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    OrdersScreen(),
    PaymentScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
