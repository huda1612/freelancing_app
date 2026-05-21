import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freelancing_platform/core/constants/data_constsnats/collections_names.dart';

class FcmTokenArrayService {
  FcmTokenArrayService({
    FirebaseFirestore? firebaseFirestore,
  }) : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firebaseFirestore;

  Future<void> addToken({
    required String uid,
    required String token,
  }) async {
    await _firebaseFirestore
        .collection(CollectionsNames.users)
        .doc(uid)
        .update({
      'fcmTokens': FieldValue.arrayUnion([token]),
    });
  }

  Future<void> removeToken({
    required String uid,
    required String token,
  }) async {
    await _firebaseFirestore
        .collection(CollectionsNames.users)
        .doc(uid)
        .update({
      'fcmTokens': FieldValue.arrayRemove([token]),
    });
  }

  Future<void> replaceToken({
    required String uid,
    required String oldToken,
    required String newToken,
  }) async {
    if (oldToken == newToken) return;
    // حذف oldToken
    if (oldToken.isNotEmpty) {
      await _firebaseFirestore
          .collection(CollectionsNames.users)
          .doc(uid)
          .update({
        'fcmTokens': FieldValue.arrayRemove([oldToken]),
      });
    }
    // إضافة newToken
    await _firebaseFirestore
        .collection(CollectionsNames.users)
        .doc(uid)
        .update({
      'fcmTokens': FieldValue.arrayUnion([newToken]),
    });
  }
}
