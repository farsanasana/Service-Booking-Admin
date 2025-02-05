

import 'package:admin/features/categories/model/category_model.dart';
import 'package:admin/features/categories/model/service_model.dart';
import 'package:admin/features/categories/repositories/category_repository.dart';
import 'package:flutter/material.dart';

class CategoryProvider extends ChangeNotifier {
  final CategoryRepository _repository;
  
  List<Category> _categories = [];
  List<Category> _filteredCategories = [];
 final Map<String, List<Service>> _categoryServices = {};
  bool _isLoading = false;
  String? _error;

  CategoryProvider(this._repository) {
    fetchCategories();
  }

  // Getters
  List<Category> get categories => _categories;
  List<Category> get filteredCategories => _filteredCategories;
  Map<String, List<Service>> get categoryServices => _categoryServices;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Methods
  Future<void> fetchCategories() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _categories = await _repository.fetchCategories();
      _filteredCategories = List.from(_categories);
      
      // Fetch services for each category
      for (var category in _categories) {
        await fetchServices(category.id);
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addCategory(String name) async {
    try {
      final category = await _repository.addCategory(name);
      _categories.add(category);
      _filteredCategories = List.from(_categories);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateCategory(String id, String name) async {
    try {
      await _repository.updateCategory(id, name);
      final index = _categories.indexWhere((category) => category.id == id);
      if (index != -1) {
        // Update both lists
        final updatedCategory = Category(
          id: id,
          name: name,
          createdAt: _categories[index].createdAt,
        );
        _categories[index] = updatedCategory;
        _filteredCategories = List.from(_categories);
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> deleteCategory(String id) async {
    try {
      await _repository.deleteCategory(id);
      _categories.removeWhere((category) => category.id == id);
      _filteredCategories = List.from(_categories);
      _categoryServices.remove(id);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  void searchCategories(String query) {
    if (query.isEmpty) {
      _filteredCategories = List.from(_categories);
    } else {
      _filteredCategories = _categories
          .where((category) =>
              category.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  Future<void> fetchServices(String categoryId) async {
    try {
      final services = await _repository.fetchServices(categoryId);
      _categoryServices[categoryId] = services;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> addService(String categoryId, Service service) async {
    try {
      final newService = await _repository.addService(categoryId, service);
      _categoryServices[categoryId] ??= [];
      _categoryServices[categoryId]!.add(newService);
         _error = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }
Future<void> updateService(String categoryId, String serviceId, Service updatedService) async {
    try {
      await _repository.updateService(categoryId, serviceId, updatedService);
      final services = _categoryServices[categoryId];
      if (services != null) {
        final index = services.indexWhere((service) => service.id == serviceId);
        if (index != -1) {
          services[index] = updatedService;
          notifyListeners();
        }
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> deleteService(String categoryId, String serviceId) async {
    try {
      await _repository.deleteService(categoryId, serviceId);
      _categoryServices[categoryId]?.removeWhere((service) => service.id == serviceId);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }
  
}