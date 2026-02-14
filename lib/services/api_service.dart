// // import 'dart:convert';
// // import 'package:http/http.dart' as http;
// // import '../models/complaint_model.dart';

// // class ApiService {

// //   static const String baseUrl = "http://127.0.0.1:8000";
  

// //   static Future<bool> submitComplaint({
// //     required String title,
// //     required String description,
// //     required String category,
// //     required String location,
// //   }) async {

// //     try {
// //       final response = await http.post(
// //         Uri.parse("$baseUrl/complaints"),
// //         headers: {"Content-Type": "application/json"},
// //         body: jsonEncode({
// //           "title": title,
// //           "description": description,
// //           "category": category,
// //           "location": location,
// //         }),
// //       );

// //       return response.statusCode == 200 || response.statusCode == 201;

// //     } catch (e) {
// //       return false;
// //     }
// //   }

// //   static Future<List<Complaint>> getComplaints() async {

// //     try {
// //       final response =
// //           await http.get(Uri.parse("$baseUrl/complaints"));

// //       if (response.statusCode == 200) {
// //         List data = jsonDecode(response.body);
// //         return data.map((e) => Complaint.fromJson(e)).toList();
// //       }

// //       return [];

// //     } catch (e) {
// //       return [];
// //     }
// //   }
// // }
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import '../models/complaint_model.dart';

// class ApiService {

//   // Base URL of your backend
// static const String baseUrl = "http://192.168.101.106:8000";


//   // -----------------------------
//   // Submit a new complaint
//   // -----------------------------
//   static Future<bool> submitComplaint({
//     required String title,
//     required String description,
//     required String category,
//     required String location,
//   }) async {
//     try {
//       final url = Uri.parse("$baseUrl/complaints");

//       // Send POST request
//       final response = await http.post(
//         url,
//         headers: {
//           "Content-Type": "application/json",
//         },
//         body: jsonEncode({
//           "title": title,
//           "description": description,
//           "category": category,
//           "location": location,
//         }),
//       );

//       // 🔹 DEBUG: Print response to console
//       print("POST STATUS: ${response.statusCode}");
//       print("POST BODY: ${response.body}");

//       // Return true if backend responded with 200 or 201
//       return response.statusCode == 200 || response.statusCode == 201;

//     } catch (e) {
//       // 🔹 DEBUG: Print exception to console
//       print("API ERROR: $e");
//       return false;
//     }
//   }

//   // -----------------------------
//   // Get all complaints
//   // -----------------------------
//   static Future<List<Complaint>> getComplaints() async {
//     try {
//       final url = Uri.parse("$baseUrl/complaints");

//       // Send GET request
//       final response = await http.get(url);

//       // 🔹 DEBUG: Print response to console
//       print("GET STATUS: ${response.statusCode}");
//       print("GET BODY: ${response.body}");

//       if (response.statusCode == 200) {
//         List data = jsonDecode(response.body);
//         return data.map((e) => Complaint.fromJson(e)).toList();
//       }

//       return [];

//     } catch (e) {
//       // 🔹 DEBUG: Print exception to console
//       print("API ERROR: $e");
//       return [];
//     }
//   }
// }
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/complaint_model.dart';

class ApiService {
  // Base URL of your backend
  static const String baseUrl = "https://grienvance-management.onrender.com";

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
}
