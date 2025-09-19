import 'package:flutter/material.dart';
import '../../models/book.dart';
import '../../models/book_filter.dart';
import '../../services/book_service.dart';
import '../../services/wishlist_service.dart';
import '../../widgets/filter_bottom_sheet.dart';
import 'book_detail_screen.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({Key? key}) : super(key: key);

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  List<Book> _books = [];
  bool _isGridView = true;
  BookFilter _currentFilter = BookFilter();

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  Future<void> _loadBooks() async {
    final books = await BookService.getBooks();
    setState(() {
      _books = books;
    });
  }

  Future<void> _applyFilter(BookFilter filter) async {
    _currentFilter = filter;
    final filteredBooks = await BookService.getFilteredBooks(
      genres: filter.genres,
      authors: filter.authors,
      bestsellersOnly: filter.bestsellersOnly,
      newArrivalsOnly: filter.newArrivalsOnly,
      minPrice: filter.minPrice,
      maxPrice: filter.maxPrice,
      minRating: filter.minRating,
    );

    setState(() {
      _books = filteredBooks;
    });
  }

  void _openFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => FilterBottomSheet(
        currentFilter: _currentFilter,
        onApply: _applyFilter,
      ),
    );
  }

  void _navigateToBookDetail(Book book) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BookDetailScreen(book: book)),
    );
  }

  Widget _wishlistIcon(Book book) {
    return FutureBuilder<bool>(
      future: WishlistService.isInWishlist(book.id),
      builder: (context, snapshot) {
        final isInWishlist = snapshot.data ?? false;
        return IconButton(
          icon: Icon(
            isInWishlist ? Icons.favorite : Icons.favorite_border,
            color: Colors.red,
          ),
          onPressed: () async {
            if (isInWishlist) {
              await WishlistService.removeFromWishlist(book.id);
            } else {
              await WishlistService.addToWishlist(book);
            }
            setState(() {});
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F0),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5F0),
        elevation: 0,
        title: const Text(
          'Book Catalog',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(_isGridView ? Icons.list : Icons.grid_view),
            onPressed: () => setState(() => _isGridView = !_isGridView),
          ),
          IconButton(
            icon: const Icon(Icons.filter_alt, color: Colors.brown),
            onPressed: _openFilterSheet,
          ),
        ],
      ),
      body: _books.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : _isGridView
          ? GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.65,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: _books.length,
              itemBuilder: (context, index) => _buildBookCard(_books[index]),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _books.length,
              itemBuilder: (context, index) => _buildBookTile(_books[index]),
            ),
    );
  }

  Widget _buildBookCard(Book book) {
    return GestureDetector(
      onTap: () => _navigateToBookDetail(book),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 4,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    book.coverImageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.book, size: 40, color: Colors.brown),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                book.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Text(
                book.author,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          Positioned(top: 4, right: 4, child: _wishlistIcon(book)),
        ],
      ),
    );
  }

  Widget _buildBookTile(Book book) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(book.coverImageUrl, width: 50, fit: BoxFit.cover),
      ),
      title: Text(book.title),
      subtitle: Text(book.author),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("\$${book.price.toStringAsFixed(2)}"),
          _wishlistIcon(book),
        ],
      ),
      onTap: () => _navigateToBookDetail(book),
    );
  }
}
