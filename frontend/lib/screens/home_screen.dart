import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frontend/services/api_service.dart';
import 'package:frontend/widgets/result_widget.dart';
import 'package:image_picker/image_picker.dart';

import '../widgets/image_picker_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService apiService = ApiService();
  String? diagnosis; // To store the diagnosis
  File? pickedImage; // To store the picked image

  Future<void> _getImage(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final image = File(pickedFile.path);
      setState(() {
        pickedImage = image; // Update the picked image
      });
      ImagePickerWidget(apiService: apiService)
          .predictSkinDisease(context, image);
    } else {
      print('No image selected.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Skin Disease Diagnosis'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          // Display the picked image or "No image selected"
          pickedImage != null
              ? Image.file(pickedImage!)
              : const Text('No image selected'),

          const SizedBox(height: 20.0),

          // Button to pick an image
          ElevatedButton(
            onPressed: () => _getImage(context),
            child: const Text('Pick an image from gallery'),
          ),

          const SizedBox(height: 20.0),

          // Display diagnosis or "N/A"
          ResultWidget(diagnosis: diagnosis ?? 'N/A'),
        ],
      ),
    );
  }
}
