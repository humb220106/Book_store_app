// lib/screens/book_list_screen.dart
import 'package:flutter/material.dart';
import '../../services/book_service.dart';
import '../../models/book.dart';

class BookListScreen extends StatelessWidget {
  const BookListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Books")),
      body: StreamBuilder<List<Book>>(
        stream: BookService.getBooksStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final books = snapshot.data ?? [];

          if (books.isEmpty) {
            return const Center(child: Text("No books available"));
          }

          return ListView.builder(
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  leading: Image.network(
                    book.coverImageUrl,
                    width: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.broken_image, size: 40),
                  ),
                  title: Text(book.title),
                  subtitle: Text("${book.author} • \$${book.price}"),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (book.isFeatured)
                        const Icon(Icons.star, color: Colors.orange, size: 18),
                      if (book.isNewArrival)
                        const Icon(Icons.fiber_new,
                            color: Colors.green, size: 18),
                      if (book.isBestseller)
                        const Icon(Icons.local_fire_department,
                            color: Colors.red, size: 18),
                    ],
                  ),
                  onTap: () {
                    // 👉 Navigate to book details screen (optional)
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
