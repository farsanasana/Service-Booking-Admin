import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/category_model.dart';
import '../model/service_model.dart';

class CategoryRepository {
  final FirebaseFirestore _firestore;

  CategoryRepository(this._firestore);

  // Categories CRUD Operations
  Future<List<Category>> fetchCategories() async {
    try {
      final QuerySnapshot snapshot = await _firestore.collection('categories').get();
      return snapshot.docs.map((doc) => Category.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Failed to fetch categories: $e');
    }
  }

  Future<Category> addCategory(String name) async {
    try {
      final documentReference = await _firestore.collection('categories').add({
        'name': name,
        'createdAt': FieldValue.serverTimestamp(),
      });
      
      final DocumentSnapshot doc = await documentReference.get();
      return Category.fromFirestore(doc);
    } catch (e) {
      throw Exception('Failed to add category: $e');
    }
  }

  Future<void> updateCategory(String id, String name) async {
    try {
      await _firestore.collection('categories').doc(id).update({
        'name': name,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to update category: $e');
    }
  }

  Future<void> deleteCategory(String id) async {
    try {
      // Delete all services in the category first
      final QuerySnapshot servicesSnapshot = await _firestore
          .collection('categories')
          .doc(id)
          .collection('services')
          .get();
          
      final batch = _firestore.batch();
      
      // Add all service deletions to batch
      for (var doc in servicesSnapshot.docs) {
        batch.delete(doc.reference);
      }
      
      // Add category deletion to batch
      batch.delete(_firestore.collection('categories').doc(id));
      
      // Execute batch
      await batch.commit();
    } catch (e) {
      throw Exception('Failed to delete category: $e');
    }
  }

  // Services CRUD Operations
  Future<List<Service>> fetchServices(String categoryId) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('categories')
          .doc(categoryId)
          .collection('services')
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Service(
          id: doc.id,
          categoryId: categoryId,
          name: data['name'] ?? '',
          description: data['description'] ?? '',
          imageUrl: data['imageUrl'] ?? '',
          createdAt: (data['createdAt'] as Timestamp).toDate(),
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch services: $e');
    }
  }

  Future<Service> addService(String categoryId, Service service) async {
    try {
      final docRef = await _firestore
          .collection('categories')
          .doc(categoryId)
          .collection('services')
          .add(service.toFirestore());

      final doc = await docRef.get();
      final data = doc.data() as Map<String, dynamic>;
      
      return Service(
        id: doc.id,
        categoryId: categoryId,
        name: data['name'] ?? '',
        description: data['description'] ?? '',
        imageUrl: data['imageUrl'] ?? '',
        createdAt: (data['createdAt'] as Timestamp).toDate(),
      );
    } catch (e) {
      throw Exception('Failed to add service: $e');
    }
  }

  Future<void> updateService(String categoryId, String serviceId, Service service) async {
    try {
      await _firestore
          .collection('categories')
          .doc(categoryId)
          .collection('services')
          .doc(serviceId)
          .update({
        'name': service.name,
        'description': service.description,
        'imageUrl': service.imageUrl,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to update service: $e');
    }
  }

  Future<void> deleteService(String categoryId, String serviceId) async {
    try {
      await _firestore
          .collection('categories')
          .doc(categoryId)
          .collection('services')
          .doc(serviceId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete service: $e');
    }
  }

  
}