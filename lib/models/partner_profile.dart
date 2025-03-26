import 'package:cloud_firestore/cloud_firestore.dart';

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
    await _db.collection('delivery_partners').doc(partnerId).set({
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
}
