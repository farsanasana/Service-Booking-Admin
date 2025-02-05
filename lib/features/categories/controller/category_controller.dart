import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../model/service_model.dart';
import '../providers/category_provider.dart';

class CategoryController {
  final CategoryProvider _provider;

  CategoryController(this._provider);

  Future<void> handleAddCategory(String name) async {
    if (name.isEmpty) {
      throw Exception('Category name cannot be empty');
    }
    await _provider.addCategory(name);
  }

  Future<void> handleUpdateCategory(String id, String name) async {
    if (name.isEmpty) {
      throw Exception('Category name cannot be empty');
    }
    await _provider.updateCategory(id, name);
  }

  Future<void> handleDeleteCategory(String id) async {
    await _provider.deleteCategory(id);
  }

  Future<void> handleAddService(String categoryId, String name, String description, String imageUrl) async {
    if (name.isEmpty || description.isEmpty) {
      throw Exception('Service name and description are required');
    }
      if (imageUrl.isEmpty) {
      throw Exception('Service image is required');
    }

    final service = Service.create(
      categoryId: categoryId,
      name: name,
      description: description,
      imageUrl: imageUrl,
    );

    await _provider.addService(categoryId, service);
  }

  void handleSearchCategories(String query) {
    _provider.searchCategories(query);
  }
  Future<void> handleEditService(
    String categoryId,
    String serviceId,
    String name,
    String description,
    String imageUrl,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection('categories')
          .doc(categoryId)
          .collection('services')
          .doc(serviceId)
          .update({
        'name': name,
        'description': description,
        'imageUrl': imageUrl,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Error in handleEditService: $e');
      throw Exception('Failed to update service: $e');
    }
  }
   Future<void> handleDeleteService(String categoryId, String serviceId) async {
    try {
      await FirebaseFirestore.instance
          .collection('categories')
          .doc(categoryId)
          .collection('services')
          .doc(serviceId)
          .delete();
      _provider.categoryServices[categoryId]?.removeWhere((service) => service.id == serviceId);
      _provider.notifyListeners();
    } catch (e) {
      debugPrint('Error in handleDeleteService: $e');
      throw Exception('Failed to delete service: $e');
    }
  }
}
