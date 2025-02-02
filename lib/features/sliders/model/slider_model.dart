import 'package:cloud_firestore/cloud_firestore.dart';

class Transaction {
  final String id; // Added ID field
  final String userName;
  final String userImage;
  final String category;
  final double rating;
  final String location;
  final String status;
  final DateTime date;

  Transaction({
    required this.id,
    required this.userName,
    required this.userImage,
    required this.category,
    required this.rating,
    required this.location,
    required this.status,
    required this.date,
  });

  factory Transaction.fromFirestore(DocumentSnapshot doc) {
   final data = doc.data() as Map<String, dynamic>;
    return Transaction(
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

  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'userImage': userImage,
      'category': category,
      'rating': rating,
      'location': location,
      'status': status,
      'date': Timestamp.fromDate(date),
    };
  }
}

class Stat {
  final String title;
  final String value;
  final String change;

  const Stat({
    required this.title,
    required this.value,
    required this.change,
  });
}
