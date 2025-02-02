// import 'package:admin/features/Categories/model/service_model.dart';
// import 'package:admin/features/categories/model/category_model.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class CategoryProvider extends ChangeNotifier {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   List<Category> categories = [];
//   List<Category> filteredCategories = [];
//   bool isLoading = false;
// Map<String,List<Service>>categoryServices={};
//   CategoryProvider() {
//     fetchCategories(); // Load categories on initialization
//   }

//   Future<void> fetchCategories() async {
//     // isLoading = true;
//     // notifyListeners();

//   //   try {
//   //     final snapshot = await _firestore.collection('categories').get();
//   //     categories = snapshot.docs.map((doc) => Category.fromFirestore(doc)).toList();
//   //     filteredCategories = List.from(categories); // Update filtered categories
//   //    for (var category in categories) {
//   //       await fetchServices(category.id);
//   //     }
//   //   } catch (e) {
//   //     print('Error fetching categories: $e');
//   //   } finally {
//   //     isLoading = false;
//   //     notifyListeners();
//   //   }
//   // }

//   Future<void> addCategory(String name) async {
//     try {
//       final docRef = await _firestore.collection('categories').add({
//         'name': name,
//         'createdAt': FieldValue.serverTimestamp(),
//       });
//       final newCategory = Category(id: docRef.id, name: name);
//       categories.add(newCategory); // Update locally
//       filteredCategories = List.from(categories);
//       notifyListeners();
//     } catch (e) {
//       print('Error adding category: $e');
//     }
//   }

//   Future<void> editCategory(String id, String newName) async {
//     try {
//       await _firestore.collection('categories').doc(id).update({'name': newName});
//       final index = categories.indexWhere((category) => category.id == id);
//       if (index != -1) {
//         categories[index].name = newName;
//         filteredCategories = List.from(categories);
//         notifyListeners();
//       }
//     } catch (e) {
//       print('Error editing category: $e');
//     }
//   }

//   Future<void> deleteCategory(String id) async {
//     try {
//       await _firestore.collection('categories').doc(id).delete();
//       categories.removeWhere((category) => category.id == id);
     
//       categoryServices.remove(id);
//       filteredCategories = List.from(categories);
//       notifyListeners();
//     } catch (e) {
//       print('Error deleting category: $e');
//     }
//   }

//   void searchCategories(String query) {
//     if (query.isEmpty) {
//       filteredCategories = List.from(categories);
//     } else {
//       filteredCategories = categories
//           .where((category) =>
//               category.name.toLowerCase().contains(query.toLowerCase()))
//           .toList();
//     }
//     notifyListeners();
//   }

//   Future<void> addServiceToCategory(
//   String categoryId,
//   String serviceName,
//   String serviceDescription,
//   String imageUrl,
// ) async {
//    try {
//       // Create the services collection if it doesn't exist
//       final serviceRef = await FirebaseFirestore.instance.collection('categories').doc(categoryId).collection('services').add({
        
//         'name': serviceName,
//         'description': serviceDescription,
//         'imageUrl': imageUrl,
//         'createdAt': FieldValue.serverTimestamp(),
//       });
      
//           final newService = Service(
//         id: serviceRef.id,
//         categoryId: categoryId,
//         name: serviceName,
//         description: serviceDescription,
//         imageUrl: imageUrl,
//         createdAt: DateTime.now(),
//       );

//       categoryServices[categoryId] ??= [];
//       categoryServices[categoryId]!.add(newService);
//       notifyListeners();
//     } catch (e) {
//       debugPrint('Error adding service: $e');
//       throw Exception('Failed to add service: $e');
//     }
//   }


// Future<void> updateService(
//   String categoryId,
//   String serviceId,
//   String name,
//   String description,
//   String imageUrl,
// ) async {
//   try {
//     await _firestore
//         .collection('categories')
//         .doc(categoryId)
//         .collection('services')
//         .doc(serviceId)
//         .update({
//       'name': name,
//       'description': description,
//       'image': imageUrl,
//     });
//    final services = categoryServices[categoryId];
//       if (services != null) {
//         final index = services.indexWhere((service) => service.id == serviceId);
//         if (index != -1) {
//           services[index] = Service(
//             id: serviceId,
//             categoryId: categoryId,
//             name: name,
//             description: description,
//             imageUrl: imageUrl,
//             createdAt: services[index].createdAt,
//           );
//     notifyListeners();
//   } }}catch (e) {
//     print('Error updating service: $e');
//   }
// }
// Future<void> deleteService(String categoryId, String serviceId) async {
//     try {
//       await _firestore
//           .collection('categories')
//           .doc(categoryId)
//           .collection('services')
//           .doc(serviceId)
//           .delete();

//       notifyListeners();
//     } catch (e) {
//       print('Error deleting service: $e');
//     }
//   }

// Future<void> fetchServices(String categoryId) async {
//   try {
//     final snapshot = await _firestore
//         .collection('categories')
//         .doc(categoryId)
//         .collection('services')
//         .get();

//    categoryServices[categoryId] = snapshot.docs.map((doc) {
//         final data = doc.data();
//         return Service(
//           id: doc.id,
//           categoryId: categoryId,
//           name: data['name'] ?? '',
//           description: data['description'] ?? '',
//           imageUrl: data['imageUrl'] ?? '',
//           createdAt: (data['createdAt'] as Timestamp).toDate(),
//         );
//       }).toList();
//       notifyListeners();
//     } catch (e) {
//       print('Error fetching services: $e');
//     }
//   }
// }


// lib/features/categories/controllers/category_controller.dart

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
}