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
  final bool isBestseller;
  final bool isNewArrival;
  final DateTime createdAt;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.coverImageUrl,
    required this.genre,
    required this.price,
    required this.rating,
    required this.reviewCount,
    this.isBestseller = false,
    this.isNewArrival = false,
    required this.createdAt,
  });

  /// Factory to create a Book from Firestore map
  factory Book.fromMap(String id, Map<String, dynamic> data) {
    final createdAtRaw = data['createdAt'];
    DateTime createdAt;
    if (createdAtRaw == null) {
      createdAt = DateTime.now();
    } else if (createdAtRaw is Timestamp) {
      createdAt = createdAtRaw.toDate();
    } else if (createdAtRaw is DateTime) {
      createdAt = createdAtRaw;
    } else {
      createdAt = DateTime.tryParse(createdAtRaw.toString()) ?? DateTime.now();
    }

    return Book(
      id: id,
      title: (data['title'] as String?) ?? '',
      author: (data['author'] as String?) ?? '',
      description: (data['description'] as String?) ?? '',
      coverImageUrl: (data['coverImageUrl'] as String?) ??
          (data['cover_image'] as String?) ??
          '',
      genre: (data['genre'] as String?) ?? 'Other',
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: (data['reviewCount'] as num?)?.toInt() ?? 0,
      isBestseller: (data['isBestseller'] as bool?) ?? false,
      isNewArrival: (data['isNewArrival'] as bool?) ?? false,
      createdAt: createdAt,
    );
  }

  /// Factory from DocumentSnapshot
  factory Book.fromSnapshot(DocumentSnapshot doc) =>
      Book.fromMap(doc.id, doc.data() as Map<String, dynamic>);

  /// Convert Book to Firestore map
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
      'isBestseller': isBestseller,
      'isNewArrival': isNewArrival,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
