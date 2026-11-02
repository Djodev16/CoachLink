import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 🔥 Background Image
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/welcome2.png"),
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
          ),

          // 🔥 Gradient Overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.white.withOpacity(0.8),
                  Colors.white,
                ],
                stops: const [0.0, 0.6, 0.9],
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  const SizedBox(height: 320),

                  // 🔥 Title
                  const Text(
                    "CoachLink",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF08214E),
                      letterSpacing: 1.5,
                    ),
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    "Trouvez votre coach idéal",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.blueGrey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),

                  const Spacer(),

                  // ✅ Responsive Features
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 16,
                    runSpacing: 8,
                    children: const [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 20,
                          ),
                          SizedBox(width: 6),
                          Text(
                            "100+ Coachs certifiés",
                            style:
                                TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.bolt,
                            color: Colors.amber,
                            size: 20,
                          ),
                          SizedBox(width: 6),
                          Text(
                            "Réservez en 1 clic",
                            style:
                                TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // 🔥 Smart Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF407FD2),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 6,
                      ),

                      // ✅ هنا الحل الحقيقي
                      onPressed: () {
                        if (FirebaseAuth.instance.currentUser != null) {
                          Navigator.pushReplacementNamed(
                              context, "/home");
                        } else {
                          Navigator.pushNamed(
                              context, "/simple_welcome");
                        }
                      },

                      child: const Text(
                        "COMMENCER",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}