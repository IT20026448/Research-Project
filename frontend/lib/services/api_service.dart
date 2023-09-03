import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart'; // Import the http_parser package

class ApiService {
  //static const baseUrl = "http://192.168.8.102:8083";
  static const baseUrl = 'https://skin-disease-app4-xqfdgy7peq-el.a.run.app';

  Future<String?> diagnoseSkinDisease(File imageFile) async {
    try {
      final uri = Uri.parse('$baseUrl/predict');
      final request = http.MultipartRequest('POST', uri)
        ..files.add(http.MultipartFile(
          'image',
          imageFile.readAsBytes().asStream(),
          imageFile.lengthSync(),
          filename: 'image.jpg', // Adjust the filename as needed
          contentType: MediaType.parse('image/jpeg'), // Use MediaType.parse
        ));

      final response = await request.send();
      final responseString = await response.stream.bytesToString();

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: $responseString');

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(responseString);
        String diagnosis =
            responseBody['prediction'] ?? 'N/A'; // Handle null diagnosis
        return diagnosis;
      } else {
        print('API request failed with status ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }
}
