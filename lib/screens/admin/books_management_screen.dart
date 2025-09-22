import 'package:flutter/material.dart';

class BooksManagementScreen extends StatelessWidget {
  const BooksManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Manage Books",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            ElevatedButton.icon(
              onPressed: () {
                // TODO: open add book form
              },
              icon: const Icon(Icons.add),
              label: const Text("Add Book"),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Books list (placeholder table)
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: ListView.builder(
              itemCount: 10, // Replace with Firestore books count
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.book),
                  title: Text("Book Title $index"),
                  subtitle: const Text("Author Name"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          // TODO: Edit book
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          // TODO: Delete book
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
