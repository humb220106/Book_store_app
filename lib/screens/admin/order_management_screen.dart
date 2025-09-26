import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/order_service.dart'; // ✅ make sure this path is correct

class OrderManagementScreen extends StatelessWidget {
  const OrderManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin - Manage Orders"),
        backgroundColor: Colors.brown,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "All Orders",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Optional: implement CSV export
                  },
                  icon: const Icon(Icons.download),
                  label: const Text("Export CSV"),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Orders list (Stream from Firestore)
            Expanded(
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: OrderService.ordersStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        "No orders found.",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    );
                  }

                  final orders = snapshot.data!;

                  return ListView.separated(
                    itemCount: orders.length,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final order = orders[index];
                      final orderId = order['id'];
                      final items = List<Map<String, dynamic>>.from(order['items'] ?? []);
                      final total = order['total'] ?? 0.0;
                      final status = order['status'] ?? "pending";
                      final userId = order['userId'] ?? "Unknown";
                      final createdAt = (order['createdAt'] as Timestamp?)?.toDate();

                      return ExpansionTile(
                        leading: const Icon(Icons.receipt_long),
                        title: Text("Order #${orderId.substring(0, 6)}"),
                        subtitle: Text(
                          "User: $userId\nStatus: ${status.toUpperCase()}",
                          style: TextStyle(
                            color: status == "delivered"
                                ? Colors.green
                                : status == "shipped"
                                    ? Colors.orange
                                    : Colors.red,
                          ),
                        ),
                        children: [
                          // Order items
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
                                trailing: Text("₦${item["price"]}"),
                              );
                            },
                          ),
                          if (createdAt != null)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Placed on: ${createdAt.toLocal()}",
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ),
                          ButtonBar(
                            alignment: MainAxisAlignment.end,
                            children: [
                              TextButton.icon(
                                onPressed: () => OrderService.updateOrderStatus(orderId, "shipped"),
                                icon: const Icon(Icons.local_shipping, color: Colors.orange),
                                label: const Text("Mark Shipped"),
                              ),
                              TextButton.icon(
                                onPressed: () => OrderService.updateOrderStatus(orderId, "delivered"),
                                icon: const Icon(Icons.check_circle, color: Colors.green),
                                label: const Text("Mark Delivered"),
                              ),
                              TextButton.icon(
                                onPressed: () => OrderService.deleteOrder(orderId),
                                icon: const Icon(Icons.delete, color: Colors.red),
                                label: const Text("Delete"),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
