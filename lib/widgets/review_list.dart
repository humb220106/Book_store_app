import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/review.dart';
import '../services/review_service.dart';
import 'review_tile.dart';
import 'write_review_bottom_sheet.dart';

class ReviewList extends StatelessWidget {
  final String bookId;
  const ReviewList({super.key, required this.bookId});

  void _openReviewBottomSheet(BuildContext context) {
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
              likes: [], // ✅ Start empty
            );
            await ReviewService.addReview(review);
            Navigator.pop(context); // ✅ close sheet so StreamBuilder refreshes
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ✅ Wrap StreamBuilder output in a widget
        StreamBuilder<List<Review>>(
          stream: ReviewService.getReviewsForBook(bookId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }

            final reviews = snapshot.data ?? [];

            if (reviews.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("No reviews yet. Be the first!"),
              );
            }

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                return ReviewTile(review: reviews[index]);
              },
            );
          },
        ),

        const SizedBox(height: 10),

        ElevatedButton.icon(
          onPressed: () => _openReviewBottomSheet(context),
          icon: const Icon(Icons.add_comment),
          label: const Text("Write a Review"),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.brown),
        ),
      ],
    );
  }
}
