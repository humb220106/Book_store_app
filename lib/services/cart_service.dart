import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/book.dart';

class CartService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static String? get _uid => FirebaseAuth.instance.currentUser?.uid;

  /// Add book to cart (increments quantity by 1, creates doc if missing)
  static Future<void> addToCart(Book book) async {
    final uid = _uid;
    if (uid == null) return; // not logged in

    final docRef = _firestore.collection('users').doc(uid).collection('cart').doc(book.id);

    // merge so we can increment quantity while keeping book fields
    await docRef.set({
      ...book.toMap(), // book fields
      'quantity': FieldValue.increment(1),
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  /// Decrement quantity by 1. If quantity becomes <= 0, remove doc.
  static Future<void> decrementQuantity(Book book) async {
    final uid = _uid;
    if (uid == null) return;

    final docRef = _firestore.collection('users').doc(uid).collection('cart').doc(book.id);

    await _firestore.runTransaction((tx) async {
      final snap = await tx.get(docRef);
      if (!snap.exists) return;
      final data = snap.data()!;
      final current = (data['quantity'] as num?)?.toInt() ?? 1;
      if (current <= 1) {
        tx.delete(docRef);
      } else {
        tx.update(docRef, {'quantity': FieldValue.increment(-1)});
      }
    });
  }

  /// Remove item from cart completely
  static Future<void> removeFromCart(Book book) async {
    final uid = _uid;
    if (uid == null) return;
    await _firestore.collection('users').doc(uid).collection('cart').doc(book.id).delete();
  }

  /// Raw snapshot stream (QuerySnapshot) — useful when you need quantity and raw fields
  static Stream<QuerySnapshot<Map<String, dynamic>>> getRawCartStream() {
    final uid = _uid;
    if (uid == null) return const Stream.empty();
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('cart')
        .orderBy('createdAt', descending: false)
        .snapshots();
  }

  /// Convenience stream that maps to List<Book> (quantity ignored)
  static Stream<List<Book>> getCartStream() {
    final uid = _uid;
    if (uid == null) return const Stream.empty();
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('cart')
        .snapshots()
        .map((snap) => snap.docs
            .map((doc) => Book.fromMap(doc.id, doc.data() as Map<String, dynamic>))
            .toList());
  }

  /// Clear entire cart
  static Future<void> clearCart() async {
    final uid = _uid;
    if (uid == null) return;
    final items = await _firestore.collection('users').doc(uid).collection('cart').get();
    for (var doc in items.docs) {
      await doc.reference.delete();
    }
  }
}
