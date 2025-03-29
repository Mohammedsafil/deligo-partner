import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';

class SosBuilder extends StatefulWidget {
  const SosBuilder({super.key});

  @override
  State<SosBuilder> createState() => _SosBuilderState();
}

class _SosBuilderState extends State<SosBuilder> {
  @override
  Widget build(BuildContext context) {
    return _buildSOSSection();
  }

  Widget _buildSOSSection() {
    return GestureDetector(
      onTap: () async {
        _showSOSDialog();
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFFFF4B3A),
          borderRadius: BorderRadius.circular(10),
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
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'SOS',
              style: GoogleFonts.lato(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSOSDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Confirm SOS"),
            content: const Text("Do you want to send an SOS alert?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _makeSOSCall();
                  _sendSOSMessage();
                },
                child: const Text(
                  "Send SOS",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }

  Future<void> _sendSOSMessage() async {
    String location = await _getCurrentLocation();
    String message =
        "🚨 SOS Alert! I need help. My current location is:\n$location";

    String phoneNumber = "1234567890"; // Change to emergency contact

    // SMS
    Uri smsUri = Uri.parse("sms:$phoneNumber?body=$message");
    if (await canLaunchUrl(smsUri)) {
      await launchUrl(smsUri);
    } else {
      debugPrint("Could not send SMS");
    }

    // WhatsApp
    Uri whatsappUri = Uri.parse("https://wa.me/$phoneNumber?text=$message");
    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri);
    } else {
      debugPrint("Could not send WhatsApp message");
    }
  }

  Future<void> _makeSOSCall() async {
    const String emergencyNumber = "tel:112"; // Change to your desired number
    if (await canLaunchUrl(Uri.parse(emergencyNumber))) {
      await launchUrl(Uri.parse(emergencyNumber));
    } else {
      debugPrint("Could not launch call");
    }
  }

  Future<String> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return "Location access denied";
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      return "https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}";
    } catch (e) {
      return "Unable to fetch location";
    }
  }
}
