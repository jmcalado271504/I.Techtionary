import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'it_terms_module.dart';
import 'it_terms_lesson.dart';
import '../services/bookmark_service.dart';

class ItTermsPage extends StatefulWidget {
  final String? initialTopic;
  const ItTermsPage({super.key, this.initialTopic});

  @override
  State<ItTermsPage> createState() => _ItTermsPageState();
}

class _ItTermsPageState extends State<ItTermsPage> {
  int currentModuleIndex = 0;
  int currentLessonIndex = 0;

  @override
  void initState() {
    super.initState();
    if (widget.initialTopic != null) {
      bool found = false;
      for (int m = 0; m < ItTermsModule.programmingModules.length; m++) {
        final mod = ItTermsModule.programmingModules[m];
        for (int l = 0; l < mod.lessons.length; l++) {
          if (mod.lessons[l].title.toLowerCase() == widget.initialTopic!.toLowerCase()) {
            currentModuleIndex = m;
            currentLessonIndex = l;
            found = true;
            break;
          }
        }
        if (found) break;
      }
    }
    _recordLessonHistory();
  }

  Future<void> _recordLessonHistory() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final activeModule = ItTermsModule.programmingModules[currentModuleIndex];
    final activeLesson = activeModule.lessons[currentLessonIndex];

    try {
      await FirebaseFirestore.instance.collection('lesson_history').add({
        'userId': user.uid,
        'techName': 'IT Terms',
        'moduleTitle': activeModule.moduleTitle,
        'lessonTitle': activeLesson.title,
        'visitedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint("Error saving lesson history: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeModule = ItTermsModule.programmingModules[currentModuleIndex];
    final activeLesson = activeModule.lessons[currentLessonIndex];
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("IT Terms"),
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu_book),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        actions: [
          if (user != null)
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .doc(user.uid)
                  .collection("bookmarks")
                  .doc(activeLesson.title)
                  .snapshots(),
              builder: (context, snapshot) {
                bool isBookmarked = false;
                if (snapshot.hasData && snapshot.data != null) {
                  isBookmarked = snapshot.data!.exists;
                }

                return IconButton(
                  icon: Icon(
                    isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                    color: isBookmarked ? Colors.black : null,
                  ),
                  onPressed: () async {
                    try {
                      if (isBookmarked) {
                        await BookmarkService.removeBookmark(activeLesson.title);
                        if (!mounted) return;

                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("Removed"),
                            content: Text('"${activeLesson.title}" has been removed from your bookmarks.'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text("Okay"),
                              ),
                            ],
                          ),
                        );
                      } else {
                        await BookmarkService.addBookmark(
                          activeLesson.title,
                          activeLesson.definition,
                        );
                        if (!mounted) return;

                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("Success"),
                            content: Text('"${activeLesson.title}" has been added to your bookmarks.'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text("Okay"),
                              ),
                            ],
                          ),
                        );
                      }
                    } catch (e) {
                      if (!mounted) return;
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Error"),
                          content: Text("Error: $e"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text("Okay"),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                );
              },
            ),
        ],
      ),
      drawer: Drawer(
        width: MediaQuery.of(context).size.width * 0.72,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "IT Terms Module",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: ListView.builder(
                  itemCount: ItTermsModule.programmingModules.length,
                  itemBuilder: (context, modIdx) {
                    final module = ItTermsModule.programmingModules[modIdx];
                    return ExpansionTile(
                      leading: const Icon(Icons.menu_book),
                      title: Text(
                        module.moduleTitle,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      children: module.lessons.asMap().entries.map((entry) {
                        int lesIdx = entry.key;
                        var lesson = entry.value;
                        bool isSelected = currentModuleIndex == modIdx && currentLessonIndex == lesIdx;
                        return ListTile(
                          contentPadding: const EdgeInsets.only(left: 36, right: 16),
                          title: Text(
                            lesson.title,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              color: isSelected ? Colors.blue : (isDarkMode ? Colors.white70 : Colors.black87),
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              currentModuleIndex = modIdx;
                              currentLessonIndex = lesIdx;
                            });
                            _recordLessonHistory();
                            Navigator.pop(context);
                          },
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                activeModule.moduleTitle,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDarkMode ? Colors.white60 : Colors.grey[700],
                ),
              ),
            ),
            const SizedBox(height: 6),
            Center(
              child: Text(
                activeLesson.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Definition",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.blueAccent : Colors.blue[800],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      activeLesson.definition,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.4,
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Notes",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.blueAccent : Colors.blue[800],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      activeLesson.notes,
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.4,
                        color: isDarkMode ? Colors.white70 : Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                currentLessonIndex > 0
                    ? ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    setState(() {
                      if (currentLessonIndex > 0) {
                        currentLessonIndex--;
                      }
                    });
                    _recordLessonHistory();
                  },
                  icon: const Icon(Icons.arrow_back, size: 16),
                  label: const Text("Previous"),
                )
                    : const SizedBox(),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: currentLessonIndex < activeModule.lessons.length - 1
                      ? () {
                    setState(() {
                      currentLessonIndex++;
                    });
                    _recordLessonHistory();
                  }
                      : null,
                  label: const Text("Next"),
                  icon: const Icon(Icons.arrow_forward, size: 16),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}