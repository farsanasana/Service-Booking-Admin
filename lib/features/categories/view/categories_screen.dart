import 'package:admin/features/categories/view/widgets/category_content.dart';
import 'package:admin/features/categories/providers/category_provider.dart';
import 'package:admin/features/sliders/view/sildebar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Sidebar(activeItem: 'Categories'),
          Expanded(
            child: Consumer<CategoryProvider>(
              builder: (context, provider, child) {
                return CategoryContent(provider: provider);
              },
            ),
          ),
        ],
      ),
    );
  }
}