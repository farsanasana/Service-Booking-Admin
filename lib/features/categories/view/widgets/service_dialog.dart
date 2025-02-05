import 'package:admin/features/categories/controller/category_controller.dart';
import 'package:admin/features/categories/model/category_model.dart';
import 'package:admin/features/categories/providers/category_provider.dart';
import 'package:admin/features/categories/view/widgets/add_service_form.dart';
import 'package:admin/features/categories/view/widgets/service_list.dart';
import 'package:flutter/material.dart';

class ServiceDialog extends StatefulWidget {
  final Category category;
  final CategoryProvider provider;

  const ServiceDialog({
    required this.category,
    required this.provider,
    super.key,
  });

  @override
  State<ServiceDialog> createState() => _ServiceDialogState();
}

class _ServiceDialogState extends State<ServiceDialog> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('${widget.category.name} Services'),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.8,
        child: Column(
          children: [
            Expanded(
              child: ServiceList(
                category: widget.category,
                provider: widget.provider,
              ),
            ),
            const Divider(),
            AddServiceForm(
              nameController: nameController,
              descriptionController: descriptionController,
              imageUrl: imageUrl,
              onImagePicked: (url) => setState(() => imageUrl = url),
              onSubmit: _handleAddService,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    );
  }

  Future<void> _handleAddService() async {
    final controller = CategoryController(widget.provider);
    
    if (nameController.text.isEmpty || descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    if (imageUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload an image')),
      );
      return;
    }

    try {
      await controller.handleAddService(
        widget.category.id,
        nameController.text,
        descriptionController.text,
        imageUrl!,
      );

      nameController.clear();
      descriptionController.clear();
      setState(() => imageUrl = null);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Service added successfully')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }
}
