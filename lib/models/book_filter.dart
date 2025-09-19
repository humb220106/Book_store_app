class BookFilter {
  final bool bestsellersOnly;
  final bool newArrivalsOnly;
  final String searchQuery;
  final double? minPrice;
  final double? maxPrice;
  final double? minRating;
  final List<String>? genres;
  final List<String>? authors;

  BookFilter({
    this.bestsellersOnly = false,
    this.newArrivalsOnly = false,
    this.searchQuery = '',
    this.minPrice,
    this.maxPrice,
    this.minRating,
    this.genres,
    this.authors,
  });

  BookFilter copyWith({
    bool? bestsellersOnly,
    bool? newArrivalsOnly,
    String? searchQuery,
    double? minPrice,
    double? maxPrice,
    double? minRating,
    List<String>? genres,
    List<String>? authors,
  }) {
    return BookFilter(
      bestsellersOnly: bestsellersOnly ?? this.bestsellersOnly,
      newArrivalsOnly: newArrivalsOnly ?? this.newArrivalsOnly,
      searchQuery: searchQuery ?? this.searchQuery,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      minRating: minRating ?? this.minRating,
      genres: genres ?? this.genres,
      authors: authors ?? this.authors,
    );
  }
}
