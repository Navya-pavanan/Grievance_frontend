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
        title: const Text("Admin Portal", style: TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0.5)),
      ),
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F172A), Color(0xFF1E1B4B)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )
        ),
        child: loading
            ? const Center(child: CircularProgressIndicator(color: Color(0xFFF59E0B)))
            : Column(
                children: [
                  // -----------------------------
                  // Department Filter Dropdown
                  // -----------------------------
                  Container(
                    margin: const EdgeInsets.all(20.0),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withOpacity(0.1), width: 1.5),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        dropdownColor: const Color(0xFF1E1B4B),
                        value: selectedDepartment,
                        isExpanded: true,
                        icon: const Icon(Icons.filter_list, color: Colors.white),
                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                        items: ["All", "Sanitation", "Public Works", "Electric Board", "Water Supply", "Road", "Garbage", "Water", "Electricity"]
                            .toSet().toList()
                            .map((d) => DropdownMenuItem(value: d, child: Text("Department: $d")))
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
                  ),
                  
                  // -----------------------------
                  // Complaints List
                  // -----------------------------
                  Expanded(
                    child: complaints.isEmpty
                        ? Center(child: Text("No complaints found.", style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 16)))
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            physics: const BouncingScrollPhysics(),
                            itemCount: complaints.length,
                            itemBuilder: (context, index) {
                              return AdminComplaintCard(
                                complaint: complaints[index],
                                onUpdate: updateComplaint,
                                onRefresh: fetchDepartmentComplaints,
                              );
                            },
                          ),
                  ),
                ],
              ),
      ),
    );
  }
}

class AdminComplaintCard extends StatefulWidget {
  final Complaint complaint;
  final Function(Complaint, String, String) onUpdate;
  final VoidCallback onRefresh;

  const AdminComplaintCard({
    Key? key, 
    required this.complaint, 
    required this.onUpdate,
    required this.onRefresh,
  }) : super(key: key);

  @override
  State<AdminComplaintCard> createState() => _AdminComplaintCardState();
}

class _AdminComplaintCardState extends State<AdminComplaintCard> {
  bool isExpanded = false;
  late String selectedStatus;
  late TextEditingController resolutionController;

  @override
  void initState() {
    super.initState();
    selectedStatus = widget.complaint.status;
    resolutionController = TextEditingController(text: widget.complaint.resolution_note);
  }

  @override
  void didUpdateWidget(covariant AdminComplaintCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.complaint.id != widget.complaint.id) {
       selectedStatus = widget.complaint.status;
       resolutionController.text = widget.complaint.resolution_note ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    final complaint = widget.complaint;
    String slaStatus = 'On Track';
    if (complaint.status == 'Resolved') {
      slaStatus = 'Archived';
    } else {
      try {
        final deadline = DateTime.parse(complaint.sla_deadline);
        if (DateTime.now().isAfter(deadline)) slaStatus = 'Overdue';
      } catch(_) {}
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1.5),
        boxShadow: [
           if (isExpanded) BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 15, offset: const Offset(0, 10))
        ]
      ),
      child: AnimatedSize(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
                behavior: HitTestBehavior.opaque,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(complaint.title,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: slaStatus == 'Overdue' ? Colors.red.withOpacity(0.2) : (slaStatus == 'Archived' ? Colors.grey.withOpacity(0.2) : Colors.blue.withOpacity(0.2)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(slaStatus, style: TextStyle(color: slaStatus == 'Overdue' ? Colors.redAccent : (slaStatus == 'Archived' ? Colors.grey : Colors.lightBlueAccent), fontWeight: FontWeight.w600, fontSize: 12)),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: complaint.status == 'Resolved' ? Colors.green.withOpacity(0.2) : Colors.orange.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(complaint.status, style: TextStyle(color: complaint.status == 'Resolved' ? Colors.greenAccent : Colors.orangeAccent, fontWeight: FontWeight.w600, fontSize: 12)),
                        ),
                        const SizedBox(width: 8),
                        Icon(isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: Colors.white54),
                      ],
                    ),
                  ],
                ),
              ),
              if (isExpanded) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(complaint.description, style: TextStyle(color: Colors.white.withOpacity(0.8), height: 1.4, fontSize: 14)),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Color(0xFFF59E0B), size: 16),
                    const SizedBox(width: 4),
                    Text(complaint.location, style: const TextStyle(color: Colors.white70, fontSize: 13)),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(color: Colors.white24, thickness: 1),
                const SizedBox(height: 16),
                
                // Status Update
                Text("Manage Status & Resolution", style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                const SizedBox(height: 12),
                
                DropdownButtonFormField<String>(
                  value: selectedStatus,
                  dropdownColor: const Color(0xFF1E1B4B),
                  icon: const Icon(Icons.arrow_drop_down, color: Color(0xFFF59E0B)),
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.black.withOpacity(0.3),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                  items: const [
                    DropdownMenuItem(value: "Pending", child: Text("Pending")),
                    DropdownMenuItem(value: "In Progress", child: Text("In Progress")),
                    DropdownMenuItem(value: "Resolved", child: Text("Resolved")),
                    DropdownMenuItem(value: "Escalated", child: Text("Escalated")),
                  ],
                  onChanged: (val) {
                    if (val != null) setState(() => selectedStatus = val);
                  },
                ),
                const SizedBox(height: 12),

                // Resolution text field
                TextField(
                  controller: resolutionController,
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                  maxLines: 2,
                  decoration: InputDecoration(
                    hintText: "Enter resolution remarks...",
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
                    filled: true,
                    fillColor: Colors.black.withOpacity(0.3),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onUpdate(complaint, selectedStatus, resolutionController.text);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF59E0B),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text("Commit Update", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, letterSpacing: 0.5)),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () async {
                      bool? confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: const Color(0xFF1E1B4B),
                          title: const Text("Delete Complaint?", style: TextStyle(color: Colors.white)),
                          content: const Text("Are you sure you want to permanently delete this item?", style: TextStyle(color: Colors.white70)),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel", style: TextStyle(color: Colors.white60))),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true), 
                              child: const Text("Delete", style: TextStyle(color: Colors.redAccent))
                            ),
                          ]
                        )
                      );
                      if (confirm == true) {
                          bool ok = await ApiService.deleteComplaint(complaint.id);
                          if (ok) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Deleted successfully")));
                            }
                            widget.onRefresh();
                          }
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.redAccent, width: 1.5),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text("Delete Complaint", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 15, letterSpacing: 0.5)),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
