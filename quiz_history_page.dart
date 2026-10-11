import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class QuizHistoryPage extends StatelessWidget {
  const QuizHistoryPage({super.key});

  Color scoreColor(double percent) {
    if (percent >= 80) return Colors.green;
    if (percent >= 50) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text("No user logged in"),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Quiz History"),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('quiz_results')
            .where('userId', isEqualTo: user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          // Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // Error
          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Firestore Error:\n${snapshot.error}",
                textAlign: TextAlign.center,
              ),
            );
          }

          // No Data
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.quiz_outlined,
                    size: 80,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 15),
                  Text(
                    "No Quiz History Yet",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Complete quizzes to track your progress.",
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          final docs = snapshot.data!.docs;

          // Sort locally para hindi kailangan ng composite index sa Firestore
          docs.sort((a, b) {
            final aTime =
                (a['createdAt'] as Timestamp?)?.millisecondsSinceEpoch ?? 0;
            final bTime =
                (b['createdAt'] as Timestamp?)?.millisecondsSinceEpoch ?? 0;
            return bTime.compareTo(aTime);
          });

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;

              final courseTitle = data['courseTitle'] ?? '';
              final moduleTitle = data['moduleTitle'] ?? 'Unknown Module';

              // Pagsasamahin ang Course at Module kung may courseTitle
              final fullTitle = courseTitle.isNotEmpty
                  ? "$courseTitle - $moduleTitle"
                  : moduleTitle;

              final score = (data['score'] ?? 0) as num;
              final totalQuestions = (data['totalQuestions'] ?? 0) as num;
              final percent = (data['percentage'] ?? 0).toDouble();
              final timestamp = data['createdAt'] as Timestamp?;
              final date = timestamp?.toDate();

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                elevation: 3,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: scoreColor(percent).withOpacity(0.2),
                    child: Icon(
                      Icons.emoji_events,
                      color: scoreColor(percent),
                    ),
                  ),
                  title: Text(
                    fullTitle,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text("Score: $score / $totalQuestions"),
                      if (date != null)
                        Text(
                          "${date.month}/${date.day}/${date.year}",
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                    ],
                  ),
                  trailing: Text(
                    "${percent.toStringAsFixed(0)}%",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: scoreColor(percent),
                    ),
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