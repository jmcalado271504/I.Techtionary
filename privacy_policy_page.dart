import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Privacy Policy"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            // Text(
            //   "Privacy Policy",
            //   style: TextStyle(
            //     fontSize: 28,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
            //
            // SizedBox(height: 10),

            // Text(
            //   "Last Updated: June 2026",
            //   style: TextStyle(
            //     color: Colors.grey,
            //   ),
            // ),
            //
            // SizedBox(height: 25),

            Text(
              "Introduction",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 8),

            Text(
              "I.Techtionary values your privacy and is committed to protecting your personal information. This Privacy Policy explains how we collect, use, and safeguard the information you provide while using the application.",
            ),

            SizedBox(height: 25),

            Text(
              "Information We Collect",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 8),

            Text(
              "• First Name\n"
                  "• Last Name\n"
                  "• Email Address\n"
                  "• Learning Progress\n"
                  "• Bookmarks and Saved Content\n"
                  "• Quiz Results and Scores",
            ),

            SizedBox(height: 25),

            Text(
              "How We Use Your Information",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 8),

            Text(
              "We use your information to provide learning services, manage user accounts, save bookmarks, track quiz performance, improve user experience, and maintain platform security.",
            ),

            SizedBox(height: 25),

            Text(
              "Data Security",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 8),

            Text(
              "We implement reasonable security measures to protect your information from unauthorized access, disclosure, or misuse. However, no online system can guarantee complete security.",
            ),

            SizedBox(height: 25),

            Text(
              "Third-Party Services",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 8),

            Text(
              "I.Techtionary uses Firebase services for authentication, database storage, and application functionality. These services may process data according to their own privacy policies.",
            ),

            SizedBox(height: 25),

            Text(
              "User Responsibilities",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 8),

            Text(
              "Users are responsible for maintaining the confidentiality of their account credentials and for all activities performed under their accounts.",
            ),

            SizedBox(height: 25),

            // Text(
            //   "Changes to This Policy",
            //   style: TextStyle(
            //     fontSize: 20,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
            //
            // SizedBox(height: 8),
            //
            // Text(
            //   "This Privacy Policy may be updated from time to time. Continued use of the application after changes are posted constitutes acceptance of the updated policy.",
            // ),
            //
            // SizedBox(height: 25),

            Text(
              "Contact Us",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 8),

            Text(
              "If you have questions regarding this Privacy Policy, please contact the I.Techtionary development team.",
            ),

            SizedBox(height: 40),

            Center(
              child: Text(
                "© 2026 I.techtionary. All Rights Reserved.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}