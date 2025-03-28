import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> createProfile(
    String partnerId,
    String name,
    String mobile,
    int deliveries,
    double rating,
    double onTimePercentage,
    String bikeName,
    String numberPlate,
    String license,
  ) async {
    await _db.collection('delivery_partners').doc(mobile).set({
      'name': name,
      'mobile_no': mobile,
      'delivery_statistics': {
        'deliveries': deliveries,
        'rating': rating,
        'on_time_percentage': onTimePercentage,
      },
      'vehicle': {
        'bike_name': bikeName,
        'number_plate': numberPlate,
        'license': license,
      },
    });
  }

  Future<void> updateProfile(
    String partnerId,
    Map<String, dynamic> updates,
  ) async {
    await _db.collection('delivery_partners').doc(partnerId).update(updates);
  }

  Future<void> deleteProfile(String partnerId) async {
    await _db.collection('delivery_partners').doc(partnerId).delete();
  }

  Stream<DocumentSnapshot> getProfileStream(String partnerId) {
    return _db.collection('delivery_partners').doc(partnerId).snapshots();
  }

  Future<void> getTransactionIds() async {
    CollectionReference transactions = FirebaseFirestore.instance.collection(
      'transaction',
    );

    QuerySnapshot snapshot = await transactions.get();

    List<String> transactionIds = snapshot.docs.map((doc) => doc.id).toList();

    print(transactionIds); // Output: ['001', '002']
  }

  Future<void> saveLogin(String mobileNumber) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('partnerMobile', mobileNumber);
    print(mobileNumber);
    print(await prefs.setString('partnerMobile', mobileNumber));
  }

  Future<bool> authPartner(String id) async {
    try {
      print("Checking login for partnerId: $id"); // Debugging log

      QuerySnapshot partnerlog =
          await FirebaseFirestore.instance
              .collection('partnerlogin')
              .where('partnerId', isEqualTo: id)
              .get();

      print("Documents found: ${partnerlog.docs.length}"); // Deb
      return partnerlog.docs.isNotEmpty;
    } catch (e) {
      print("Firestore query error: $e"); // More specific error log
      return false;
    }
  }

  Future<String> checkLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('partnerMobile') ?? '';
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(await prefs.get('partnerMobile'));
    await prefs.remove('partnerMobile');
  }
}
