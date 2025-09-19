import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/book.dart';

class WishlistService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String userId = 'default_user'; // Replace with real user auth id

  static Future<List<Book>> getWishlist() async {
    final snapshot = await _firestore
        .collection('wishlists')
        .doc(userId)
        .collection('books')
        .get();

    return snapshot.docs.map((doc) => Book.fromMap(doc.id, doc.data())).toList();
  }

  static Future<void> addToWishlist(Book book) async {
    await _firestore
        .collection('wishlists')
        .doc(userId)
        .collection('books')
        .doc(book.id)
        .set(book.toMap());
  }

  static Future<void> removeFromWishlist(String bookId) async {
    await _firestore
        .collection('wishlists')
        .doc(userId)
        .collection('books')
        .doc(bookId)
        .delete();
  }

  static Future<bool> isInWishlist(String bookId) async {
    final doc = await _firestore
        .collection('wishlists')
        .doc(userId)
        .collection('books')
        .doc(bookId)
        .get();
    return doc.exists;
  }
}
