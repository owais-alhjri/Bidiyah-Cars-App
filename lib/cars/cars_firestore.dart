import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference cars =
  FirebaseFirestore.instance.collection('cars');

  Future<void> addCar( String name, String imageURL,
      String description, double price, String model) {
    return cars.add({
      'name': name,
      'imageURL': imageURL,
      'description': description,
      'price': price,
      'model': model,
    });
  }

  Stream<QuerySnapshot> getCarsStream() {
    return cars.snapshots();
  }
}





