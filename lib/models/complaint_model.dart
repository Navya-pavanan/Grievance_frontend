// class Complaint {
//   final int id;
//   final String title;
//   final String category;
//   final String status;

//   Complaint({
//     required this.id,
//     required this.title,
//     required this.category,
//     required this.status,
//   });

//   factory Complaint.fromJson(Map<String, dynamic> json) {
//     return Complaint(
//       id: json['id'],
//       title: json['title'],
//       category: json['category'],
//       status: json['status'],
//     );
//   }
// }
class Complaint {
  final int id;
  final String title;
  final String description;
  final String category;
  final String location;
  final String department;
  final int priority_score;
  final String status;
  final String sla_deadline;
  final bool escalated;
  final String? resolution_note; // optional

  Complaint({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.location,
    required this.department,
    required this.priority_score,
    required this.status,
    required this.sla_deadline,
    required this.escalated,
    this.resolution_note,
  });

  factory Complaint.fromJson(Map<String, dynamic> json) {
    return Complaint(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      category: json['category'],
      location: json['location'],
      department: json['department'],
      priority_score: json['priority_score'],
      status: json['status'],
      sla_deadline: json['sla_deadline'],
      escalated: json['escalated'],
      resolution_note: json['resolution_note'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'category': category,
        'location': location,
        'department': department,
        'priority_score': priority_score,
        'status': status,
        'sla_deadline': sla_deadline,
        'escalated': escalated,
        'resolution_note': resolution_note,
      };
}
