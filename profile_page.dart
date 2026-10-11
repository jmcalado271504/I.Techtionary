import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  String formatDate(Timestamp? timestamp) {
    if (timestamp == null) return "Unknown";

    final date = timestamp.toDate();

    const months = [
      '',
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];

    return "${months[date.month]} ${date.day}, ${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text("No user logged in."),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(
              child: Text("Profile not found"),
            );
          }

          final data =
          snapshot.data!.data() as Map<String, dynamic>;

          final firstName = data['firstName'] ?? '';
          final lastName = data['lastName'] ?? '';
          final suffix = data['suffix'] ?? ''; // Kinukuha ang suffix mula sa database

          // Pinagsasama ang pangalan kasama ang suffix kung mayroon man
          final fullName = suffix.trim().isNotEmpty
              ? "$firstName $lastName $suffix"
              : "$firstName $lastName";

          final email = data['email'] ?? '';
          final role = (data['role'] ?? 'Student').toString();
          final formattedRole = role.isNotEmpty
              ? role[0].toUpperCase() + role.substring(1)
              : 'Student';
          final createdAt = data['createdAt'] as Timestamp?;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 45,
                          child: Text(
                            firstName.isNotEmpty
                                ? firstName[0].toUpperCase()
                                : "?",
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          fullName, // Nagpapakita na ngayon ng may kasamang suffix (kung meron)
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          email,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  elevation: 2,
                  child: ListTile(
                    leading: const Icon(Icons.calendar_month),
                    title: const Text("Member Since"),
                    subtitle: Text(
                      formatDate(createdAt),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Account Information",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge,
                  ),
                ),
                const SizedBox(height: 10),
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.person),
                        title: const Text("First Name"),
                        subtitle: Text(firstName),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.badge),
                        title: const Text("Last Name"),
                        subtitle: Text(lastName),
                      ),
                      if (suffix.trim().isNotEmpty) ...[
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.title),
                          title: const Text("Suffix"),
                          subtitle: Text(suffix),
                        ),
                      ],
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.work_outline),
                        title: const Text("Role"),
                        subtitle: Text(formattedRole),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.email),
                        title: const Text("Email"),
                        subtitle: Text(email),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                Text(
                  "I.Techtionary",
                  style: TextStyle(
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}