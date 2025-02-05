import 'package:admin/features/categories/controller/category_controller.dart';
import 'package:admin/features/categories/model/category_model.dart';
import 'package:admin/features/categories/providers/category_provider.dart';
import 'package:admin/features/categories/view/widgets/image_upload_section.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditServiceDialog extends StatefulWidget {
  final Category category;
  final DocumentSnapshot service;
  final CategoryProvider provider;

  const EditServiceDialog({
    required this.category,
    required this.service,
    required this.provider,
    super.key,
  });

  @override
  State<EditServiceDialog> createState() => _EditServiceDialogState();
}

class _EditServiceDialogState extends State<EditServiceDialog> {
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late String imageUrl;

  @override
  void initState() {
    super.initState();
    final data = widget.service.data() as Map<String, dynamic>;
    nameController = TextEditingController(text: data['name']);
    descriptionController = TextEditingController(text: data['description']);
    imageUrl = data['imageUrl'];
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Service'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Service Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Service Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            ImageUploadSection(
              imageUrl: imageUrl,
              onImagePicked: (url) => setState(() => imageUrl = url),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => _handleUpdateService(context),
          child: const Text('Save Changes'),
        ),
      ],
    );
  }

  Future<void> _handleUpdateService(BuildContext context) async {
    if (nameController.text.isEmpty || descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    try {
      final controller = CategoryController(widget.provider);
      await controller.handleEditService(
        widget.category.id,
        widget.service.id,
        nameController.text,
        descriptionController.text,
        imageUrl,
      );

      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Service updated successfully')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update service: $e')),
        );
      }
    }
  }
}
