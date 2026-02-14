// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import '../models/complaint_model.dart';
// import '../services/api_service.dart';

// class AdminComplaintScreen extends StatefulWidget {
//   final String department; // e.g. "Sanitation", "Electric Board"

//   const AdminComplaintScreen({Key? key, required this.department}) : super(key: key);

//   @override
//   State<AdminComplaintScreen> createState() => _AdminComplaintScreenState();
// }

// class _AdminComplaintScreenState extends State<AdminComplaintScreen> {
//   List<Complaint> complaints = [];
//   bool loading = true;
  
//   @override
//   void initState() {
//     super.initState();
//     fetchDepartmentComplaints();
//   }

//   Future<void> fetchDepartmentComplaints() async {
//     setState(() => loading = true);
//     try {
//       final url = Uri.parse("${ApiService.baseUrl}/complaints/department/${widget.department}");
//       final response = await http.get(url);

//       if (response.statusCode == 200) {
//         List data = jsonDecode(response.body);
//         complaints = data.map((e) => Complaint.fromJson(e)).toList();
//       } else {
//         complaints = [];
//       }
//     } catch (e) {
//       print("Error fetching complaints: $e");
//       complaints = [];
//     } finally {
//       setState(() => loading = false);
//     }
//   }

//   Future<void> updateComplaint(Complaint complaint, String status, String resolution) async {
//     try {
//       final url = Uri.parse(
//           "${ApiService.baseUrl}/complaints/${complaint.id}?status=$status&resolution=$resolution");
//       final response = await http.put(url);

//       if (response.statusCode == 200) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Complaint updated successfully")),
//         );
//         fetchDepartmentComplaints(); // Refresh list
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Failed to update complaint")),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error: $e")),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("${widget.department} Complaints"),
//       ),
//       body: loading
//           ? const Center(child: CircularProgressIndicator())
//           : complaints.isEmpty
//               ? const Center(child: Text("No complaints found"))
//               : ListView.builder(
//                   itemCount: complaints.length,
//                   itemBuilder: (context, index) {
//                     final complaint = complaints[index];
//                     String selectedStatus = complaint.status;
//                     TextEditingController resolutionController =
//                         TextEditingController();

//                     return Card(
//                       margin: const EdgeInsets.all(8.0),
//                       child: Padding(
//                         padding: const EdgeInsets.all(12.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text("Title: ${complaint.title}",
//                                 style: const TextStyle(
//                                     fontWeight: FontWeight.bold)),
//                             const SizedBox(height: 4),
//                             Text("Description: ${complaint.description}"),
//                             const SizedBox(height: 4),
//                             Text("Location: ${complaint.location}"),
//                             const SizedBox(height: 4),
//                             Text("Current Status: ${complaint.status}"),
//                             const SizedBox(height: 8),
//                             // Status dropdown
//                             DropdownButtonFormField<String>(
//                               value: selectedStatus,
//                               decoration: const InputDecoration(
//                                 labelText: "Update Status",
//                                 border: OutlineInputBorder(),
//                               ),
//                               items: const [
//                                 DropdownMenuItem(
//                                   value: "Pending",
//                                   child: Text("Pending"),
//                                 ),
//                                 DropdownMenuItem(
//                                   value: "In Progress",
//                                   child: Text("In Progress"),
//                                 ),
//                                 DropdownMenuItem(
//                                   value: "Resolved",
//                                   child: Text("Resolved"),
//                                 ),
//                                 DropdownMenuItem(
//                                   value: "Escalated",
//                                   child: Text("Escalated"),
//                                 ),
//                               ],
//                               onChanged: (val) {
//                                 if (val != null) selectedStatus = val;
//                               },
//                             ),
//                             const SizedBox(height: 8),
//                             // Resolution text field
//                             TextField(
//                               controller: resolutionController,
//                               decoration: const InputDecoration(
//                                 labelText: "Resolution Note",
//                                 border: OutlineInputBorder(),
//                               ),
//                             ),
//                             const SizedBox(height: 8),
//                             ElevatedButton(
//                               onPressed: () {
//                                 updateComplaint(complaint, selectedStatus,
//                                     resolutionController.text);
//                               },
//                               child: const Text("Update Complaint"),
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//     );
//   }
// }
import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/complaint_model.dart';
import '../services/api_service.dart';

class AdminComplaintScreen extends StatefulWidget {
  final String department; // default department for this admin

  const AdminComplaintScreen({Key? key, required this.department}) : super(key: key);

  @override
  State<AdminComplaintScreen> createState() => _AdminComplaintScreenState();
}

class _AdminComplaintScreenState extends State<AdminComplaintScreen> {
  List<Complaint> complaints = [];
  bool loading = true;
  late String selectedDepartment;

  @override
  void initState() {
    super.initState();
    selectedDepartment = widget.department;
    fetchDepartmentComplaints();
  }

  // -----------------------------
  // Fetch complaints based on selectedDepartment
  // -----------------------------
  Future<void> fetchDepartmentComplaints() async {
    setState(() => loading = true);
    try {
      Uri url;
      if (selectedDepartment == "All") {
        url = Uri.parse("${ApiService.baseUrl}/complaints");
      } else {
        url = Uri.parse("${ApiService.baseUrl}/complaints/department/$selectedDepartment");
      }

      final response = await http.get(url);

      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);
        complaints = data.map((e) => Complaint.fromJson(e)).toList();
      } else {
        complaints = [];
      }
    } catch (e) {
      print("Error fetching complaints: $e");
      complaints = [];
    } finally {
      setState(() => loading = false);
    }
  }

  // -----------------------------
  // Update complaint status & resolution
  // -----------------------------
  Future<void> updateComplaint(Complaint complaint, String status, String resolution) async {
    try {
      final url = Uri.parse(
          "${ApiService.baseUrl}/complaints/${complaint.id}?status=$status&resolution=$resolution");
      final response = await http.put(url);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Complaint updated successfully")),
        );
        fetchDepartmentComplaints();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to update complaint")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Complaints"),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // -----------------------------
                // Department Filter Dropdown
                // -----------------------------
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: DropdownButton<String>(
                    value: selectedDepartment,
                    isExpanded: true,
                    items: ["All", "Sanitation", "Public Works", "Electric Board", "Water Supply"]
                        .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          selectedDepartment = val;
                          fetchDepartmentComplaints();
                        });
                      }
                    },
                  ),
                ),

                // -----------------------------
                // Complaints List
                // -----------------------------
                Expanded(
                  child: complaints.isEmpty
                      ? const Center(child: Text("No complaints found"))
                      : ListView.builder(
                          itemCount: complaints.length,
                          itemBuilder: (context, index) {
                            final complaint = complaints[index];
                            String selectedStatus = complaint.status;
                            TextEditingController resolutionController =
                                TextEditingController(text: complaint.resolution_note);

                            return Card(
                              margin: const EdgeInsets.all(8.0),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Title: ${complaint.title}",
                                        style: const TextStyle(fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 4),
                                    Text("Description: ${complaint.description}"),
                                    const SizedBox(height: 4),
                                    Text("Location: ${complaint.location}"),
                                    const SizedBox(height: 4),
                                    Text("Current Status: ${complaint.status}"),
                                    const SizedBox(height: 4),
                                    Text("Resolution: ${complaint.resolution_note ?? 'Not available'}"),
                                    const SizedBox(height: 8),

                                    // Status dropdown
                                    DropdownButtonFormField<String>(
                                      value: selectedStatus,
                                      decoration: const InputDecoration(
                                        labelText: "Update Status",
                                        border: OutlineInputBorder(),
                                      ),
                                      items: const [
                                        DropdownMenuItem(value: "Pending", child: Text("Pending")),
                                        DropdownMenuItem(value: "In Progress", child: Text("In Progress")),
                                        DropdownMenuItem(value: "Resolved", child: Text("Resolved")),
                                        DropdownMenuItem(value: "Escalated", child: Text("Escalated")),
                                      ],
                                      onChanged: (val) {
                                        if (val != null) selectedStatus = val;
                                      },
                                    ),
                                    const SizedBox(height: 8),

                                    // Resolution text field
                                    TextField(
                                      controller: resolutionController,
                                      decoration: const InputDecoration(
                                        labelText: "Resolution Note",
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                    const SizedBox(height: 8),

                                    ElevatedButton(
                                      onPressed: () {
                                        updateComplaint(
                                            complaint, selectedStatus, resolutionController.text);
                                      },
                                      child: const Text("Update Complaint"),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
