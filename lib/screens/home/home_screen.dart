import 'package:flutter/material.dart';
import '../../models/book.dart';
import '../../services/book_service.dart';
import 'book_detail_screen.dart';
import 'catalog_screen.dart';
import 'search_screen.dart';
import '../cart/cart_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Book> _cartItems = [];

  void _navigateToBookDetail(Book book) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BookDetailScreen(book: book)),
    );
  }

  Widget _buildBookList(List<Book> books) {
    return SizedBox(
      height: 250,
      child: books.isEmpty
          ? const Center(child: Text('No books available'))
          : ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: books.length,
              separatorBuilder: (_, __) => const SizedBox(width: 16),
              itemBuilder: (context, index) {
                final book = books[index];
                return GestureDetector(
                  onTap: () => _navigateToBookDetail(book),
                  child: Container(
                    width: 160,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12),
                            ),
                            child: Image.network(
                              book.coverImageUrl,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(
                                Icons.book,
                                size: 60,
                                color: Colors.brown,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                book.title,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                book.author,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "\$${book.price.toStringAsFixed(2)}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.brown,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Book>>(
      stream: BookService.getBooksStream(),
      builder: (context, snapshot) {
        final books = snapshot.data ?? [];

        final featuredBooks = books.where((b) => b.isFeatured).take(5).toList();
        final newArrivals = books.where((b) => b.isNewArrival).take(5).toList();
        final bestsellers = books.where((b) => b.isBestseller).take(5).toList();

        return Scaffold(
          backgroundColor: const Color(0xFFF5F5F0),
          appBar: AppBar(
            backgroundColor: const Color(0xFFF5F5F0),
            elevation: 0,
            title: const Text(
              "Book Store",
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.menu_book, color: Colors.brown),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CatalogScreen()),
                  );
                },
                tooltip: "Browse Catalog",
              ),
              IconButton(
                icon: const Icon(Icons.search, color: Colors.brown),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SearchScreen()),
                  );
                },
                tooltip: "Search",
              ),
              IconButton(
                icon: const Icon(Icons.favorite_border, color: Colors.brown),
                onPressed: () {
                  Navigator.pushNamed(context, '/wishlist');
                },
                tooltip: "Wishlist",
              ),
              IconButton(
                icon: const Icon(Icons.person, color: Colors.brown),
                onPressed: () {
                  Navigator.pushNamed(context, '/profile');
                },
                tooltip: "Profile",
              ),
              IconButton(
                icon: const Icon(Icons.shopping_cart, color: Colors.brown),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CartScreen(cartItems: _cartItems),
                    ),
                  );
                },
                tooltip: "Cart",
              ),
            ],
          ),
          body: snapshot.connectionState == ConnectionState.waiting
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Featured Books",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      _buildBookList(featuredBooks),
                      const SizedBox(height: 24),
                      const Text(
                        "New Arrivals",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      _buildBookList(newArrivals),
                      const SizedBox(height: 24),
                      const Text(
                        "Bestsellers",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      _buildBookList(bestsellers),
                      const SizedBox(height: 24),
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CatalogScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.menu_book),
                          label: const Text("Browse All Books"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.brown,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
