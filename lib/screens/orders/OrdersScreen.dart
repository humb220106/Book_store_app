import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text("You must be logged in to view orders"),
        ),
      );
    }

    final currency = NumberFormat.currency(locale: 'en_NG', symbol: "₦");

    final statusColors = {
      "pending": Colors.red,
      "shipped": Colors.orange,
      "delivered": Colors.green,
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Orders"),
        backgroundColor: Colors.brown,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('userId', isEqualTo: user.uid)
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "No orders yet.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          final orders = snapshot.data!.docs;

          return ListView.separated(
            itemCount: orders.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final order = orders[index];
              final data = order.data() as Map<String, dynamic>;

              final items = List<Map<String, dynamic>>.from(data['items']);
              final total = (data['total'] ?? 0).toDouble();
              final status = (data['status'] ?? "pending").toString();

              // ✅ Safe timestamp fallback
              final createdAt = (data['createdAt'] as Timestamp?)?.toDate() ??
                  (data['localCreatedAt'] != null
                      ? DateTime.tryParse(data['localCreatedAt'].toString())
                      : null);

              return ExpansionTile(
                title: Text(
                  "Order #${order.id.substring(0, 6)}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  "Total: ${currency.format(total)}  |  Status: ${status.toUpperCase()}",
                  style: TextStyle(
                    color: statusColors[status] ?? Colors.grey,
                  ),
                ),
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: items.length,
                    itemBuilder: (context, i) {
                      final item = items[i];
                      return ListTile(
                        leading: item["coverImageUrl"] != null
                            ? Image.network(
                                item["coverImageUrl"],
                                width: 40,
                                height: 60,
                                fit: BoxFit.cover,
                              )
                            : const Icon(Icons.book, color: Colors.brown),
                        title: Text(item["title"] ?? "Unknown"),
                        trailing: Text(currency.format(item["price"] ?? 0)),
                      );
                    },
                  ),
                  if (createdAt != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        "Placed on: ${DateFormat.yMMMd().add_jm().format(createdAt)}",
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
