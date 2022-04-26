import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreDatabaseFunctions {
  FirestoreDatabaseFunctions._privateConstructor();
  static final FirestoreDatabaseFunctions shared =
      FirestoreDatabaseFunctions._privateConstructor();

  Future<void> addData(
    String collection,
    Map<String, dynamic> data,
  ) async {
    await FirebaseFirestore.instance.collection(collection).add(data);
  }
}
