import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/review.dart';

class ReviewService {
  static final _collection = FirebaseFirestore.instance.collection('reviews');

  // Add review
  static Future<void> addReview(Review review) async {
    await _collection.add(review.toMap());
  }

  // 🔹 Simple version (no index required)
  static Stream<List<Review>> getReviewsSimple(String bookId) {
    return _collection
        .where('bookId', isEqualTo: bookId)
        .snapshots()
        .map((snapshot) {
          print("📌 Reviews fetched for $bookId: ${snapshot.docs.length}");
          return snapshot.docs
              .map((doc) => Review.fromMap(doc.data(), doc.id))
              .toList();
        });
  }

  // 🔹 Sorted version (requires Firestore index: bookId ASC + date DESC)
  static Stream<List<Review>> getReviewsSorted(String bookId) {
    return _collection
        .where('bookId', isEqualTo: bookId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
          print("📌 Sorted reviews fetched for $bookId: ${snapshot.docs.length}");
          return snapshot.docs
              .map((doc) => Review.fromMap(doc.data(), doc.id))
              .toList();
        });
  }

  // ✅ Add this missing method
  static Stream<List<Review>> getReviewsForBook(String bookId) {
    return getReviewsSimple(bookId); // <-- default
  }

  // Delete review
  static Future<void> deleteReview(String reviewId) async {
    await _collection.doc(reviewId).delete();
  }

  // Overwrite likes array
  static Future<void> updateReviewLikes(String reviewId, List<String> likes) async {
    await _collection.doc(reviewId).update({'likes': likes});
  }

  // Toggle like/unlike
  static Future<void> toggleLike(String reviewId, String userId) async {
    final docRef = _collection.doc(reviewId);
    final snapshot = await docRef.get();

    if (!snapshot.exists) return;

    List likes = snapshot['likes'] ?? [];
    if (likes.contains(userId)) {
      // Unlike
      await docRef.update({
        'likes': FieldValue.arrayRemove([userId])
      });
    } else {
      // Like
      await docRef.update({
        'likes': FieldValue.arrayUnion([userId])
      });
    }
  }
}
