import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "/widgets/order_card.dart";
import "/models/order.dart";

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  List<Order> orders = List.from(dummyOrders);

  void updateOrderStatus(String orderId, String newStatus) {
    setState(() {
      for (var order in orders) {
        if (order.id == orderId) {
          order.status = newStatus;
          break;
        }
      }
    });
  }

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<Order> acceptedOrders =
        orders.where((order) => order.status == "active").toList();
    List<Order> pendingOrders =
        orders.where((order) => order.status != "active").toList();

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
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.location_on_rounded, color: const Color(0xFFFF460A)),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Current Location', style: GoogleFonts.inter()),
                    Text(
                      'Sri Eshwar College, Coimbatore',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Icon(Icons.notifications_outlined, color: Colors.black),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: ToggleButtons(
              isSelected: [_selectedIndex == 0, _selectedIndex == 1],
              onPressed: (int index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              borderRadius: BorderRadius.circular(10),
              borderColor: const Color(0xFFFF460A),
              selectedBorderColor: const Color(0xFFFF460A),
              fillColor: Colors.orange.shade100,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Active Orders',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFFF460A),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Past Orders',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFFF460A),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10),
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFFF460A),
                    Color.fromARGB(255, 255, 113, 66),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (acceptedOrders.isNotEmpty) ...[
                      GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1.5,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                        ),
                        itemCount: acceptedOrders.length,
                        itemBuilder: (context, index) {
                          final order = acceptedOrders[index];
                          return OrderCard(
                            order: order,
                            onOrderAccept: updateOrderStatus,
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      const Divider(color: Colors.white),
                    ],

                    GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1.5,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                      ),
                      itemCount: pendingOrders.length,
                      itemBuilder: (context, index) {
                        final order = pendingOrders[index];
                        return OrderCard(
                          order: order,
                          onOrderAccept: updateOrderStatus,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
