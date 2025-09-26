

class Order {
  final String id;
  final String userId;
  final List<Map<String, dynamic>> items; // book data
  final double totalPrice;
  final DateTime createdAt;

  Order({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalPrice,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      "userId": userId,
      "items": items,
      "totalPrice": totalPrice,
      "createdAt": createdAt.toIso8601String(),
    };
  }

  factory Order.fromMap(String id, Map<String, dynamic> map) {
    return Order(
      id: id,
      userId: map["userId"],
      items: List<Map<String, dynamic>>.from(map["items"]),
      totalPrice: map["totalPrice"],
      createdAt: DateTime.parse(map["createdAt"]),
    );
  }
}
