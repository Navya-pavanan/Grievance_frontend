import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/complaint_model.dart';

class ComplaintListScreen extends StatefulWidget {
  const ComplaintListScreen({super.key});

  @override
  State<ComplaintListScreen> createState() =>
      _ComplaintListScreenState();
}

class _ComplaintListScreenState
    extends State<ComplaintListScreen> {

  late Future<List<Complaint>> complaints;

  @override
  void initState() {
    super.initState();
    complaints = ApiService.getComplaints();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Complaints", style: TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0.5))),
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F172A), Color(0xFF1E1B4B)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )
        ),
        child: FutureBuilder<List<Complaint>>(
          future: complaints,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator(color: Color(0xFF4F46E5)));
            }

            final data = snapshot.data!;
            
            if (data.isEmpty) {
              return Center(child: Text("No complaints found.", style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 16)));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(20),
              physics: const BouncingScrollPhysics(),
              itemCount: data.length,
              itemBuilder: (_, i) {
                final c = data[i];

                String slaStatus = 'On Track';
                if (c.status == 'Resolved') {
                  slaStatus = 'Archived';
                } else {
                  try {
                    final deadline = DateTime.parse(c.sla_deadline);
                    if (DateTime.now().isAfter(deadline)) slaStatus = 'Overdue';
                  } catch(_) {}
                }

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.1), width: 1.5),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    title: Text(c.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF4F46E5).withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(c.category, style: const TextStyle(color: Color(0xFF818CF8), fontWeight: FontWeight.w600, fontSize: 12)),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: c.status == 'Resolved' ? Colors.green.withOpacity(0.2) : Colors.orange.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(c.status, style: TextStyle(color: c.status == 'Resolved' ? Colors.greenAccent : Colors.orangeAccent, fontWeight: FontWeight.w600, fontSize: 12)),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: slaStatus == 'Overdue' ? Colors.red.withOpacity(0.2) : (slaStatus == 'Archived' ? Colors.grey.withOpacity(0.2) : Colors.blue.withOpacity(0.2)),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(slaStatus, style: TextStyle(color: slaStatus == 'Overdue' ? Colors.redAccent : (slaStatus == 'Archived' ? Colors.grey : Colors.lightBlueAccent), fontWeight: FontWeight.w600, fontSize: 12)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(c.resolution_note != null && c.resolution_note!.isNotEmpty ? "Resolution: ${c.resolution_note}" : 'No resolution notes yet', 
                            style: TextStyle(color: Colors.white.withOpacity(0.6), height: 1.4, fontSize: 14)),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
