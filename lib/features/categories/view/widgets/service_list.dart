import 'package:admin/features/categories/model/category_model.dart';
import 'package:admin/features/categories/providers/category_provider.dart';
import 'package:admin/features/categories/view/widgets/service_list_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ServiceList extends StatelessWidget {
  final Category category;
  final CategoryProvider provider;

  const ServiceList({
    required this.category,
    required this.provider,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('categories')
          .doc(category.id)
          .collection('services')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final services = snapshot.data?.docs ?? [];

        if (services.isEmpty) {
          return const Center(
            child: Text('No services found. Add your first service below.'),
          );
        }

        return ListView.separated(
          itemCount: services.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (context, index) {
            return ServiceListItem(
              service: services[index],
              category: category,
              provider: provider,
            );
          },
        );
      },
    );
  }
}
