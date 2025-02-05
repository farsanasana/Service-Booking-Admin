import 'package:admin/features/categories/providers/category_provider.dart';
import 'package:flutter/material.dart';

class CategorySearchBar extends StatelessWidget {
  final CategoryProvider provider;

  const CategorySearchBar({required this.provider, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        onChanged: (query) => provider.searchCategories(query),
        decoration: const InputDecoration(
          labelText: 'Search Categories',
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.search),
        ),
      ),
    );
  }
}