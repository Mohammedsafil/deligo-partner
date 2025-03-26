import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:project_flutter/models/partner_profile.dart';
import 'package:project_flutter/screens/orders_screen.dart';
import '../widgets/bottom_navbar.dart';
import './withdrawal_screen.dart';
import './profile_screen.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final String partnerId = "partnerId1";
  late Stream<DocumentSnapshot> _paymentStream;
  late CollectionReference<Map<String, dynamic>> _transactionStream;
  final FirestoreService _firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    _paymentStream = _firestoreService.getProfileStream(partnerId);
    _transactionStream = FirebaseFirestore.instance.collection('transaction');
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: _paymentStream,
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
                  const Text('Payment data not found'),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          );
        }

        try {
          final paymentData = snapshot.data!.data() as Map<String, dynamic>;

          final totalEarnings = paymentData['earnings'] as Map<String, dynamic>;

          // final transactions =
          //     paymentData['transactions'] as Map<String, dynamic>;

          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text(
                'Earnings',
                style: GoogleFonts.pacifico(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Text(
                    "Deligo",
                    style: GoogleFonts.pacifico(
                      fontSize: 32,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
              backgroundColor: const Color(0xFFFF4B3A),
              elevation: 0,
            ),
            body: Column(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildEarningsSummary(
                        NumberFormat.decimalPattern(
                          'en_IN',
                        ).format(totalEarnings['totalearnings']),
                      ),
                      _buildTransactionsList(),
                    ],
                  ),
                ),
                const SizedBox(height: 120),
                // _buildWithDrawSection(),
              ],
            ),

            bottomNavigationBar: BottomNavBar(
              currentIndex: 1,
              onTap: (currentIndex) {
                if (currentIndex == 0) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const OrdersScreen(),
                    ),
                  );
                } else if (currentIndex == 2) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfileScreen()),
                  );
                }
              },
            ),
          );
        } catch (e) {
          return Scaffold(body: Center(child: Text('Error: $e')));
        }
      },
    );
  }

  Widget _buildEarningsSummary(String totalEarnings) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFF4B3A), Color(0xFFFF8329)],
        ),
      ),
      child: Column(
        children: [
          Text(
            '₹ ${totalEarnings}',
            style: GoogleFonts.lato(
              fontSize: 56,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Total Earnings',
            style: GoogleFonts.lato(fontSize: 26, color: Colors.white70),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // _buildEarningsCard('Today', '₹ 850', '5 deliveries'),
              // _buildEarningsCard('This Week', '₹ 5,250', '32 deliveries'),
            ],
          ),
        ],
      ),
    );
  }

  // Widget _buildEarningsCard(String title, String amount, String deliveries) {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
  //     decoration: BoxDecoration(
  //       color: Colors.white.withOpacity(0.2),
  //       borderRadius: BorderRadius.circular(15),
  //     ),
  //     child: Column(
  //       children: [
  //         Text(
  //           title,
  //           style: GoogleFonts.lato(fontSize: 14, color: Colors.white70),
  //         ),
  //         const SizedBox(height: 8),
  //         Text(
  //           amount,
  //           style: GoogleFonts.lato(
  //             fontSize: 24,
  //             fontWeight: FontWeight.bold,
  //             color: Colors.white,
  //           ),
  //         ),
  //         const SizedBox(height: 4),
  //         Text(
  //           deliveries,
  //           style: GoogleFonts.lato(fontSize: 12, color: Colors.white70),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildTransactionsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _transactionStream.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No transactions found"));
        }

        final transactions = snapshot.data!.docs;
        List<String> transactionIds =
            snapshot.data!.docs.map((doc) => doc.id).toList();

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            final transaction =
                transactions[index].data() as Map<String, dynamic>;

            DateTime dateTime;
            if (transaction['date'] is Timestamp) {
              dateTime = (transaction['date'] as Timestamp).toDate();
            } else {
              dateTime =
                  DateTime.tryParse(transaction['date'].toString()) ??
                  DateTime.now();
            }

            // Format date as "dd MMM yyyy" (e.g., "25 Mar 2025")
            String formattedDate = DateFormat('dd MMM yyyy').format(dateTime);
            String formatedTime = DateFormat('hh:mm a').format(dateTime);
            return _buildTransactionCard(
              date: formattedDate,
              time: formatedTime,
              orderNumber: transactionIds[index].toString(),
              amount: '₹ ${transaction['amount'].toString() ?? '0'}',
              type: transaction['type'].toString() ?? 'Payment',
            );
          },
        );
      },
    );
  }

  Widget _buildTransactionCard({
    required String date,
    required String time,
    required String orderNumber,
    required String amount,
    required String type,
  }) {
    return Container(
      margin: const EdgeInsets.only(top: 15, left: 10, right: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFFF4B3A).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              type == 'Cash' ? Icons.money : Icons.payment,
              color: const Color(0xFFFF4B3A),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Order $orderNumber',
                  style: GoogleFonts.lato(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$date at $time',
                  style: GoogleFonts.lato(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: GoogleFonts.lato(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: const Color(0xFFFF4B3A),
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color:
                      type == 'Cash'
                          ? Colors.green.withOpacity(0.1)
                          : Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  type,
                  style: GoogleFonts.lato(
                    color: type == 'Cash' ? Colors.green : Colors.blue,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWithDrawSection() {
    return Builder(
      builder:
          (context) => Container(
            margin: const EdgeInsets.only(left: 20, right: 20),
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
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WithdrawalScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF4B3A),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Withdraw Payout',
                    style: GoogleFonts.lato(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
    );
  }
}
