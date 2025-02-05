import 'package:admin/features/categories/controller/category_controller.dart';
import 'package:admin/features/categories/model/category_model.dart';
import 'package:admin/features/categories/providers/category_provider.dart';
import 'package:flutter/material.dart';

class DeleteServiceDialog extends StatelessWidget {
  final Category category;
  final String serviceId;
  final CategoryProvider provider;

  const DeleteServiceDialog({
    required this.category,
    required this.serviceId,
    required this.provider,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete Service'),
      content: const Text('Are you sure you want to delete this service?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          onPressed: () => _handleDeleteService(context),
          child: const Text('Delete'),
        ),
      ],
    );
  }

  Future<void> _handleDeleteService(BuildContext context) async {
    try {
      final controller = CategoryController(provider);
      await controller.handleDeleteService(category.id, serviceId);

      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Service deleted successfully')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete service: $e')),
        );
      }
    }
  }
}

