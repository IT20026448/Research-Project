import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frontend/services/api_service.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends StatelessWidget {
  final ApiService apiService; // Add this parameter

  const ImagePickerWidget({Key? key, required this.apiService});

  Future<void> _getImage(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);
      predictSkinDisease(context, imageFile);
    } else {
      print('No image selected.');
    }
  }

  Future<void> predictSkinDisease(BuildContext context, File image) async {
    if (!image.existsSync()) {
      print('Invalid image file');
      return;
    }

    int maxAttempts = 3; // Set the number of retry attempts
    int attempts = 0;
    List<List<double>>? predictionList;

    while (attempts < maxAttempts) {
      try {
        final diagnosis = await apiService.diagnoseSkinDisease(image);

        if (diagnosis != null) {
          // Parse the JSON response
          final jsonResponse = jsonDecode(diagnosis);

          predictionList = List<List<double>>.from(jsonResponse['prediction']);
        }

        break; // If successful, exit the loop
      } catch (e) {
        print('API request failed: $e');
        attempts++;
        if (attempts < maxAttempts) {
          print('Retrying...');
          await Future.delayed(
              Duration(seconds: 2)); // Wait for 2 seconds before retrying
        }
      }
    }

    if (predictionList != null) {
      // Format the prediction as a string
      final diagnosisString = predictionList.map((row) {
        return row.map((value) => value.toString()).join(', ');
      }).join('\n');

      final snackBar = SnackBar(content: Text('Diagnosis:\n$diagnosisString'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      print('API request failed after $maxAttempts attempts.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const Text('Select an image for diagnosis'),
        ElevatedButton(
          onPressed: () => _getImage(context),
          child: const Text('Pick an image from gallery'),
        ),
      ],
    );
  }
}
