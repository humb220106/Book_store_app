import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/review.dart';
import '../../services/review_service.dart';
import '../../widgets/review_tile.dart';
import '../../widgets/write_review_bottom_sheet.dart';

class ReviewScreen extends StatelessWidget {
  final String bookId;
  const ReviewScreen({super.key, required this.bookId});

  void _openWriteReview(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login required to write a review")),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return WriteReviewBottomSheet(
          onSubmit: (rating, comment) async {
            final review = Review(
              id: '',
              userId: user.displayName ?? user.email ?? "Anonymous",
              bookId: bookId,
              rating: rating,
              comment: comment,
              date: DateTime.now(),
              likes: [], // ✅ start with empty likes
            );
            await ReviewService.addReview(review);
            Navigator.pop(context); // close bottom sheet after submit
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Reviews")),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.brown,
        onPressed: () => _openWriteReview(context),
        child: const Icon(Icons.add_comment),
      ),
      body: StreamBuilder<List<Review>>(
        // 🔹 Use simple version for now (no index required)
        // Later: switch to ReviewService.getReviewsSorted(bookId)
        stream: ReviewService.getReviewsSimple(bookId),

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final reviews = snapshot.data ?? [];

          if (reviews.isEmpty) {
            return const Center(child: Text("No reviews yet. Be the first!"));
          }

          return ListView.builder(
            itemCount: reviews.length,
            itemBuilder: (context, index) {
              return ReviewTile(review: reviews[index]);
            },
          );
        },
      ),
    );
  }
}
