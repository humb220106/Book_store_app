import 'package:flutter/material.dart';

class ReviewList extends StatelessWidget {
  final String bookId;

  const ReviewList({Key? key, required this.bookId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Dummy reviews (later you can connect to backend or database)
    final reviews = [
      {"user": "Alice", "comment": "Loved this book!", "rating": 5},
      {"user": "Bob", "comment": "Interesting read.", "rating": 4},
      {"user": "Charlie", "comment": "Not my style.", "rating": 2},
    ];

    return Column(
      children: reviews.map((review) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: ListTile(
            // title: Text(review["user"]!),
            // subtitle: Text(review["comment"]!),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                review["rating"] as int,
                (i) => const Icon(Icons.star, size: 16, color: Colors.amber),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
