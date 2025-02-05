import 'package:admin/features/categories/view/widgets/image_upload_section.dart';
import 'package:flutter/material.dart';

class AddServiceForm extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final String? imageUrl;
  final Function(String) onImagePicked;
  final VoidCallback onSubmit;

  const AddServiceForm({
    required this.nameController,
    required this.descriptionController,
    required this.imageUrl,
    required this.onImagePicked,
    required this.onSubmit,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
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
            onImagePicked: onImagePicked,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onSubmit,
            child: const Text('Add Service'),
          ),
        ],
      ),
    );
  }
}
