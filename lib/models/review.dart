import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  final String id;
  final String userId;
  final String bookId;
  final int rating;
  final String comment;
  final DateTime date;
  final List<String> likes;

  Review({
    required this.id,
    required this.userId,
    required this.bookId,
    required this.rating,
    required this.comment,
    required this.date,
    required this.likes,
  });

  // Convert Review object to Firestore map
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'bookId': bookId,
      'rating': rating,
      'comment': comment,
      'date': Timestamp.fromDate(date), // Always save as Timestamp
      'likes': likes,
    };
  }

  // Create Review object from Firestore map
  factory Review.fromMap(Map<String, dynamic> map, String id) {
    final dynamic dateValue = map['date'];
    DateTime parsedDate;

    if (dateValue is Timestamp) {
      parsedDate = dateValue.toDate();
    } else if (dateValue is String) {
      parsedDate = DateTime.parse(dateValue);
    } else {
      parsedDate = DateTime.now(); // fallback to current time
    }

    return Review(
      id: id,
      userId: map['userId'] ?? '',
      bookId: map['bookId'] ?? '',
      rating: map['rating'] ?? 0,
      comment: map['comment'] ?? '',
      date: parsedDate,
      likes: List<String>.from(map['likes'] ?? []),
    );
  }
}
