import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'https://678d06eef067bf9e24e909bb.mockapi.io/data';

  // POST (Create Data)
  static Future<bool> createData(String title, String desc) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl), // Use the base URL directly
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'title': title, 'desc': desc}),
      );
      return response.statusCode == 201; // Returns true if created successfully
    } catch (e) {
      print('Error in createData: $e');
      return false;
    }
  }

  // GET (Fetch Data)
  static Future<List<Map<String, dynamic>>> getAllData() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl)); // Base URL for fetching all data
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(jsonDecode(response.body));
      } else {
        return []; // Return empty list if response is not 200
      }
    } catch (e) {
      print('Error in getAllData: $e');
      return [];
    }
  }

  // UPDATE (Update Data)
  static Future<bool> updateData(String id, String title, String desc) async {
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl/$id'), // Append the ID to the base URL
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'title': title, 'desc': desc}),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Error in updateData: $e');
      return false;
    }
  }

  // DELETE (Delete Data)
  static Future<bool> deleteData(String id) async {
    try {
      final response = await http.delete(Uri.parse('$_baseUrl/$id')); // Append the ID to the base URL
      return response.statusCode == 200;
    } catch (e) {
      print('Error in deleteData: $e');
      return false;
    }
  }
}
