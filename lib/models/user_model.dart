// lib/models/user_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String? email;
  final String? displayName;
  final List<String> wishlist; // list of book IDs
  final List<String> cart; // list of book IDs
  final bool isAdmin;
  final DateTime createdAt;

  UserModel({
    required this.uid,
    this.email,
    this.displayName,
    this.wishlist = const [],
    this.cart = const [],
    this.isAdmin = false,
    required this.createdAt,
  });

  factory UserModel.fromMap(String uid, Map<String, dynamic>? data) {
    if (data == null) {
      return UserModel(uid: uid, createdAt: DateTime.now());
    }

    final createdAtRaw = data['createdAt'];
    DateTime createdAt;
    if (createdAtRaw == null) {
      createdAt = DateTime.now();
    } else if (createdAtRaw is Timestamp) {
      createdAt = createdAtRaw.toDate();
    } else {
      createdAt = DateTime.tryParse(createdAtRaw.toString()) ?? DateTime.now();
    }

    return UserModel(
      uid: uid,
      email: data['email'] as String?,
      displayName: data['displayName'] as String?,
      wishlist: List<String>.from(data['wishlist'] ?? []),
      cart: List<String>.from(data['cart'] ?? []),
      isAdmin: (data['isAdmin'] as bool?) ?? false,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'displayName': displayName,
      'wishlist': wishlist,
      'cart': cart,
      'isAdmin': isAdmin,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
