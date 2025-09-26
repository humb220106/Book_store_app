
import 'package:cloud_firestore/cloud_firestore.dart';

class Book {
  final String id;
  final String title;
  final String author;
  final String description;
  final String coverImageUrl;
  final String genre;
  final double price;
  final double rating;
  final int reviewCount;
  final bool isFeatured;
  final bool isBestseller;
  final bool isNewArrival;
  final DateTime createdAt;

  Book({
    required this.id,
    required this.title,
    required this.author,
    this.description = "",
    this.coverImageUrl = "",
    this.genre = "Other",
    this.price = 0.0,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.isFeatured = false,
    this.isBestseller = false,
    this.isNewArrival = false,
    required this.createdAt,
  });

  /// ✅ Convert Book to Firestore map (without `id`, since Firestore doc.id already stores it)
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'author': author,
      'description': description,
      'coverImageUrl': coverImageUrl,
      'genre': genre,
      'price': price,
      'rating': rating,
      'reviewCount': reviewCount,
      'isFeatured': isFeatured,
      'isBestseller': isBestseller,
      'isNewArrival': isNewArrival,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  /// ✅ Create Book from Firestore map
  factory Book.fromMap(String id, Map<String, dynamic> data) {
    return Book(
      id: id,
      title: (data['title'] as String?) ?? '',
      author: (data['author'] as String?) ?? '',
      description: (data['description'] as String?) ?? '',
      coverImageUrl: (data['coverImageUrl'] as String?) ?? '',
      genre: (data['genre'] as String?) ?? 'Other',
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: (data['reviewCount'] as num?)?.toInt() ?? 0,
      isFeatured: (data['isFeatured'] as bool?) ?? false,
      isBestseller: (data['isBestseller'] as bool?) ?? false,
      isNewArrival: (data['isNewArrival'] as bool?) ?? false,
      createdAt: (data['createdAt'] is Timestamp)
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  /// ✅ Shortcut for DocumentSnapshot
  factory Book.fromSnapshot(DocumentSnapshot doc) =>
      Book.fromMap(doc.id, doc.data() as Map<String, dynamic>);
}
