import 'package:admin/features/categories/model/category_model.dart';
import 'package:admin/features/categories/providers/category_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ServiceListItem extends StatelessWidget {
  final DocumentSnapshot service;
  final Category category;
  final CategoryProvider provider;

  const ServiceListItem({
    required this.service,
    required this.category,
    required this.provider,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final data = service.data() as Map<String, dynamic>;

    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Image.network(
          data['imageUrl'] ?? '',
          width: 50,
          height: 50,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const Icon(Icons.error),
        ),
      ),
      title: Text(
        data['name'] ?? '',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(data['description'] ?? ''),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _showEditDialog(context, data),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _showDeleteDialog(context),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, Map<String, dynamic> data) {
    // Implementation of edit service dialog
  }

  void _showDeleteDialog(BuildContext context) {
    // Implementation of delete service dialog
  }
}