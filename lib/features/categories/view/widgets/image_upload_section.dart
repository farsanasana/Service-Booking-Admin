import 'dart:convert';
// import 'package:filepicker/filepicker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart'as http ;

class ImageUploadSection extends StatelessWidget {
  final String? imageUrl;
  final Function(String) onImagePicked;

  const ImageUploadSection({
    required this.imageUrl,
    required this.onImagePicked,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _pickAndUploadImage(context),
            icon: const Icon(Icons.upload),
            label: const Text('Upload Image'),
          ),
        ),
        if (imageUrl != null) ...[
          const SizedBox(width: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.network(
              imageUrl!,
              height: 50,
              width: 50,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ],
    );
  }

  Future<void> _pickAndUploadImage(BuildContext context) async {
    try {
      final result = await FilePicker.platform.pickFiles(type: FileType.image);

      if (result != null) {
        final fileBytes = result.files.first.bytes!;
        final fileName = result.files.first.name;

        final response = await _uploadToCloudinary(fileBytes, fileName);

        if (response.statusCode == 200) {
          final responseData = jsonDecode(await response.stream.bytesToString());
          onImagePicked(responseData['secure_url']);
        } else {
          throw Exception('Failed to upload image: ${response.statusCode}');
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload image: $e')),
        );
      }
    }
  }

  Future<http.StreamedResponse> _uploadToCloudinary(List<int> fileBytes, String fileName) async {
    const uploadUrl = "https://api.cloudinary.com/v1_1/dwhmt3yt2/image/upload";
    const uploadPreset = "profileImg";

    final request = http.MultipartRequest('POST', Uri.parse(uploadUrl))
      ..fields['upload_preset'] = uploadPreset
      ..files.add(http.MultipartFile.fromBytes('file', fileBytes, filename: fileName));

    return request.send();
  }
}