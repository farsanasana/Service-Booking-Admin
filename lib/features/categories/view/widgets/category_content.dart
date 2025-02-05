// import 'dart:convert';
// import 'package:admin/features/categories/controller/category_controller.dart';
// import 'package:http/http.dart' as http;
// import 'package:admin/features/categories/model/category_model.dart';
// import 'package:admin/features/categories/providers/category_provider.dart';
// import 'package:admin/features/sliders/view/sildebar.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class CategoriesScreen extends StatelessWidget {
//   const CategoriesScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Row(
//         children: [
//           Sidebar(activeItem: 'Categories'),
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.all(24.0),
//               child: Consumer<CategoryProvider>(
//                 builder: (context, categoryProvider, child) {
//                   final categories = categoryProvider.filteredCategories;

//                   if (categoryProvider.isLoading && categories.isEmpty) {
//                     return const Center(child: CircularProgressIndicator());
//                   }

//                   return SingleChildScrollView(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.only(bottom: 16),
//                           child: TextField(
//                             onChanged: (query) {
//                               categoryProvider.searchCategories(query);
//                             },
//                             decoration: InputDecoration(
//                               labelText: 'Search Categories',
//                               border: const OutlineInputBorder(),
//                               prefixIcon: const Icon(Icons.search),
//                             ),
//                           ),
//                         ),
//                         GridView.builder(
//                           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                             crossAxisCount: 3,
//                             crossAxisSpacing: 10,
//                             mainAxisSpacing: 10,
//                           ),
//                           itemCount: categories.length + 1,
//                           shrinkWrap: true,
//                           physics: const NeverScrollableScrollPhysics(),
//                           itemBuilder: (context, index) {
//                             if (index == categories.length) {
//                               return _buildAddNewCard(context, categoryProvider);
//                             }
//                             final category = categories[index];
//                             return _buildCategoryCard(context, category, categoryProvider);
//                           },
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildAddNewCard(BuildContext context, CategoryProvider categoryProvider) {
//     return Card(
//       color: Colors.red[50],
//       child: InkWell(
//         onTap: () => _showAddCategoryDialog(context, categoryProvider),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(Icons.add_circle_outline, size: 48, color: Colors.red),
//             const SizedBox(height: 8),
//             const Text(
//               'Add New Category',
//               style: TextStyle(fontSize: 16, color: Colors.red, fontWeight: FontWeight.bold),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildCategoryCard(
//     BuildContext context,
//     Category category,
//     CategoryProvider categoryProvider,
//   ) {
//     return Card(
//       child: InkWell(
//         onTap: () => _showServicesDialog(context, category, categoryProvider),
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 category.name,
//                 style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 textAlign: TextAlign.center,
//               ),
//               const Spacer(),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   IconButton(
//                     icon: const Icon(Icons.edit, size: 20),
//                     onPressed: () => _showEditCategoryDialog(context, category, categoryProvider),
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.delete, size: 20),
//                     onPressed: () => _showDeleteConfirmation(context, category, categoryProvider),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void _showAddCategoryDialog(BuildContext context, CategoryProvider categoryProvider) {
//     final TextEditingController categoryNameController = TextEditingController();
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Add New Category'),
//         content: TextField(
//           controller: categoryNameController,
//           decoration: const InputDecoration(
//             labelText: 'Category Name',
//             border: OutlineInputBorder(),
//           ),
//         ),
//         actions: [
//           TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
//           ElevatedButton(
//             onPressed: () {
//               if (categoryNameController.text.isNotEmpty) {
//                 categoryProvider.addCategory(categoryNameController.text);
//                 Navigator.pop(context);
//               } else {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('Category name cannot be empty')),
//                 );
//               }
//             },
//             child: const Text('Add'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showDeleteConfirmation(
//     BuildContext context,
//     Category category,
//     CategoryProvider categoryProvider,
//   ) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Delete Category'),
//         content: const Text('Are you sure you want to delete this category?'),
//         actions: [
//           TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
//           ElevatedButton(
//             onPressed: () {
//               categoryProvider.deleteCategory(category.id);
//               Navigator.pop(context);
//             },
//             child: const Text('Delete'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showEditCategoryDialog(
//     BuildContext context,
//     Category category,
//     CategoryProvider categoryProvider,
//   ) {
//     final TextEditingController categoryNameController =
//         TextEditingController(text: category.name);
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Edit Category'),
//         content: TextField(
//           controller: categoryNameController,
//           decoration: const InputDecoration(
//             labelText: 'Category Name',
//             border: OutlineInputBorder(),
//           ),
//         ),
//         actions: [
//           TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
//           ElevatedButton(
//             onPressed: () {
//               if (categoryNameController.text.isNotEmpty) {
//                 categoryProvider.updateCategory(category.id, categoryNameController.text);
//                 Navigator.pop(context);
//               } else {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('Category name cannot be empty')),
//                 );
//               }
//             },
//             child: const Text('Save'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showServicesDialog(
//     BuildContext context,
//     Category category,
//     CategoryProvider categoryProvider,
//   ) {
//     final TextEditingController serviceNameController = TextEditingController();
//     final TextEditingController serviceDescriptionController = TextEditingController();
//     String? imageUrl;

//     Future<void> _pickAndUploadImage() async {
//       try {
//         final result = await FilePicker.platform.pickFiles(type: FileType.image);

//         if (result != null) {
//           final fileBytes = result.files.first.bytes!;
//           final fileName = result.files.first.name;

//           final cloudinaryUploadUrl = "https://api.cloudinary.com/v1_1/dwhmt3yt2/image/upload";
//           final uploadPreset = "profileImg";

//           final request = http.MultipartRequest('POST', Uri.parse(cloudinaryUploadUrl))
//             ..fields['upload_preset'] = uploadPreset
//             ..files.add(http.MultipartFile.fromBytes('file', fileBytes, filename: fileName));

//           final response = await request.send();

//           if (response.statusCode == 200) {
//             final responseBody = await response.stream.bytesToString();
//             final responseData = jsonDecode(responseBody);
//             imageUrl = responseData['secure_url'];
//           } else {
//             throw Exception('Failed to upload image: ${response.statusCode}');
//           }
//         }
//       } catch (e) {
//         debugPrint('Error uploading image: $e');
//         if (context.mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Failed to upload image: ${e.toString()}')),
//           );
//         }
//       }
//     }

//     showDialog(
//       context: context,
//       builder: (context) => StatefulBuilder(
//         builder: (context, setState) => AlertDialog(
//           title: Text('${category.name} Services'),
//           content: SizedBox(
//             width: MediaQuery.of(context).size.width * 0.8,
//             height: MediaQuery.of(context).size.height * 0.8,
//             child: Column(
//               children: [
//                 Expanded(
//                   child: StreamBuilder<QuerySnapshot>(
//                     stream: FirebaseFirestore.instance
//                         .collection('categories')
//                         .doc(category.id)
//                         .collection('services')
//                         .snapshots(),
//                     builder: (context, snapshot) {
//                       if (snapshot.connectionState == ConnectionState.waiting) {
//                         return const Center(child: CircularProgressIndicator());
//                       }

//                       if (snapshot.hasError) {
//                         debugPrint('StreamBuilder error: ${snapshot.error}');
//                         return Center(
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               const Icon(Icons.error_outline, size: 48, color: Colors.red),
//                               const SizedBox(height: 16),
//                               Text('Error: ${snapshot.error}'),
//                               ElevatedButton(
//                                 onPressed: () => setState(() {}),
//                                 child: const Text('Retry'),
//                               ),
//                             ],
//                           ),
//                         );
//                       }

//                       final services = snapshot.data?.docs ?? [];

//                       if (services.isEmpty) {
//                         return const Center(
//                           child: Text(
//                             'No services added yet.\nClick "Add Service" to create one.',
//                             textAlign: TextAlign.center,
//                             style: TextStyle(fontSize: 16, color: Colors.grey),
//                           ),
//                         );
//                       }

//                       return ListView.separated(
//                         itemCount: services.length,
//                         separatorBuilder: (context, index) => const Divider(),
//                         itemBuilder: (context, index) {
//                           final service = services[index];
//                           final data = service.data() as Map<String, dynamic>;

//                           return ListTile(
//                             leading: data['imageUrl'] != null
//                                 ? ClipRRect(
//                                     borderRadius: BorderRadius.circular(4),
//                                     child: Image.network(
//                                       data['imageUrl'],
//                                       width: 50,
//                                       height: 50,
//                                       fit: BoxFit.cover,
//                                       errorBuilder: (context, error, stackTrace) =>
//                                           const Icon(Icons.image_not_supported),
//                                     ),
//                                   )
//                                 : const Icon(Icons.image_not_supported),
//                             title: Text(
//                               data['name'] ?? 'Unnamed Service',
//                               style: const TextStyle(fontWeight: FontWeight.bold),
//                             ),
//                             subtitle: Text(data['description'] ?? 'No description'),
//                             trailing: Row(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 IconButton(
//                                   icon: const Icon(Icons.edit, color: Colors.blue),
//                                   onPressed: () {
//                                     _showEditServiceDialog(
//                                       context,
//                                       category,
//                                       service,
//                                       categoryProvider,
//                                     );
//                                   },
//                                 ),
//                                 IconButton(
//                                   icon: const Icon(Icons.delete, color: Colors.red),
//                                   onPressed: () async {
//                                     final confirmed = await showDialog<bool>(
//                                       context: context,
//                                       builder: (context) => AlertDialog(
//                                         title: const Text('Delete Service'),
//                                         content: const Text(
//                                           'Are you sure you want to delete this service?',
//                                         ),
//                                         actions: [
//                                           TextButton(
//                                             onPressed: () => Navigator.pop(context, false),
//                                             child: const Text('Cancel'),
//                                           ),
//                                           ElevatedButton(
//                                             onPressed: () => Navigator.pop(context, true),
//                                             style: ElevatedButton.styleFrom(
//                                               backgroundColor: Colors.red,
//                                             ),
//                                             child: const Text('Delete'),
//                                           ),
//                                         ],
//                                       ),
//                                     );

//                                     if (confirmed == true) {
//                                       try {
//                                         await FirebaseFirestore.instance
//                                             .collection('categories')
//                                             .doc(category.id)
//                                             .collection('services')
//                                             .doc(service.id)
//                                             .delete();

//                                         if (context.mounted) {
//                                           ScaffoldMessenger.of(context).showSnackBar(
//                                             const SnackBar(
//                                               content: Text('Service deleted successfully'),
//                                             ),
//                                           );
//                                         }
//                                       } catch (e) {
//                                         debugPrint('Error deleting service: $e');
//                                         if (context.mounted) {
//                                           ScaffoldMessenger.of(context).showSnackBar(
//                                             SnackBar(
//                                               content: Text('Failed to delete service: $e'),
//                                               backgroundColor: Colors.red,
//                                             ),
//                                           );
//                                         }
//                                       }
//                                     }
//                                   },
//                                 ),
//                               ],
//                             ),
//                           );
//                         },
//                       );
//                     },
//                   ),
//                 ),
//                 const Divider(),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     children: [
//                       TextField(
//                         controller: serviceNameController,
//                         decoration: const InputDecoration(
//                           labelText: 'Service Name',
//                           border: OutlineInputBorder(),
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//                       TextField(
//                         controller: serviceDescriptionController,
//                         decoration: const InputDecoration(
//                           labelText: 'Service Description',
//                           border: OutlineInputBorder(),
//                         ),
//                         maxLines: 3,
//                       ),
//                       const SizedBox(height: 16),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: ElevatedButton.icon(
//                               onPressed: () async {
//                                 await _pickAndUploadImage();setState(() {});
//                               },
//                               icon: const Icon(Icons.upload),
//                               label: const Text('Upload Image'),
//                             ),
//                           ),
//                           if (imageUrl != null) ...[
//                             const SizedBox(width: 16),
//                             ClipRRect(
//                               borderRadius: BorderRadius.circular(4),
//                               child: Image.network(
//                                 imageUrl!,
//                                 height: 50,
//                                 width: 50,
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           ],
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text('Cancel'),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 if (serviceNameController.text.isEmpty ||
//                     serviceDescriptionController.text.isEmpty) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                       content: Text('Please fill in all required fields'),
//                       backgroundColor: Colors.red,
//                     ),
//                   );
//                   return;
//                 }

//                 if (imageUrl == null) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                       content: Text('Please upload an image'),
//                       backgroundColor: Colors.red,
//                     ),
//                   );
//                   return;
//                 }

//                 try {
//                   final controller = CategoryController(categoryProvider);
//                   await controller.handleAddService(
//                     category.id,
//                     serviceNameController.text,
//                     serviceDescriptionController.text,
//                     imageUrl!,
//                   );

//                   if (context.mounted) {
//                     setState(() {
//                       serviceNameController.clear();
//                       serviceDescriptionController.clear();
//                       imageUrl = null;
//                     });
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(content: Text('Service added successfully')),
//                     );
//                   }
//                 } catch (e) {
//                   debugPrint('Error adding service: $e');
//                   if (context.mounted) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(
//                         content: Text('Failed to add service: $e'),
//                         backgroundColor: Colors.red,
//                       ),
//                     );
//                   }
//                 }
//               },
//               child: const Text('Add Service'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showEditServiceDialog(
//     BuildContext context,
//     Category category,
//     DocumentSnapshot service,
//     CategoryProvider categoryProvider,
//   ) {
//     final data = service.data() as Map<String, dynamic>;
//     final TextEditingController serviceNameController =
//         TextEditingController(text: data['name']);
//     final TextEditingController serviceDescriptionController =
//         TextEditingController(text: data['description']);
//     String? imageUrl = data['imageUrl'];

//     Future<void> _pickAndUploadImage() async {
//       try {
//         final result = await FilePicker.platform.pickFiles(type: FileType.image);

//         if (result != null) {
//           final fileBytes = result.files.first.bytes!;
//           final fileName = result.files.first.name;

//           final cloudinaryUploadUrl =
//               "https://api.cloudinary.com/v1_1/dwhmt3yt2/image/upload";
//           final uploadPreset = "profileImg";

//           final request = http.MultipartRequest('POST', Uri.parse(cloudinaryUploadUrl))
//             ..fields['upload_preset'] = uploadPreset
//             ..files.add(
//               http.MultipartFile.fromBytes('file', fileBytes, filename: fileName),
//             );

//           final response = await request.send();

//           if (response.statusCode == 200) {
//             final responseBody = await response.stream.bytesToString();
//             final responseData = jsonDecode(responseBody);
//             imageUrl = responseData['secure_url'];
//           } else {
//             throw Exception('Failed to upload image: ${response.statusCode}');
//           }
//         }
//       } catch (e) {
//         debugPrint('Error uploading image: $e');
//         if (context.mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Failed to upload image: ${e.toString()}')),
//           );
//         }
//       }
//     }

//     showDialog(
//       context: context,
//       builder: (context) => StatefulBuilder(
//         builder: (context, setState) => AlertDialog(
//           title: const Text('Edit Service'),
//           content: SizedBox(
//             width: MediaQuery.of(context).size.width * 0.8,
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 TextField(
//                   controller: serviceNameController,
//                   decoration: const InputDecoration(
//                     labelText: 'Service Name',
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 TextField(
//                   controller: serviceDescriptionController,
//                   decoration: const InputDecoration(
//                     labelText: 'Service Description',
//                     border: OutlineInputBorder(),
//                   ),
//                   maxLines: 3,
//                 ),
//                 const SizedBox(height: 16),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: ElevatedButton.icon(
//                         onPressed: () async {
//                           await _pickAndUploadImage();
//                           setState(() {});
//                         },
//                         icon: const Icon(Icons.upload),
//                         label: const Text('Upload New Image'),
//                       ),
//                     ),
//                     if (imageUrl != null) ...[
//                       const SizedBox(width: 16),
//                       ClipRRect(
//                         borderRadius: BorderRadius.circular(4),
//                         child: Image.network(
//                           imageUrl!,
//                           height: 50,
//                           width: 50,
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                     ],
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text('Cancel'),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 if (serviceNameController.text.isEmpty ||
//                     serviceDescriptionController.text.isEmpty) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                       content: Text('Please fill in all required fields'),
//                       backgroundColor: Colors.red,
//                     ),
//                   );
//                   return;
//                 }

//                 try {
//                   final controller = CategoryController(categoryProvider);
//                   await controller.handleEditService(
//                     category.id,
//                     service.id,
//                     serviceNameController.text,
//                     serviceDescriptionController.text,
//                     imageUrl!,
//                   );

//                   if (context.mounted) {
//                     Navigator.pop(context);
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(content: Text('Service updated successfully')),
//                     );
//                   }
//                 } catch (e) {
//                   debugPrint('Error updating service: $e');
//                   if (context.mounted) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(
//                         content: Text('Failed to update service: $e'),
//                         backgroundColor: Colors.red,
//                       ),
//                     );
//                   }
//                 }
//               },
//               child: const Text('Save Changes'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:admin/features/categories/providers/category_provider.dart';
import 'package:admin/features/categories/view/widgets/category_grid.dart';
import 'package:admin/features/categories/view/widgets/category_search_bar.dart';
import 'package:flutter/material.dart';

class CategoryContent extends StatelessWidget {
  final CategoryProvider provider;

  const CategoryContent({required this.provider, super.key});

  @override
  Widget build(BuildContext context) {
    final categories = provider.filteredCategories;

    if (provider.isLoading && categories.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CategorySearchBar(provider: provider),
          CategoryGrid(categories: categories, provider: provider),
        ],
      ),
    );
  }
}
