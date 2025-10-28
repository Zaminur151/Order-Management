import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String collection = 'order';
  FirebaseFirestore instance = FirebaseFirestore.instance;

  // Create
  Future addToDatabase(String uid, String dish, String softDr, double spice) async{
    return await instance.collection(collection).doc(uid).set({
      'dish' : dish,
      'uid' : uid,
      'softDr' : softDr,
      'spice' : spice
    });
  }
  
  // Read
  Stream<QuerySnapshot> get getData{
    return instance.collection(collection).snapshots();
  }

  // Update
  Future updateData(String uid, String dish, String softDr, double spice) async{
    return await instance.collection(collection).doc(uid).update({
      'dish' : dish,
      'uid' : uid,
      'softDr' : softDr,
      'spice' : spice
    }
    );
  }

  // Delete
  Future deleteData(String uid) async{
    return await instance.collection(collection).doc(uid).delete();
  }
}