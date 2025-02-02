import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  final String id;
   final String name;
final DateTime createdAt;

  Category({
    required this.id,
    required this.name,
    required this.createdAt,
  });


  factory Category.fromFirestore(DocumentSnapshot doc) {
   final data = doc.data() as Map<String, dynamic>;
    return Category(
      id: doc.id,
      name: data['name'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }
  Map<String, dynamic> toFirestore() {
    return {'name': name,
      'createdAt': Timestamp.fromDate(createdAt),};
  }
}