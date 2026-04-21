import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String? uid = FirebaseAuth.instance.currentUser?.uid;

  //Create user profile
  Future<void> createUserProfile(String name, String email) async {
    await _db.collection('users').doc(uid).set({
      'uid': uid,
      'email': email,
      'createdAt': FieldValue.serverTimestamp(),
      'displayName': name,
    });
  }

  //Create photo entry
  Future<void> addEntry(String title, String imageUrl, String text) async {
    // NEW: Root/Default path
    await FirebaseFirestore.instance
        .collection('entries') // This puts it at the root level!
        .add({
          'userId': FirebaseAuth.instance.currentUser!.uid,
          'title': title,
          'text': text,
          'imageUrl': imageUrl,
          'timestamp': FieldValue.serverTimestamp(),
        });
  }

  Stream<QuerySnapshot> getEntries() {
    return _db
        .collection('entries')
        .where('userId', isEqualTo: uid)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}
