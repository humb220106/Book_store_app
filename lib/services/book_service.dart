import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/book.dart';

class BookService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Get all books
  static Future<List<Book>> getBooks() async {
    final snapshot = await _firestore.collection('books').get();
    return snapshot.docs
        .map((doc) => Book.fromMap(doc.id, doc.data()))
        .toList();
  }

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
          'genre', whereIn: genres.length > 10 ? genres.sublist(0, 10) : genres);
    }

    if (authors != null && authors.isNotEmpty) {
      query = query.where(
          'author', whereIn: authors.length > 10 ? authors.sublist(0, 10) : authors);
    }

    if (bestsellersOnly == true) query = query.where('isBestseller', isEqualTo: true);
    if (newArrivalsOnly == true) query = query.where('isNewArrival', isEqualTo: true);
    if (minPrice != null) query = query.where('price', isGreaterThanOrEqualTo: minPrice);
    if (maxPrice != null) query = query.where('price', isLessThanOrEqualTo: maxPrice);

    final snapshot = await query.get();
    List<Book> books =
        snapshot.docs.map((doc) => Book.fromMap(doc.id, doc.data() as Map<String, dynamic>)).toList();

    if (minRating != null) {
      books = books.where((b) => (b.rating ?? 0.0) >= minRating).toList();
    }

    return books;
  }
}
