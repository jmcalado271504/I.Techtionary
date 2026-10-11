import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'code_page.dart';

class SavedCodesPage extends StatefulWidget {
  const SavedCodesPage({super.key});

  @override
  State<SavedCodesPage> createState() => _SavedCodesPageState();
}

class _SavedCodesPageState extends State<SavedCodesPage> {
  // Function to show a dialog allowing the user to edit the project title
  void _editProjectTitle(BuildContext context, String docId, String currentTitle) {
    final TextEditingController titleController =
    TextEditingController(text: currentTitle);

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text("Edit Project Title"),
          content: TextField(
            controller: titleController,
            decoration: const InputDecoration(
              labelText: "Project Title",
              border: OutlineInputBorder(),
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                final newTitle = titleController.text.trim();
                if (newTitle.isNotEmpty) {
                  try {
                    await FirebaseFirestore.instance
                        .collection("saved_codes")
                        .doc(docId)
                        .update({"title": newTitle});

                    if (!mounted) return;
                    Navigator.of(dialogContext).pop();

                    // Show success popup dialog
                    showDialog(
                      context: context,
                      builder: (BuildContext ctx) {
                        return AlertDialog(
                          title: const Text("Success"),
                          content: const Text("Project title updated successfully."),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(ctx).pop();
                              },
                              child: const Text("Okay"),
                            ),
                          ],
                        );
                      },
                    );
                  } catch (e) {
                    if (!mounted) return;
                    Navigator.of(dialogContext).pop();

                    // Show error popup dialog
                    showDialog(
                      context: context,
                      builder: (BuildContext ctx) {
                        return AlertDialog(
                          title: const Text("Error"),
                          content: Text("Failed to update title.\n$e"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(ctx).pop();
                              },
                              child: const Text("Okay"),
                            ),
                          ],
                        );
                      },
                    );
                  }
                }
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text("User not logged in"),
        ),
      );
    }

    final stream = FirebaseFirestore.instance
        .collection("saved_codes")
        .where("uid", isEqualTo: user.uid)
        .orderBy("createdAt", descending: true)
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Saved Codes"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text("Something went wrong"),
            );
          }

          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return const Center(
              child: Text("No saved codes yet."),
            );
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final docId = docs[index].id;
              final currentTitle = data["title"] ?? "Untitled";

              return Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                child: ListTile(
                  leading: const Icon(Icons.code),
                  title: Text(currentTitle),
                  subtitle: Text(
                    "${(data["files"] as List?)?.length ?? 0} files",
                  ),
                  onTap: () {
                    final rawFiles = List<Map<String, dynamic>>.from(
                      data["files"] ?? [],
                    );

                    final projectFiles = rawFiles.map((e) {
                      return ProjectFile(
                        name: e["name"] ?? "",
                        type: e["type"] ?? "",
                        code: e["code"] ?? "",
                      );
                    }).toList();

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CodePage(
                          projectId: docId,
                          initialFiles: projectFiles,
                        ),
                      ),
                    );
                  },
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Edit Button
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          _editProjectTitle(context, docId, currentTitle);
                        },
                      ),
                      // Delete Button
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          await docs[index].reference.delete();

                          if (context.mounted) {
                            showDialog(
                              context: context,
                              builder: (BuildContext ctx) {
                                return AlertDialog(
                                  title: const Text("Success"),
                                  content: const Text("Project deleted successfully."),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(ctx).pop();
                                      },
                                      child: const Text("Okay"),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                      ),
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