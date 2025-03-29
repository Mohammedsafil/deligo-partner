import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_core/firebase_core.dart";
import "package:flutter/material.dart";
import "package:geocoding/geocoding.dart";
import "package:geolocator/geolocator.dart";
import "package:google_fonts/google_fonts.dart";
import "/widgets/order_card.dart";
import "/models/order.dart" as myOrder;
import "../widgets/bottom_navbar.dart";
import "./payment_screen.dart";
import "./profile_screen.dart";

class OrdersScreen extends StatefulWidget {
  final String partnerId;
  OrdersScreen({super.key, required this.partnerId});

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  List<myOrder.Order> orders = [];
  String currentLocation = "Fetching location...";

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    fetchItemsFromFirestore();
  }

  Future<void> fetchItemsFromFirestore() async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      QuerySnapshot snapshot = await firestore.collection('Orders').get();

      List<myOrder.Order> fetchedOrders =
          snapshot.docs.map((doc) {
            var data = doc.data() as Map<String, dynamic>;
            return myOrder.Order(
              id: data['orderId'],
              customerName: data['customerName'],
              delivery: data['deliveryType'],
              orderDate: (data['orderDate'] as Timestamp).toDate(),
              orderedItems: List<Map<String, dynamic>>.from(
                (data['orderedItems'] as List).map(
                  (item) => Map<String, dynamic>.from(item),
                ),
              ),
              subTotal: (data['subtotal'] as num).toDouble(),
              deliveryCost: (data['deliveryCost'] as num).toDouble(),
              totalCost: (data['totalCost'] as num).toDouble(),
              status: data['status'],
              paymentMethod: data['paymentMethod'],
              deliveryLocation:
                  data['deliveryLocation'] is GeoPoint
                      ? "${(data['deliveryLocation'] as GeoPoint).latitude}, ${(data['deliveryLocation'] as GeoPoint).longitude}"
                      : (data['deliveryLocation'] ?? 'Unknown location'),
              distance: (data['distance'] as num).toDouble(),
              mobile: data['mobile'],
            );
          }).toList();
      print(fetchedOrders);
      setState(() {
        orders = fetchedOrders;
      });
    } catch (e) {
      print("Error fetching orders: $e");
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.deniedForever) {
          setState(() {
            currentLocation = "Location permission denied";
          });
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      Placemark place = placemarks[0];
      setState(() {
        currentLocation =
            "${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
      });
    } catch (e) {
      setState(() {
        currentLocation = "Failed to get location";
      });
    }
  }

  void updateOrderStatus(String orderId, String newStatus) async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance
              .collection('Orders')
              .where('orderId', isEqualTo: orderId)
              .get();

      if (querySnapshot.docs.isNotEmpty) {
        String docId = querySnapshot.docs.first.id;

        await FirebaseFirestore.instance.collection('Orders').doc(docId).update(
          {'status': newStatus},
        );

        double amount = (querySnapshot.docs.first['totalCost'] ?? 0).toDouble();
        String type =
            (["upi", "credit card", "debit card"].contains(
                  querySnapshot.docs.first['paymentMethod'].toLowerCase(),
                ))
                ? "online"
                : "cash";
        print(amount);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Order status updated to $newStatus',
              style: GoogleFonts.inter(fontSize: 16, color: Colors.white),
            ),
          ),
        );
        if (newStatus == 'delivered') {
          QuerySnapshot partnerSnapshot =
              await FirebaseFirestore.instance
                  .collection('delivery_partners')
                  .where('mobile_no', isEqualTo: "+91 7989378657")
                  .get();
          if (partnerSnapshot.docs.isNotEmpty) {
            String docId = partnerSnapshot.docs.first.id;

            int currentDeliveries =
                partnerSnapshot
                    .docs
                    .first['delivery_statistics']['deliveries'] ??
                0;
            await FirebaseFirestore.instance
                .collection('delivery_partners')
                .doc(docId)
                .update({
                  'delivery_statistics.deliveries': currentDeliveries + 1,
                });
            await FirebaseFirestore.instance.collection("transaction").add({
              "amount": amount,
              "date": DateTime.now(),
              "orderId": orderId,
              "partnerNumber": widget.partnerId,
              "type": type,
            });
          }
        }
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OrdersScreen(partnerId: widget.partnerId,)),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Order not found!')));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to update status: $e')));
    }
  }

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<myOrder.Order> acceptedOrders =
        orders
            .where(
              (order) =>
                  order.status != "delivered" && order.status != "pickup",
            )
            .toList();
    List<myOrder.Order> pendingOrders =
        orders.where((order) => order.status == "pickup").toList();
    List<myOrder.Order> deliveredOrders =
        orders.where((order) => order.status == "delivered").toList();

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.location_on_rounded, color: const Color(0xFFFF460A)),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Current Location', style: GoogleFonts.inter()),
                      Text(
                        currentLocation,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        softWrap: true,
                        overflow: TextOverflow.visible,
                      ),
                    ],
                  ),
                ),
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
                    if (orders.isEmpty) ...[
                      Text(
                        'No orders found',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ] else ...[
                      if (acceptedOrders.isNotEmpty) ...[
                        GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
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
                      ] else if ((pendingOrders.isEmpty &&
                              _selectedIndex == 0) ||
                          (deliveredOrders.isEmpty && _selectedIndex == 1)) ...[
                        Text(
                          'No orders found',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
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
                        itemCount:
                            _selectedIndex == 0
                                ? pendingOrders.length
                                : deliveredOrders.length,
                        itemBuilder: (context, index) {
                          final order =
                              _selectedIndex == 0
                                  ? pendingOrders[index]
                                  : deliveredOrders[index];
                          return OrderCard(
                            order: order,
                            onOrderAccept: updateOrderStatus,
                          );
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
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