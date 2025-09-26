import 'package:flutter/material.dart';

class WriteReviewBottomSheet extends StatefulWidget {
  final Function(int rating, String comment) onSubmit;

  const WriteReviewBottomSheet({super.key, required this.onSubmit});

  @override
  State<WriteReviewBottomSheet> createState() => _WriteReviewBottomSheetState();
}

class _WriteReviewBottomSheetState extends State<WriteReviewBottomSheet> {
  int _rating = 5;
  final _commentController = TextEditingController();

  void _submit() {
    if (_commentController.text.isEmpty) return;
    widget.onSubmit(_rating, _commentController.text);
    Navigator.pop(context); 
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Write a Review",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          // ⭐ Rating selector
          DropdownButton<int>(
            value: _rating,
            items: List.generate(
              5,
              (i) => DropdownMenuItem(
                value: i + 1,
                child: Text("${i + 1} Stars"),
              ),
            ),
            onChanged: (value) => setState(() => _rating = value ?? 5),
          ),
          const SizedBox(height: 10),

          // 💬 Comment input
          TextField(
            controller: _commentController,
            decoration: const InputDecoration(
              labelText: "Your Comment",
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 10),

          // ✅ Submit button
          ElevatedButton(
            onPressed: _submit,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.brown),
            child: const Text("Submit"),
          ),
        ],
      ),
    );
  }
}
