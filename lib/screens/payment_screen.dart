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
  final String partnerId;
  const PaymentScreen({super.key, required this.partnerId});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late String partnerId = widget.partnerId;
  late Stream<DocumentSnapshot> _paymentStream;
  late CollectionReference<Map<String, dynamic>> _transactionStream;
  final FirestoreService _firestoreService = FirestoreService();
  // final String partnerTranId = "+91 9789378657";

  @override
  void initState() {
    super.initState();
    // _paymentStream = _firestoreService.getProfileStream(partnerId);
    _transactionStream = FirebaseFirestore.instance.collection('transaction');
  }

  @override
  Widget build(BuildContext context) {
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
              style: GoogleFonts.pacifico(fontSize: 32, color: Colors.white),
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
              children: [_buildEarningsSummary(), _buildTransactionsList()],
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
                builder: (context) => OrdersScreen(partnerId: partnerId),
              ),
            );
          } else if (currentIndex == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => ProfileScreen(partnerId: widget.partnerId),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildEarningsSummary() {
    DateTime now = DateTime.now();
    DateTime startOfDay = DateTime(now.year, now.month, now.day);
    DateTime endOfDay = DateTime(now.year, now.month, now.day + 1);
    return StreamBuilder<QuerySnapshot>(
      stream:
          _transactionStream
              .where('partnerId', isEqualTo: partnerId)
              .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        // if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
        //   return const Center(child: Text("No transactions found"));
        // }

        double totalEarnings = 0;
        if (snapshot.data!.docs.isNotEmpty) {
          totalEarnings = snapshot.data!.docs.fold(0.0, (sum, doc) {
            final data = doc.data() as Map<String, dynamic>;
            if (data['date'] is Timestamp) {
              DateTime transactionDate = (data['date'] as Timestamp).toDate();

              // Check if the transaction date falls within today
              if (transactionDate.isAfter(startOfDay) &&
                  transactionDate.isBefore(endOfDay)) {
                double amount = (data['amount'] ?? 0).toDouble();
                return sum + amount;
              }
            }
            return sum;
          });
        }
        // List<String> transactionIds =
        //     snapshot.data!.docs.map((doc) => doc.id).toList();

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
                '₹ ${totalEarnings.toStringAsFixed(2)}', // Ensure 2 decimal places
                style: GoogleFonts.lato(
                  fontSize: 56,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Today\'s Earnings',
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
      },
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
    DateTime now = DateTime.now();
    print(now);
    DateTime startOfDay = DateTime(now.year, now.month, now.day);
    DateTime endOfDay = DateTime(now.year, now.month, now.day + 1);
    return StreamBuilder<QuerySnapshot>(
      stream:
          _transactionStream
              .where('partnerId', isEqualTo: partnerId)
              .snapshots(),

      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        // if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
        //   return const Center(child: Text("No transactions found"));
        // }

        // final transactions = snapshot.data!.docs;
        List<QueryDocumentSnapshot> todayTransactions = [];
        List<String> transactionIds = [];
        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          transactionIds = snapshot.data!.docs.map((doc) => doc.id).toList();

          todayTransactions =
              snapshot.data!.docs.where((doc) {
                DateTime docDate = (doc['date'] as Timestamp).toDate();
                return docDate.year == now.year &&
                    docDate.month == now.month &&
                    docDate.day == now.day;
              }).toList();
        }
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: todayTransactions.length,
          itemBuilder: (context, index) {
            final transaction =
                todayTransactions[index].data() as Map<String, dynamic>;

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
              orderNumber: transaction['orderNumber'].toString(),
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
              type == 'cash' ? Icons.money : Icons.payment,
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
                      type == 'cash'
                          ? Colors.green.withOpacity(0.1)
                          : Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  type,
                  style: GoogleFonts.lato(
                    color: type == 'cash' ? Colors.green : Colors.blue,
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
