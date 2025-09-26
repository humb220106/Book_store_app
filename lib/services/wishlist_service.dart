// lib/services/wishlist_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/book.dart';

class WishlistService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Current signed-in user id (nullable)
  static String? get _uid => _auth.currentUser?.uid;

  static CollectionReference<Map<String, dynamic>> _userWishlistRef(String uid) {
    return _firestore.collection('users').doc(uid).collection('wishlist');
  }

  /// Add book to wishlist (save full book map)
  static Future<void> addToWishlist(Book book) async {
    final uid = _uid;
    if (uid == null) return;
    await _userWishlistRef(uid).doc(book.id).set({
      ...book.toMap(), // store all fields
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  /// Remove book from wishlist
  static Future<void> removeFromWishlist(String bookId) async {
    final uid = _uid;
    if (uid == null) return;
    await _userWishlistRef(uid).doc(bookId).delete();
  }

  /// One-time check: is book in wishlist?
  static Future<bool> isInWishlist(String bookId) async {
    final uid = _uid;
    if (uid == null) return false;
    final doc = await _userWishlistRef(uid).doc(bookId).get();
    return doc.exists;
  }

  /// Live stream: is book in wishlist? (use StreamBuilder for live heart icon)
  static Stream<bool> isInWishlistStream(String bookId) {
    final uid = _uid;
    if (uid == null) return const Stream.empty();
    return _userWishlistRef(uid)
        .doc(bookId)
        .snapshots()
        .map((snap) => snap.exists);
  }

  /// Live list of user's wishlist books
  static Stream<List<Book>> getWishlistStream() {
    final uid = _uid;
    if (uid == null) return const Stream.empty();
    return _userWishlistRef(uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) =>
            snap.docs.map((d) => Book.fromMap(d.id, d.data())).toList());
  }

  /// Optional helper: get wishlist once (non-live)
  static Future<List<Book>> getWishlistOnce() async {
    final uid = _uid;
    if (uid == null) return [];
    final snap = await _userWishlistRef(uid).get();
    return snap.docs.map((d) => Book.fromMap(d.id, d.data())).toList();
  }
}
