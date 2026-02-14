import 'package:flutter/material.dart';
import '../services/api_service.dart';

class SubmitComplaintScreen extends StatefulWidget {
  const SubmitComplaintScreen({super.key});

  @override
  State<SubmitComplaintScreen> createState() =>
      _SubmitComplaintScreenState();
}

class _SubmitComplaintScreenState
    extends State<SubmitComplaintScreen> {

  final title = TextEditingController();
  final desc = TextEditingController();
  final location = TextEditingController();

  String category = "Road";
  bool loading = false;

  Future submit() async {

    setState(() => loading = true);

    bool success = await ApiService.submitComplaint(
      title: title.text,
      description: desc.text,
      category: category,
      location: location.text,
    );

    setState(() => loading = false);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text(success ? "Complaint Submitted" : "Submission Failed"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Submit Complaint")),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            _field("Title", title),
            const SizedBox(height: 14),

            _field("Description", desc),
            const SizedBox(height: 14),

            DropdownButtonFormField(
              initialValue: category,
              decoration: _decoration("Category"),
              items: ["Road", "Garbage", "Water", "Electricity"]
                  .map((e) =>
                      DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) => setState(() => category = v!),
            ),

            const SizedBox(height: 14),
            _field("Location", location),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: loading ? null : submit,
                child: loading
                    ? const CircularProgressIndicator(
                        color: Color.fromARGB(255, 0, 0, 0))
                    : const Text("Submit Complaint"),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _field(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: _decoration(label),
    );
  }

  InputDecoration _decoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: const Color.fromARGB(255, 239, 227, 227),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }
}
