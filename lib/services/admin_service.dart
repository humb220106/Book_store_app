// lib/services/admin_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/book.dart';
import '../models/user_model.dart';

class AdminService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // ---------- BOOK CRUD ----------
static Future<void> addBook(Book book) async {
  final doc = _firestore.collection('books').doc(book.id);
  final now = DateTime.now();

  await doc.set({
    ...book.toMap(),
    'createdAt': FieldValue.serverTimestamp(), // ✅ authoritative server timestamp
    'createdAtLocal': now,                     // ✅ fallback for instant local ordering
  });
}



  static Future<void> updateBook(Book book) async {
    await _firestore.collection('books').doc(book.id).update({
      ...book.toMap(),
      'updatedAt': FieldValue.serverTimestamp(), // optional
    });
  }

  static Future<void> deleteBook(String bookId) async {
    await _firestore.collection('books').doc(bookId).delete();
  }

  // static Stream<List<Book>> booksStream() {
  //   return _firestore
  //       .collection('books')
  //       .orderBy('createdAt', descending: true)
  //       .snapshots()
  //       .map(
  //         (snap) => snap.docs.map((d) => Book.fromMap(d.id, d.data())).toList(),
  //       );
  // }

//   static Stream<List<Book>> booksStream() {
//   return _firestore
//       .collection('books')
//       .orderBy('createdAt', descending: true)
//       .orderBy('createdAtLocal', descending: true) // 👈 fallback
//       .snapshots()
//       .map(
//         (snap) => snap.docs
//             .map((d) => Book.fromMap(d.id, d.data()))
//             .toList(),
//       );
// }

   static Stream<List<Book>> booksStream() {
  return _firestore
      .collection('books')
      .orderBy('createdAtLocal', descending: true)
      .snapshots()
      .map(
        (snap) => snap.docs.map((d) => Book.fromMap(d.id, d.data())).toList(),
      );
}
  // ---------- USER DOCUMENTS ----------
  static Stream<List<UserModel>> usersStream() {
    return _firestore
        .collection('users')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snap) =>
              snap.docs.map((d) => UserModel.fromMap(d.id, d.data())).toList(),
        );
  }

  static Future<UserModel?> getUserDoc(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (!doc.exists) return null;
    return UserModel.fromMap(doc.id, doc.data());
  }

  static Future<void> setUserDoc(UserModel user) async {
    await _firestore.collection('users').doc(user.uid).set(user.toMap());
  }

  static Future<void> updateUserDoc(
    String uid,
    Map<String, dynamic> update,
  ) async {
    await _firestore.collection('users').doc(uid).update(update);
  }

  static Future<void> deleteUserDoc(String uid) async {
    await _firestore.collection('users').doc(uid).delete();
    // ⚠ Note: deleting a user document does NOT delete the Auth account (Admin SDK required).
  }

  // ---------- ORDERS ----------
  static Stream<List<Map<String, dynamic>>> ordersStream() {
    return _firestore
        .collection('orders')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snap) => snap.docs.map((d) {
            final data = d.data();
            data['id'] = d.id;
            return data;
          }).toList(),
        );
  }

  static Future<void> updateOrderStatus(
    String orderId,
    String newStatus,
  ) async {
    await _firestore.collection('orders').doc(orderId).update({
      'status': newStatus,
    });
  }

  static Future<void> deleteOrder(String orderId) async {
    await _firestore.collection('orders').doc(orderId).delete();
  }

  // ---------- ADMIN CHECK ----------
  static Future<bool> isCurrentUserAdmin({
    String? fallbackAdminEmail = "admin@bookapp.com",
  }) async {
    final email = _auth.currentUser?.email;

    // 1) Local fallback admin (hardcoded for your use case)
    if (email == fallbackAdminEmail) {
      return true;
    }

    // 2) Firestore check (if user is marked as admin)
    try {
      if (_auth.currentUser != null) {
        final doc = await _firestore
            .collection('users')
            .doc(_auth.currentUser!.uid)
            .get();
        if (doc.exists && (doc['isAdmin'] as bool? ?? false)) {
          return true;
        }
      }
    } catch (_) {}

    return false;
  }

  // ---------- GET CURRENT USER EMAIL ----------
  static String? getCurrentUserEmail() {
    return _auth.currentUser?.email;
  }

  // ---------- SIGN OUT ----------
  static Future<void> signOut() async {
    await _auth.signOut();
  }
}
