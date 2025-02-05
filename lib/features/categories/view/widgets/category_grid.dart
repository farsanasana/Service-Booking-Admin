import 'package:admin/features/categories/model/category_model.dart';
import 'package:admin/features/categories/providers/category_provider.dart';
import 'package:admin/features/categories/view/widgets/add_category_card.dart';
import 'package:admin/features/categories/view/widgets/category_card.dart';
import 'package:flutter/material.dart';

class CategoryGrid extends StatelessWidget {
  final List<Category> categories;
  final CategoryProvider provider;

  const CategoryGrid({
    required this.categories,
    required this.provider,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: categories.length + 1,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        if (index == categories.length) {
          return AddCategoryCard(provider: provider);
        }
        return CategoryCard(
          category: categories[index],
          provider: provider,
        );
      },
    );
  }
}