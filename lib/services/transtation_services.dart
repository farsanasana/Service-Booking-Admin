// lib/models/transaction_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionModel {
  final String id;
  final String userName;
  final String userImage;
  final String category;
  final double rating;
  final String location;
  final String status;
  final DateTime date;

  TransactionModel({
    required this.id,
    required this.userName,
    required this.userImage,
    required this.category,
    required this.rating,
    required this.location,
    required this.status,
    required this.date,
  });

  factory TransactionModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return TransactionModel(
      id: doc.id,
      userName: data['userName'] ?? '',
      userImage: data['userImage'] ?? '',
      category: data['category'] ?? '',
      rating: (data['rating'] ?? 0).toDouble(),
      location: data['location'] ?? '',
      status: data['status'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
    );
  }
}

class HighlightModel {
  final String title;
  final String value;
  final String change;
  final String icon;

  HighlightModel({
    required this.title,
    required this.value,
    required this.change,
    required this.icon,
  });
}