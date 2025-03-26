import 'package:flutter/material.dart';
import 'screens/payment_screen.dart';
import 'screens/profile_screen.dart';
import 'widgets/bottom_navbar.dart';
import 'screens/orders_screen.dart';
import 'screens/opening_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Widget> _screens = [
    const OrdersScreen(),
    const PaymentScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: OpeningScreen());
  }
}
