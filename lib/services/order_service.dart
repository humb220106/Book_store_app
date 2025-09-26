import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrderService {
  static final _firestore = FirebaseFirestore.instance;

  /// Place a new order
  static Future<void> placeOrder({
    required List<Map<String, dynamic>> items,
    required double total,
    required String address,
    required String paymentMethod,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("User not logged in");
    }

    try {
      await _firestore.collection('orders').add({
        'userId': user.uid,
        'items': items,
        'total': total,
        'address': address,
        'paymentMethod': paymentMethod,
        'status': 'pending',
        // ✅ Always store fallback timestamp
        'createdAt': FieldValue.serverTimestamp(),
        'localCreatedAt': DateTime.now().toUtc(),
      });
    } catch (e) {
      throw Exception("Failed to place order: $e");
    }
  }

  // ---------- ORDERS ----------
  static Stream<List<Map<String, dynamic>>> ordersStream() {
    return _firestore
        .collection('orders')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snap) => snap.docs.map((d) {
            final data = d.data();
            data['id'] = d.id;
            return data;
          }).toList(),
        );
  }

  static Future<void> updateOrderStatus(
    String orderId,
    String newStatus,
  ) async {
    await _firestore.collection('orders').doc(orderId).update({
      'status': newStatus,
    });
  }

  static Future<void> deleteOrder(String orderId) async {
    await _firestore.collection('orders').doc(orderId).delete();
  }

}
