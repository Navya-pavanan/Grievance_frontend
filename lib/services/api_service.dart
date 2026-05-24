
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import '../models/complaint_model.dart';

class ApiService {
  // Dynamically allocate the proper localhost depending on the device running it
  static String get baseUrl {
    if (kIsWeb) {
      return "http://localhost:8000";
    } else if (Platform.isAndroid) {
      // Your laptop's exact Local Wi-Fi IPv4 address for your physical phone!
      return "http://192.168.20.3:8000";
    } else {
      return "http://localhost:8000";
    }
  }

  // Submit a new complaint
  static Future<bool> submitComplaint({
    required String title,
    required String description,
    required String category,
    required String location,
  }) async {
    try {
      final url = Uri.parse("$baseUrl/complaints");

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "title": title,
          "description": description,
          "category": category,
          "location": location,
        }),
      );

      print("POST STATUS: ${response.statusCode}");
      print("POST BODY: ${response.body}");
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print("API ERROR: $e");
      return false;
    }
  }

  // Get all complaints
  static Future<List<Complaint>> getComplaints() async {
    try {
      final url = Uri.parse("$baseUrl/complaints");
      final response = await http.get(url);

      print("GET STATUS: ${response.statusCode}");
      print("GET BODY: ${response.body}");

      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);
        return data.map((e) => Complaint.fromJson(e)).toList();
      }

      return [];
    } catch (e) {
      print("API ERROR: $e");
      return [];
    }
  }

  // Delete a complaint
  static Future<bool> deleteComplaint(int id) async {
    try {
      final url = Uri.parse("$baseUrl/complaints/$id");
      final response = await http.delete(url);
      print("DELETE STATUS: ${response.statusCode}");
      return response.statusCode == 200;
    } catch (e) {
      print("API ERROR: $e");
      return false;
    }
  }
}
