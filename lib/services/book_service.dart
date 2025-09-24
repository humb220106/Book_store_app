import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/book.dart';

class BookService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Seed default books into Firestore if collection is empty
  static Future<void> seedDefaultBooks() async {
    final snapshot = await _firestore.collection('books').limit(1).get();
    if (snapshot.docs.isNotEmpty) return; // Already has books, no need to seed

    final defaults = [
      Book(
        id: "1",
        title: "Flutter for Beginners",
        author: "John Doe",
        description: "Learn Flutter from scratch with examples.",
        coverImageUrl: "https://via.placeholder.com/200x300.png?text=Flutter",
        genre: "Programming",
        price: 19.99,
        rating: 4.5,
        reviewCount: 12,
        isFeatured: true,
        isBestseller: false,
        isNewArrival: true,
        createdAt: DateTime.now(),
      ),
      Book(
        id: "2",
        title: "Dart Mastery",
        author: "Jane Smith",
        description: "Deep dive into Dart language features.",
        coverImageUrl: "https://via.placeholder.com/200x300.png?text=Dart",
        genre: "Programming",
        price: 24.99,
        rating: 4.8,
        reviewCount: 20,
        isFeatured: false,
        isBestseller: true,
        isNewArrival: false,
        createdAt: DateTime.now(),
      ),
      Book(
        id: "3",
        title: "The Startup Guide",
        author: "Alice Johnson",
        description: "Business strategies for tech startups.",
        coverImageUrl: "https://via.placeholder.com/200x300.png?text=Business",
        genre: "Business",
        price: 29.99,
        rating: 4.2,
        reviewCount: 8,
        isFeatured: true,
        isBestseller: true,
        isNewArrival: false,
        createdAt: DateTime.now(),
      ),
    ];

  for (var book in defaults) {
    final now = DateTime.now();
    await _firestore.collection('books').doc(book.id).set({
      ...book.toMap(),
      'createdAt': FieldValue.serverTimestamp(),
      'createdAtLocal': now,
    });
  }
}

/// Get all books
static Future<List<Book>> getBooks() async {
  final snap = await _firestore
      .collection('books')
      .orderBy('createdAtLocal', descending: true)
      .get();
  return snap.docs.map((d) => Book.fromMap(d.id, d.data())).toList();
}

/// Stream all books (for UI)
// static Stream<List<Book>> getBooksStream() {
//   return _firestore
//       .collection('books')
//       .orderBy('createdAt', descending: true)
//       .snapshots()
//       .map(
//         (snap) =>
//             snap.docs.map((doc) => Book.fromMap(doc.id, doc.data())).toList(),
//       );
// }

//   static Stream<List<Book>> getBooksStream() {
//   return _firestore
//       .collection('books')
//       .orderBy('createdAt', descending: true)
//       .orderBy('createdAtLocal', descending: true) // ✅ fallback ordering
//       .snapshots()
//       .map(
//         (snap) => snap.docs
//             .map((d) => Book.fromMap(d.id, d.data()))
//             .toList(),
//       );
// }

static Stream<List<Book>> getBooksStream() {
  return _firestore
      .collection('books')
      .orderBy('createdAtLocal', descending: true) // only one field
      .snapshots()
      .map(
        (snap) => snap.docs.map((d) => Book.fromMap(d.id, d.data())).toList(),
      );
}

  // Optional: fetch all books once
  //   static Future<List<Book>> getBooks() async {
  //     final snap = await _firestore
  //         .collection('books')
  //         .orderBy('createdAtLocal', descending: true)
  //         .get();
  //     return snap.docs.map((d) => Book.fromMap(d.id, d.data())).toList();
  //   }
  // }

  /// Get all unique genres
  static Future<List<String>> getAllGenres() async {
    final snapshot = await _firestore.collection('books').get();
    final genres = snapshot.docs
        .map((doc) => doc['genre']?.toString() ?? 'Other')
        .toSet()
        .toList();
    genres.sort();
    return genres;
  }

  /// Get all unique authors
  static Future<List<String>> getAllAuthors() async {
    final snapshot = await _firestore.collection('books').get();
    final authors = snapshot.docs
        .map((doc) => doc['author']?.toString() ?? 'Unknown')
        .toSet()
        .toList();
    authors.sort();
    return authors;
  }

  /// Get min & max price from all books
  static Future<Map<String, double>> getPriceRange() async {
    final snapshot = await _firestore.collection('books').get();

    if (snapshot.docs.isEmpty) {
      return {"min": 0.0, "max": 100.0};
    }

    final prices = snapshot.docs
        .map((doc) => (doc['price'] as num?)?.toDouble() ?? 0.0)
        .toList();

    prices.sort();
    return {"min": prices.first, "max": prices.last};
  }

  /// Get filtered books
  static Future<List<Book>> getFilteredBooks({
    List<String>? genres,
    List<String>? authors,
    bool? bestsellersOnly,
    bool? newArrivalsOnly,
    double? minPrice,
    double? maxPrice,
    double? minRating,
  }) async {
    Query query = _firestore.collection('books');

    if (genres != null && genres.isNotEmpty) {
      query = query.where(
        'genre',
        whereIn: genres.length > 10 ? genres.sublist(0, 10) : genres,
      );
    }

    if (authors != null && authors.isNotEmpty) {
      query = query.where(
        'author',
        whereIn: authors.length > 10 ? authors.sublist(0, 10) : authors,
      );
    }

    if (bestsellersOnly == true) {
      query = query.where('isBestseller', isEqualTo: true);
    }
    if (newArrivalsOnly == true) {
      query = query.where('isNewArrival', isEqualTo: true);
    }
    if (minPrice != null) {
      query = query.where('price', isGreaterThanOrEqualTo: minPrice);
    }
    if (maxPrice != null) {
      query = query.where('price', isLessThanOrEqualTo: maxPrice);
    }

    final snapshot = await query.get();
    List<Book> books = snapshot.docs
        .map((doc) => Book.fromMap(doc.id, doc.data() as Map<String, dynamic>))
        .toList();

    if (minRating != null) {
      books = books.where((b) => (b.rating ?? 0.0) >= minRating).toList();
    }

    return books;
  }
}
