import 'package:flutter/material.dart';
import '../../models/book.dart';
import '../../services/wishlist_service.dart';
import '../home/book_detail_screen.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({Key? key}) : super(key: key);

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  List<Book> _wishlist = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadWishlist();
  }

  Future<void> _loadWishlist() async {
    final books = await WishlistService.getWishlist();
    setState(() {
      _wishlist = books;
      _isLoading = false;
    });
  }

  Future<void> _removeBook(Book book) async {
    await WishlistService.removeFromWishlist(book.id);
    _loadWishlist();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${book.title} removed from wishlist')),
    );
  }

  void _navigateToBookDetail(Book book) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BookDetailScreen(book: book)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wishlist', style: TextStyle(color: Colors.black)),
        backgroundColor: const Color(0xFFF5F5F0),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: const Color(0xFFF5F5F0),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _wishlist.isEmpty
              ? const Center(child: Text('Your wishlist is empty'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _wishlist.length,
                  itemBuilder: (context, index) {
                    final book = _wishlist[index];
                    return GestureDetector(
                      onTap: () => _navigateToBookDetail(book),
                      child: Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading: Image.network(book.coverImageUrl, width: 50, fit: BoxFit.cover),
                          title: Text(book.title),
                          subtitle: Text(book.author),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _removeBook(book),
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
