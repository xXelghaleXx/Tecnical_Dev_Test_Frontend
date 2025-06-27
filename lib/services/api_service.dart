import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class ApiService {
  static const String baseUrl = ApiConfig.baseUrl;
  
  static Future<List<dynamic>> get(String endpoint) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      print('Making GET request to: $uri');
      
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
      ).timeout(Duration(seconds: 10));
      
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data is List ? data : [data];
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('API Error: $e');
      throw Exception('Network error: $e');
    }
  }
  
  static Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> data) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      print('Making POST request to: $uri');
      print('POST data: $data');
      
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(data),
      ).timeout(Duration(seconds: 10));
      
      print('POST Response status: ${response.statusCode}');
      print('POST Response body: ${response.body}');
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to post data: ${response.statusCode}');
      }
    } catch (e) {
      print('POST API Error: $e');
      throw Exception('Network error: $e');
    }
  }

  static Future<Map<String, dynamic>> put(String endpoint, Map<String, dynamic> data) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      print('Making PUT request to: $uri');
      print('PUT data: $data');
      
      final response = await http.put(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(data),
      ).timeout(Duration(seconds: 10));
      
      print('PUT Response status: ${response.statusCode}');
      print('PUT Response body: ${response.body}');
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to update data: ${response.statusCode}');
      }
    } catch (e) {
      print('PUT API Error: $e');
      throw Exception('Network error: $e');
    }
  }

  static Future<bool> delete(String endpoint) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      print('Making DELETE request to: $uri');
      
      final response = await http.delete(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
      ).timeout(Duration(seconds: 10));
      
      print('DELETE Response status: ${response.statusCode}');
      print('DELETE Response body: ${response.body}');
      
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      print('DELETE API Error: $e');
      throw Exception('Network error: $e');
    }
  }
}