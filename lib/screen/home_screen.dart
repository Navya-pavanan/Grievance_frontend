import 'package:flutter/material.dart';
import 'submit_complaint_screen.dart';
import 'complaint_list_screen.dart';
import 'admin_login_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F172A), Color(0xFF1E1B4B)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text("Grievance Portal", style: TextStyle(color: Color(0xFF94A3B8), fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 1.2)),
                        SizedBox(height: 8),
                        Text("Hello, User", style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFF4F46E5), width: 2),
                        boxShadow: [BoxShadow(color: const Color(0xFF4F46E5).withOpacity(0.5), blurRadius: 15)]
                      ),
                      child: const CircleAvatar(
                        radius: 24,
                        backgroundColor: Color(0xFF1E293B),
                        child: Icon(Icons.person, color: Colors.white, size: 24),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),
              
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      InteractiveCard(
                        title: "Submit Complaint",
                        subtitle: "Report an issue in your locality instantly",
                        icon: Icons.report_problem,
                        gradient: const [Color(0xFF4F46E5), Color(0xFF6366F1)],
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const SubmitComplaintScreen()));
                        },
                      ),
                      const SizedBox(height: 20),
                      InteractiveCard(
                        title: "View Complaints",
                        subtitle: "Track resolution status live via portal",
                        icon: Icons.list_alt,
                        gradient: const [Color(0xFF10B981), Color(0xFF059669)],
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const ComplaintListScreen()));
                        },
                      ),
                      const SizedBox(height: 20),
                      InteractiveCard(
                        title: "Manage Complaints",
                        subtitle: "Secure administrative resolution portal",
                        icon: Icons.admin_panel_settings,
                        gradient: const [Color(0xFFF59E0B), Color(0xFFD97706)],
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminLoginScreen()));
                        },
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InteractiveCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> gradient;
  final VoidCallback onTap;

  const InteractiveCard({
    super.key, 
    required this.title, 
    required this.subtitle,
    required this.icon, 
    required this.gradient,
    required this.onTap
  });

  @override
  State<InteractiveCard> createState() => _InteractiveCardState();
}

class _InteractiveCardState extends State<InteractiveCard> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => isPressed = true),
      onTapUp: (_) {
         setState(() => isPressed = false);
         widget.onTap();
      },
      onTapCancel: () => setState(() => isPressed = false),
      child: AnimatedScale(
        scale: isPressed ? 0.94 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutExpo,
        child: Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.1), width: 1.5),
            boxShadow: [
              if (isPressed)
                BoxShadow(
                  color: widget.gradient.first.withOpacity(0.2),
                  blurRadius: 20,
                  spreadRadius: 2,
                )
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: widget.gradient, 
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: widget.gradient.first.withOpacity(0.4),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    )
                  ],
                ),
                child: Icon(widget.icon, size: 30, color: Colors.white),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.title,
                        style: const TextStyle(
                            fontSize: 19, 
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: 0.5)),
                    const SizedBox(height: 6),
                    Text(widget.subtitle,
                        style: TextStyle(
                            fontSize: 13, 
                            fontWeight: FontWeight.w400,
                            color: Colors.white.withOpacity(0.6))),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 18, color: Colors.white.withOpacity(0.3)),
            ],
          ),
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
