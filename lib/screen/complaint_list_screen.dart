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
      appBar: AppBar(title: const Text("Complaints")),

      body: FutureBuilder<List<Complaint>>(
        future: complaints,
        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: data.length,
            itemBuilder: (_, i) {

              final c = data[i];

              return Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                child: ListTile(
                  title: Text(c.title),
                  subtitle: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text("${c.category} • ${c.status}"),
    const SizedBox(height: 4),
    Text("Resolution: ${c.resolution_note ?? 'Not available'}"),
  ],
),

                ),
              );
            },
          );
        },
      ),
    );
  }
}
