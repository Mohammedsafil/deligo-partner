import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:google_fonts/google_fonts.dart";
import "package:project_flutter/models/order.dart";
import "package:project_flutter/screens/map_screen.dart";
import "package:project_flutter/screens/message_screen.dart";
import "package:project_flutter/widgets/bottom_navbar.dart";
import 'package:url_launcher/url_launcher.dart';
import "./profile_screen.dart";
import "./payment_screen.dart";

class OrderDetailsScreen extends StatefulWidget {
  const OrderDetailsScreen({
    super.key,
    required this.order,
    required this.onAcceptOrder, required this.partnerId,
  });
  final String partnerId;
  final Order order;
  final Function onAcceptOrder;

  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.all(40.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                'DeliGo',
                style: GoogleFonts.pacifico(
                  fontSize: 48,
                  color: const Color(0xFFFF460A),
                ),
              ),
            ),
          ),
          const SizedBox(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(width: 20),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                    size: 30,
                  ),
                ),
                const Spacer(),
                if (widget.order.status != 'delivered' &&
                    widget.order.status != 'pickup') ...[
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  MessageScreen(orderId: widget.order.id),
                        ),
                      );
                    },
                    icon: Icon(Icons.edit, color: Colors.black, size: 30),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        "Order id: ${widget.order.id}",
                        style: GoogleFonts.inter(
                          fontSize: 22,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 30),
                      Text(
                        "Customer: ${widget.order.customerName}",
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.order.delivery,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        "Order Date: ${DateFormat('dd/MM/yyyy').format(widget.order.orderDate)}",
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        "Order Time ${DateFormat('HH:mm a').format(widget.order.orderDate)}",
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFFF460A)),
                          borderRadius: BorderRadius.circular(20),
                          color: const Color.fromARGB(255, 255, 217, 161),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: SizedBox(
                            width: 300,
                            height: 150,
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Ordered Items:',
                                    style: GoogleFonts.inter(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  ...widget.order.orderedItems.map((item) {
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 5),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '${item['item']}',
                                            style: GoogleFonts.inter(
                                              fontSize: 14,
                                              color: Colors.black,
                                            ),
                                          ),
                                          Text(
                                            'Quantity: ${item['quantity']}',
                                            style: GoogleFonts.inter(
                                              fontSize: 14,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Sub Total',
                                        style: GoogleFonts.inter(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text(
                                        'Rs. ${widget.order.subTotal.toStringAsFixed(2)}',
                                        style: GoogleFonts.inter(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Delivery Cost',
                                        style: GoogleFonts.inter(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text(
                                        'Rs. ${widget.order.deliveryCost.toStringAsFixed(2)}',
                                        style: GoogleFonts.inter(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Total Cost',
                                        style: GoogleFonts.inter(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text(
                                        'Rs. ${widget.order.totalCost.toStringAsFixed(2)}',
                                        style: GoogleFonts.inter(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFFFF460A),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        '*paid with ${widget.order.paymentMethod.toLowerCase()}',
                                        style: GoogleFonts.inter(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          const SizedBox(width: 100),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: LinearGradient(
                                colors: [
                                  const Color(0xFFFF460A),
                                  const Color.fromARGB(255, 213, 59, 7),
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                            ),
                            child: IconButton(
                              onPressed: () async {
                                final phoneNumber = widget.order.mobile;
                                final Uri launchUri = Uri(
                                  scheme: 'tel',
                                  path: phoneNumber,
                                );
                                await launchUrl(launchUri);
                              },
                              icon: Icon(Icons.call, color: Colors.white),
                            ),
                          ),
                          const SizedBox(width: 40),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: LinearGradient(
                                colors: [
                                  const Color(0xFFFF460A),
                                  const Color.fromARGB(255, 213, 59, 7),
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                            ),
                            child: IconButton(
                              onPressed: () {
                                try {
                                  List<String> coordinates = widget
                                      .order
                                      .deliveryLocation
                                      .split(', ');
                                  double latitude = double.parse(
                                    coordinates[0],
                                  );
                                  double longitude = double.parse(
                                    coordinates[1],
                                  );

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => MapScreen(
                                            latitude: latitude,
                                            longitude: longitude,
                                          ),
                                    ),
                                  );
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Invalid location format"),
                                    ),
                                  );
                                }
                              },
                              icon: Icon(
                                Icons.location_pin,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Column(
            children: [
              if (widget.order.status == "delivered") ...[
                Text(
                  'Delivered Successfully!',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ] else ...[
                if (widget.order.status == "pickup") ...[
                  Text(
                    'Will you accept the Order?',
                    style: GoogleFonts.inter(fontSize: 16),
                  ),
                ],
                const SizedBox(height: 20),
                if (widget.order.status.toLowerCase() == 'pickup') ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            Colors.white,
                          ),
                          side: MaterialStateProperty.all(
                            const BorderSide(
                              color: Color(0xFFFF460A),
                              width: 2,
                            ),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Decline',
                          style: GoogleFonts.inter(
                            color: const Color(0xFFFF460A),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            const Color(0xFFFF460A),
                          ),
                        ),
                        onPressed: () async {
                          await widget.onAcceptOrder(widget.order.id, "active");
                        },
                        child: Text(
                          'Accept',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ] else if (widget.order.status.toLowerCase() == 'active') ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            Colors.white,
                          ),
                          side: MaterialStateProperty.all(
                            const BorderSide(
                              color: Color(0xFFFF460A),
                              width: 2,
                            ),
                          ),
                        ),
                        onPressed: () async {
                          await widget.onAcceptOrder(
                            widget.order.id,
                            "reached restaurant",
                          );
                        },
                        child: Text(
                          'Reached Restaurant',
                          style: GoogleFonts.inter(
                            color: const Color(0xFFFF460A),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                    ],
                  ),
                ] else if (widget.order.status.toLowerCase() ==
                    'reached restaurant') ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            Colors.white,
                          ),
                          side: MaterialStateProperty.all(
                            const BorderSide(
                              color: Color(0xFFFF460A),
                              width: 2,
                            ),
                          ),
                        ),
                        onPressed: () async {
                          await widget.onAcceptOrder(
                            widget.order.id,
                            "picked up from restaurant",
                          );
                        },
                        child: Text(
                          'Picked up from Restaurant',
                          style: GoogleFonts.inter(
                            color: const Color(0xFFFF460A),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                    ],
                  ),
                ] else if (widget.order.status.toLowerCase() ==
                    'picked up from restaurant') ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            Colors.white,
                          ),
                          side: MaterialStateProperty.all(
                            const BorderSide(
                              color: Color(0xFFFF460A),
                              width: 2,
                            ),
                          ),
                        ),
                        onPressed: () async {
                          await widget.onAcceptOrder(
                            widget.order.id,
                            "reached delivery location",
                          );
                        },
                        child: Text(
                          'Reached Delivery Location',
                          style: GoogleFonts.inter(
                            color: const Color(0xFFFF460A),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                    ],
                  ),
                ] else if (widget.order.status.toLowerCase() ==
                    'reached delivery location') ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            Colors.white,
                          ),
                          side: MaterialStateProperty.all(
                            const BorderSide(
                              color: Color(0xFFFF460A),
                              width: 2,
                            ),
                          ),
                        ),
                        onPressed: () async {
                          await widget.onAcceptOrder(
                            widget.order.id,
                            "delivered",
                          );
                        },
                        child: Text(
                          'Delivered',
                          style: GoogleFonts.inter(
                            color: const Color(0xFFFF460A),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                    ],
                  ),
                ],
              ],
            ],
          ),
          const Spacer(),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 0,
        onTap: (currentIndex) {
          if (currentIndex == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>  PaymentScreen(partnerId: widget.partnerId,)),
            );
          } else if (currentIndex == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>  ProfileScreen(partnerId: widget.partnerId,)),
            );
          }
        },
      ),
    );
  }
}