import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/review.dart';
import '../services/review_service.dart';

class ReviewTile extends StatelessWidget {
  final Review review;
  const ReviewTile({super.key, required this.review});

  Future<void> _toggleLike() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await ReviewService.toggleLike(review.id, user.uid);
  }

  Future<void> _deleteReview(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null &&
        (user.displayName == review.userId || user.email == review.userId)) {
      await ReviewService.deleteReview(review.id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Review deleted")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You can only delete your own reviews")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // 🔎 Debug print each time this tile builds
    print("📝 Rendering review: "
        "id=${review.id}, user=${review.userId}, "
        "rating=${review.rating}, likes=${review.likes.length}");

    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid ?? "";
    final hasLiked = review.likes.contains(userId);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              review.userId,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Row(
              children: List.generate(
                5,
                (index) => Icon(
                  index < review.rating ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                  size: 18,
                ),
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(review.comment),
            const SizedBox(height: 6),
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    hasLiked ? Icons.favorite : Icons.favorite_border,
                    color: hasLiked ? Colors.red : Colors.grey,
                  ),
                  onPressed: _toggleLike,
                ),
                Text("${review.likes.length}"),
                const Spacer(),
                if (user != null &&
                    (user.displayName == review.userId ||
                        user.email == review.userId))
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteReview(context),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
