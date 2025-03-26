import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatelessWidget {
  final double latitude;
  final double longitude;

  const MapScreen({super.key, required this.latitude, required this.longitude});

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
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: FlutterMap(
              mapController: MapController(),
              options: MapOptions(
                initialCenter: LatLng(latitude, longitude),
                initialZoom: 15.0,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      width: 50.0,
                      height: 50.0,
                      point: LatLng(latitude, longitude),
                      child: const Icon(
                        Icons.location_pin,
                        size: 40.0,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
