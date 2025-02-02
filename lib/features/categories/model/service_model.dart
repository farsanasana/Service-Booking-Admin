
import 'package:cloud_firestore/cloud_firestore.dart';

class Service {
  final String id;
  final String categoryId;
  final String name;
  final String description;
  final String imageUrl;
  final DateTime createdAt;

  Service({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.createdAt,
  });

  factory Service.create({
    required String categoryId,
    required String name,
    required String description,
    required String imageUrl,
  }) {
    return Service(
      id: '',  // Empty ID as it hasn't been created in Firestore yet
      categoryId: categoryId,
      name: name,
      description: description,
      imageUrl: imageUrl,
      createdAt: DateTime.now(),
    );
  }
  Map<String, dynamic> toFirestore() {
    return {
      'categoryId': categoryId,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'createdAt': createdAt,
    };
  }
}