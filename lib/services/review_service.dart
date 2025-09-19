import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/review.dart';

class ReviewService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Add a new review
  static Future<void> addReview(Review review) async {
    final reviewRef = _firestore
        .collection('books')
        .doc(review.bookId)
        .collection('reviews')
        .doc();

    await reviewRef.set(review.toMap());
  }

  /// Get all reviews for a book
  static Future<List<Review>> getReviews(String bookId) async {
    final snapshot = await _firestore
        .collection('books')
        .doc(bookId)
        .collection('reviews')
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => Review.fromMap(doc.id, doc.data()))
        .toList();
  }

  /// Calculate average rating
  static Future<double> getAverageRating(String bookId) async {
    final snapshot = await _firestore
        .collection('books')
        .doc(bookId)
        .collection('reviews')
        .get();

    if (snapshot.docs.isEmpty) return 0;

    final ratings =
        snapshot.docs.map((doc) => (doc['rating'] ?? 0).toDouble()).toList();
    final total = ratings.reduce((a, b) => a + b);
    return total / ratings.length;
  }
}
