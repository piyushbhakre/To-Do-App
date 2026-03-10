import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:herody_assignment/core/constants/firebase_collections.dart';

class UserProfileService {
  UserProfileService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Future<void> createUserProfile({
    required String uid,
    required String username,
    required String email,
    required String encryptedPassword,
  }) {
    return _firestore.collection(FirebaseCollections.users).doc(uid).set({
      'uid': uid,
      'username': username,
      'email': email,
      'encryptedPassword': encryptedPassword,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<Map<String, dynamic>?> getUserProfile(String uid) async {
    final snapshot =
        await _firestore.collection(FirebaseCollections.users).doc(uid).get();
    return snapshot.data();
  }
}
