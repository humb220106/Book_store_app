import 'package:flutter/material.dart';
import '../../models/book.dart';
import '../../models/book_filter.dart';
import '../../services/book_service.dart';
import '../../services/wishlist_service.dart';
import '../../widgets/filter_bottom_sheet.dart';
import 'book_detail_screen.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  bool _isGridView = true;
  BookFilter _currentFilter = BookFilter();

  void _navigateToBookDetail(Book book) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BookDetailScreen(book: book)),
    );
  }

  void _openFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => FilterBottomSheet(
        currentFilter: _currentFilter,
        onApply: (filter) {
          setState(() {
            _currentFilter = filter;
          });
        },
      ),
    );
  }

  /// Wishlist icon that updates in real-time
  Widget _wishlistIcon(Book book) {
    return StreamBuilder<bool>(
      stream: WishlistService.isInWishlistStream(book.id),
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
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Book>>(
      stream: BookService.getBooksStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        }

        final allBooks = snapshot.data ?? [];

        // Apply filters
        final filteredBooks = allBooks.where((book) {
          if (_currentFilter.genres?.isNotEmpty == true &&
              !_currentFilter.genres!.contains(book.genre)) {
            return false;
          }
          if (_currentFilter.authors?.isNotEmpty == true &&
              !_currentFilter.authors!.contains(book.author)) {
            return false;
          }
          if (_currentFilter.bestsellersOnly && !book.isBestseller) return false;
          if (_currentFilter.newArrivalsOnly && !book.isNewArrival) return false;
          if (book.price < (_currentFilter.minPrice ?? 0) ||
              book.price > (_currentFilter.maxPrice ?? double.infinity)) {
            return false;
          }
          if (book.rating < (_currentFilter.minRating ?? 0)) return false;
          if (_currentFilter.searchQuery.isNotEmpty &&
              !book.title.toLowerCase().contains(
                  _currentFilter.searchQuery.toLowerCase())) {
            return false;
          }
          return true;
        }).toList();

        return Scaffold(
          backgroundColor: const Color(0xFFF5F5F0),
          appBar: AppBar(
            backgroundColor: const Color(0xFFF5F5F0),
            elevation: 0,
            title: const Text(
              'Book Catalog',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
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
          body: filteredBooks.isEmpty
              ? const Center(child: Text('No books available'))
              : (_isGridView
                  ? GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.65,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: filteredBooks.length,
                      itemBuilder: (context, index) {
                        return _buildBookCard(filteredBooks[index]);
                      },
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: filteredBooks.length,
                      itemBuilder: (context, index) {
                        return _buildBookTile(filteredBooks[index]);
                      },
                    )),
        );
      },
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
        child: Image.network(book.coverImageUrl,
            width: 50, fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.book, size: 30, color: Colors.brown)),
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
