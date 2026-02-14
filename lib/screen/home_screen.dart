import 'package:flutter/material.dart';
import 'submit_complaint_screen.dart';
import 'complaint_list_screen.dart';
// import 'admin_complaint_screen.dart'; // <- import admin screen
import 'admin_login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Grievance Portal"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            // 1️⃣ Submit Complaint
            _menuCard(
              context,
              title: "Submit Complaint",
              icon: Icons.report_problem,
              screen: const SubmitComplaintScreen(),
            ),
            const SizedBox(height: 20),

            // 2️⃣ View Complaints
            _menuCard(
              context,
              title: "View Complaints",
              icon: Icons.list_alt,
              screen: const ComplaintListScreen(),
            ),
            const SizedBox(height: 20),

            // 3️⃣ Admin Screen
            // _menuCard(
            //   context,
            //   title: "Manage Complaints (Admin)",
            //   icon: Icons.admin_panel_settings,
            //   screen: const AdminComplaintScreen(department: "Sanitation"), // Pass department
            // ),
            _menuCard(
  context,
  title: "Manage Complaints (Admin)",
  icon: Icons.admin_panel_settings,
  screen: const AdminLoginScreen(),
),
          ],
        ),
      ),
    );
  }

  Widget _menuCard(BuildContext context,
      {required String title, required IconData icon, required Widget screen}) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => screen),
      ),
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.05),
              blurRadius: 10,
            )
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 32, color: const Color.fromARGB(255, 94, 87, 227)),
            const SizedBox(width: 16),
            Text(title,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'submit_complaint_screen.dart';
// import 'complaint_list_screen.dart';

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Grievance Portal"),
//         centerTitle: true,
//         flexibleSpace: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Color(0xFF4F46E5), Color(0xFF6366F1)],
//             ),
//           ),
//         ),
//       ),

//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: [

//             const SizedBox(height: 20),

//             _menuCard(
//               context,
//               title: "Submit Complaint",
//               icon: Icons.report_problem,
//               screen: const SubmitComplaintScreen(),
//             ),

//             const SizedBox(height: 20),

//             _menuCard(
//               context,
//               title: "View Complaints",
//               icon: Icons.list_alt,
//               screen: const ComplaintListScreen(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _menuCard(BuildContext context,
//       {required String title,
//       required IconData icon,
//       required Widget screen}) {

//     return GestureDetector(
//       onTap: () => Navigator.push(
//         context,
//         MaterialPageRoute(builder: (_) => screen),
//       ),
//       child: Container(
//         padding: const EdgeInsets.all(22),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(18),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(.05),
//               blurRadius: 10,
//             )
//           ],
//         ),
//         child: Row(
//           children: [
//             Icon(icon, size: 32, color: const Color(0xFF4F46E5)),
//             const SizedBox(width: 16),
//             Text(title,
//                 style: const TextStyle(
//                     fontSize: 18, fontWeight: FontWeight.w600)),
//           ],
//         ),
//       ),
//     );
//   }
// }
