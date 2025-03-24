import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_flutter/models/order.dart';
import '../screens/order_details_screen.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({
    super.key,
    required this.order,
    required this.onOrderAccept,
  });
  final Function onOrderAccept;
  final Order order;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => OrderDetailsScreen(
                  order: order,
                  onAcceptOrder: onOrderAccept,
                ),
          ),
        );
      },
      child: Container(
        width: 175,
        height: 125,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            if (order.status == "active") ...[
              BoxShadow(
                color: Colors.yellow,
                blurRadius: 8,
                offset: Offset(0, 0),
              ),
            ] else ...[
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: Offset(0, 0),
              ),
            ],
          ],
        ),
        child: Card(
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 8,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Order!',
                    style: GoogleFonts.inter(
                      fontSize: 24,
                      color: const Color(0xFFFF460A),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${order.distance} km",
                        style: GoogleFonts.inter(fontSize: 16),
                      ),
                    ],
                  ),
                  if (order.status == "active") ...[
                    Text(
                      "Active",
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFFF460A),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
