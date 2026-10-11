import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth_service.dart';
import 'sign_in_page.dart';
import '../userhub/dashboard_page.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final users = FirebaseFirestore.instance.collection("users");
  String search = "";

  Future<Map<String, dynamic>> getRatingsSummary() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('app_ratings')
        .get();

    if (snapshot.docs.isEmpty) {
      return {
        'average': 0.0,
        'total': 0,
      };
    }

    double totalStars = 0;
    for (final doc in snapshot.docs) {
      totalStars += (doc['rating'] ?? 0).toDouble();
    }

    return {
      'average': totalStars / snapshot.docs.length,
      'total': snapshot.docs.length,
    };
  }

  List<QueryDocumentSnapshot> filterUsers(List<QueryDocumentSnapshot> docs) {
    if (search.trim().isEmpty) return docs;
    final searchText = search.trim().toLowerCase();

    return docs.where((doc) {
      final data = doc.data() as Map<String, dynamic>;
      final email = (data['email'] ?? '').toString().toLowerCase();
      final firstName = (data['firstName'] ?? '').toString().toLowerCase();
      final lastName = (data['lastName'] ?? '').toString().toLowerCase();
      final role = (data['role'] ?? '').toString().toLowerCase();
      final fullName = '$firstName $lastName';

      return email.contains(searchText) ||
          firstName.contains(searchText) ||
          lastName.contains(searchText) ||
          fullName.contains(searchText) ||
          role.contains(searchText);
    }).toList();
  }

  Future<void> logout() async {
    await AuthService.signOut();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const SignInPage()),
          (route) => false,
    );
  }

  String getUserName(Map<String, dynamic> data) {
    final firstName = (data['firstName'] ?? '').toString().trim();
    final lastName = (data['lastName'] ?? '').toString().trim();
    final suffix = (data['suffix'] ?? '').toString().trim();

    List<String> parts = [];
    if (firstName.isNotEmpty) parts.add(firstName);
    if (lastName.isNotEmpty) parts.add(lastName);
    if (suffix.isNotEmpty) parts.add(suffix);

    final fullName = parts.join(' ');
    return fullName.isEmpty ? "Registered User" : fullName;
  }

  String getInitial(Map<String, dynamic> data, String email) {
    final firstName = (data['firstName'] ?? '').toString().trim();
    if (firstName.isNotEmpty) return firstName[0].toUpperCase();
    if (email.isNotEmpty) return email[0].toUpperCase();
    return "?";
  }

  String formatDate(dynamic value) {
    if (value is Timestamp) {
      final date = value.toDate();
      return "${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}/${date.year}";
    }
    return "Unknown";
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/images/I.Techtionary_logo.png',
              height: 28,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.school, size: 26);
              },
            ),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                "Admin Dashboard",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
        actions: [
          // Icon ng Tao para pumunta sa Dashboard Page na may kasamang plus button (isAdmin: true)[cite: 14]
          IconButton(
            tooltip: "Go to Dashboard",
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const DashboardPage(isAdmin: true)),
              );
            },
          ),

          // Logout Button
          IconButton(
            tooltip: "Logout",
            icon: const Icon(Icons.logout),
            onPressed: logout,
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned(
            top: -30,
            right: -30,
            child: Opacity(
              opacity: 0.05,
              child: Image.asset(
                "assets/images/admin_bg.png",
                width: 200,
                errorBuilder: (context, error, stackTrace) => const SizedBox(),
              ),
            ),
          ),
          Column(
            children: [
              FutureBuilder<Map<String, dynamic>>(
                future: getRatingsSummary(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const SizedBox(
                      height: 90,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  final avg = snapshot.data!['average'] as double;
                  final total = snapshot.data!['total'] as int;

                  return Container(
                    margin: const EdgeInsets.all(12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.amber.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 36),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "I.Techtionary Rating",
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "${avg.toStringAsFixed(1)} / 5.0 ($total user ratings)",
                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search registered users...",
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: search.isNotEmpty
                        ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () => setState(() => search = ""),
                    )
                        : null,
                    filled: true,
                    fillColor: scheme.surfaceContainerHighest,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (value) => setState(() => search = value),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                child: Row(
                  children: [
                    Icon(Icons.people_alt_outlined, color: scheme.primary),
                    const SizedBox(width: 8),
                    const Text(
                      "Registered Users",
                      style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: users.orderBy("createdAt", descending: true).snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final docs = snapshot.data?.docs ?? [];
                    final filtered = filterUsers(docs);

                    if (filtered.isEmpty) {
                      return const Center(child: Text("No registered users found."));
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.only(top: 6, bottom: 20),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final data = filtered[index].data() as Map<String, dynamic>;
                        final email = (data['email'] ?? '').toString();
                        final userName = getUserName(data);
                        final initial = getInitial(data, email);
                        final createdAt = formatDate(data['createdAt']);
                        final rawRole = (data['role'] ?? 'Student').toString();
                        final roleText = rawRole.isNotEmpty
                            ? rawRole[0].toUpperCase() + rawRole.substring(1)
                            : 'Student';

                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: scheme.primaryContainer,
                              child: Text(
                                initial,
                                style: TextStyle(
                                  color: scheme.onPrimaryContainer,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            title: Text(userName, style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text("$email\nRegistered: $createdAt"),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.blue.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                roleText,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}