import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'add_lesson_page.dart';
import 'package:techtionary/services/bookmark_service.dart';

class DynamicTutorialPage extends StatefulWidget {
  final String techName;
  final bool isAdmin;
  final String? initialLessonTitle;

  const DynamicTutorialPage({
    super.key,
    required this.techName,
    this.isAdmin = false,
    this.initialLessonTitle,
  });

  @override
  State<DynamicTutorialPage> createState() => _DynamicTutorialPageState();
}

class _DynamicTutorialPageState extends State<DynamicTutorialPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  QueryDocumentSnapshot? _selectedDoc;
  Map<String, dynamic>? _selectedLesson;

  bool _isBookmarked = false;
  bool _isUserSelected = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _recordLessonHistory(String lessonTitle, String moduleTitle, String sectionType) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await FirebaseFirestore.instance.collection('lesson_history').add({
        'userId': user.uid,
        'techName': widget.techName,
        'moduleTitle': moduleTitle,
        'lessonTitle': lessonTitle,
        'sectionType': sectionType,
        'visitedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint("Error recording lesson history: $e");
    }
  }

  Future<void> _checkBookmarkStatus(String title) async {
    bool bookmarked = await BookmarkService.isBookmarked(title);
    if (mounted) {
      setState(() {
        _isBookmarked = bookmarked;
      });
    }
  }

  void _showAddEditDialog({QueryDocumentSnapshot? docToEdit}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddOrEditLessonPage(
          initialTech: widget.techName,
          existingDoc: docToEdit,
        ),
      ),
    );
  }

  IconData _getHistoryIcon(String title) {
    switch (title.toLowerCase()) {
      case 'release date':
        return Icons.calendar_month;
      case 'creator':
        return Icons.person;
      case 'country of origin':
        return Icons.flag;
      case 'why it was created':
        return Icons.lightbulb;
      case 'brief history':
        return Icons.menu_book;
      case 'evolution timeline':
        return Icons.timeline;
      case 'major milestones':
        return Icons.star;
      case 'famous quote':
        return Icons.format_quote;
      default:
        return Icons.history;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('lessons')
          .where('techName', isEqualTo: widget.techName)
          .snapshots(),
      builder: (context, snapshot) {
        bool hasLessons = false;
        List<QueryDocumentSnapshot> lessonDocs = [];

        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          hasLessons = true;
          lessonDocs = snapshot.data!.docs;

          if ((_selectedLesson == null || !_isUserSelected) && lessonDocs.isNotEmpty) {
            QueryDocumentSnapshot? targetDoc;

            if (widget.initialLessonTitle != null && !_isUserSelected) {
              try {
                targetDoc = lessonDocs.firstWhere((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  return (data['lessonTitle'] ?? '').toString().toLowerCase() ==
                      widget.initialLessonTitle!.toLowerCase();
                });
              } catch (e) {
                targetDoc = null;
              }
            }

            targetDoc ??= lessonDocs.first;

            _selectedDoc = targetDoc;
            _selectedLesson = targetDoc.data() as Map<String, dynamic>;
            _checkBookmarkStatus(_selectedLesson!['lessonTitle'] ?? widget.techName);
          } else if (_selectedDoc != null) {
            try {
              final updatedDoc = lessonDocs.firstWhere((doc) => doc.id == _selectedDoc!.id);
              _selectedDoc = updatedDoc;
              _selectedLesson = updatedDoc.data() as Map<String, dynamic>;
            } catch (e) {
              if (lessonDocs.isNotEmpty) {
                _selectedDoc = lessonDocs.first;
                _selectedLesson = lessonDocs.first.data() as Map<String, dynamic>;
              }
            }
          }
        }

        final historyDocs = lessonDocs.where((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return (data['sectionType'] ?? 'Module Section') == "History Section";
        }).toList();

        final moduleDocs = lessonDocs.where((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return (data['sectionType'] ?? 'Module Section') != "History Section";
        }).toList();

        final Map<String, List<QueryDocumentSnapshot>> groupedModules = {};
        for (var doc in moduleDocs) {
          final data = doc.data() as Map<String, dynamic>;
          final mTitle = data['moduleTitle'] ?? 'General Module';
          groupedModules.putIfAbsent(mTitle, () => []).add(doc);
        }

        List<QueryDocumentSnapshot> currentGroupDocs = [];
        if (_selectedLesson != null) {
          final sectionType = _selectedLesson!['sectionType'] ?? 'Module Section';
          if (sectionType == "History Section") {
            currentGroupDocs = historyDocs;
          } else {
            final currentModuleTitle = _selectedLesson!['moduleTitle'] ?? '';
            currentGroupDocs = moduleDocs.where((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return (data['moduleTitle'] ?? '') == currentModuleTitle;
            }).toList();
          }
        }

        int currentIndex = -1;
        if (_selectedDoc != null && currentGroupDocs.isNotEmpty) {
          currentIndex = currentGroupDocs.indexWhere((doc) => doc.id == _selectedDoc!.id);
        }

        final bool showPrevious = currentIndex > 0;
        final bool showNext = currentIndex >= 0 && currentIndex < currentGroupDocs.length - 1;

        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: isDarkMode ? const Color(0xFF121212) : Colors.white,
          appBar: AppBar(
            backgroundColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
            elevation: 0,
            leading: hasLessons
                ? IconButton(
              icon: Icon(Icons.menu_book, color: isDarkMode ? Colors.white : Colors.black),
              onPressed: () {
                _scaffoldKey.currentState?.openDrawer();
              },
            )
                : null,
            title: Text(
              widget.techName,
              style: TextStyle(color: isDarkMode ? Colors.white : Colors.black, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            actions: [
              if (widget.isAdmin)
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.blue, size: 28),
                  onPressed: () => _showAddEditDialog(),
                ),
              IconButton(
                icon: Icon(
                  _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                  color: _isBookmarked ? Colors.orange : (isDarkMode ? Colors.white : Colors.black),
                ),
                onPressed: () async {
                  if (_selectedLesson != null) {
                    final title = _selectedLesson!['lessonTitle'] ?? widget.techName;
                    final definition = _selectedLesson!['definition'] ?? 'No content provided.';
                    final code = _selectedLesson!['codeSnippet'] ?? '';
                    final notes = _selectedLesson!['notes'] ?? '';

                    final formattedContent = '''
$definition

---------------- CODE ----------------

$code

---------------- NOTES ----------------

$notes
''';

                    if (_isBookmarked) {
                      await BookmarkService.removeBookmark(title);
                      setState(() {
                        _isBookmarked = false;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Removed from bookmarks")),
                      );
                    } else {
                      await BookmarkService.addBookmark(title, formattedContent);
                      setState(() {
                        _isBookmarked = true;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Added to bookmarks")),
                      );
                    }
                  }
                },
              ),
            ],
          ),
          drawer: hasLessons
              ? Drawer(
            backgroundColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
            width: MediaQuery.of(context).size.width * 0.65,
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const SizedBox(height: 50),
                Center(
                  child: Text(
                    "${widget.techName} Tutorial",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                Divider(height: 30, color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300),

                // History Section
                if (historyDocs.isNotEmpty)
                  ExpansionTile(
                    iconColor: isDarkMode ? Colors.white70 : Colors.black54,
                    collapsedIconColor: isDarkMode ? Colors.white70 : Colors.black54,
                    leading: Icon(Icons.history, size: 20, color: isDarkMode ? Colors.white70 : Colors.black54),
                    title: Text(
                      "${widget.techName} History",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    children: historyDocs.map((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      final title = data['lessonTitle'] ?? 'History Item';
                      final isSelected = _selectedDoc?.id == doc.id;

                      return ListTile(
                        dense: true,
                        contentPadding: const EdgeInsets.only(left: 32, right: 16),
                        leading: Icon(
                          _getHistoryIcon(title),
                          size: 16,
                          color: isSelected ? Colors.blue : (isDarkMode ? Colors.grey.shade400 : Colors.grey),
                        ),
                        title: Text(
                          title,
                          style: TextStyle(
                            fontSize: 13,
                            color: isSelected ? Colors.blue : (isDarkMode ? Colors.white70 : Colors.black87),
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        trailing: widget.isAdmin
                            ? IconButton(
                          icon: Icon(Icons.edit, size: 14, color: isDarkMode ? Colors.grey.shade400 : Colors.grey),
                          onPressed: () {
                            Navigator.pop(context);
                            _showAddEditDialog(docToEdit: doc);
                          },
                        )
                            : null,
                        onTap: () {
                          setState(() {
                            _selectedDoc = doc;
                            _selectedLesson = data;
                            _isUserSelected = true;
                          });
                          _checkBookmarkStatus(title);
                          _recordLessonHistory(title, "${widget.techName} History", "History Section");
                          Navigator.pop(context);
                        },
                      );
                    }).toList(),
                  ),

                // Grouped Modules Sections
                ...groupedModules.entries.map((entry) {
                  final moduleTitle = entry.key;
                  final lessonsInModule = entry.value;

                  return ExpansionTile(
                    iconColor: isDarkMode ? Colors.white70 : Colors.black54,
                    collapsedIconColor: isDarkMode ? Colors.white70 : Colors.black54,
                    leading: Icon(Icons.menu_book, size: 20, color: isDarkMode ? Colors.white70 : Colors.black54),
                    title: Text(
                      moduleTitle,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    children: lessonsInModule.map((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      final lessonTitle = data['lessonTitle'] ?? 'Sub-item';
                      final isSelected = _selectedDoc?.id == doc.id;

                      return ListTile(
                        dense: true,
                        contentPadding: const EdgeInsets.only(left: 32, right: 16),
                        title: Text(
                          lessonTitle,
                          style: TextStyle(
                            fontSize: 13,
                            color: isSelected ? Colors.blue : (isDarkMode ? Colors.white70 : Colors.black87),
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        trailing: widget.isAdmin
                            ? IconButton(
                          icon: Icon(Icons.edit, size: 14, color: isDarkMode ? Colors.grey.shade400 : Colors.grey),
                          onPressed: () {
                            Navigator.pop(context);
                            _showAddEditDialog(docToEdit: doc);
                          },
                        )
                            : null,
                        onTap: () {
                          setState(() {
                            _selectedDoc = doc;
                            _selectedLesson = data;
                            _isUserSelected = true;
                          });
                          _checkBookmarkStatus(lessonTitle);
                          _recordLessonHistory(lessonTitle, moduleTitle, "Module Section");
                          Navigator.pop(context);
                        },
                      );
                    }).toList(),
                  );
                }),

                Divider(color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300),
                const SizedBox(height: 10),

                // Final Quiz Card
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Card(
                    color: isDarkMode ? const Color(0xFF2D2D2D) : Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.workspace_premium,
                            size: 32,
                            color: Colors.amber,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "${widget.techName.toUpperCase()} FINAL QUIZ",
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            height: 36,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.zero,
                              ),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext dialogContext) {
                                    return AlertDialog(
                                      title: Text("Coming Soon"),
                                      content: Text("${widget.techName} Final Quiz coming soon!"),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(dialogContext);
                                            Navigator.pop(context);
                                          },
                                          child: const Text("OK"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: const Text(
                                "Start Quiz",
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          )
              : null,
          body: !hasLessons
              ? Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                "No lessons found for ${widget.techName}. Add one using the '+' button.",
                textAlign: TextAlign.center,
                style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black87, fontSize: 15),
              ),
            ),
          )
              : _selectedLesson == null
              ? Center(
            child: Text(
              "Please select a lesson from the menu.",
              style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black),
            ),
          )
              : SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Previous & Next Arrow Navigation Bar
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      showPrevious
                          ? IconButton(
                        icon: Icon(Icons.arrow_back_ios_new, size: 20, color: isDarkMode ? Colors.white : Colors.black),
                        onPressed: () {
                          final prevDoc = currentGroupDocs[currentIndex - 1];
                          final prevData = prevDoc.data() as Map<String, dynamic>;
                          setState(() {
                            _selectedDoc = prevDoc;
                            _selectedLesson = prevData;
                            _isUserSelected = true;
                          });
                          final title = prevData['lessonTitle'] ?? '';
                          _checkBookmarkStatus(title);
                          _recordLessonHistory(
                            title,
                            prevData['sectionType'] == "History Section" ? "${widget.techName} History" : (prevData['moduleTitle'] ?? ''),
                            prevData['sectionType'] ?? 'Module Section',
                          );
                        },
                      )
                          : const SizedBox(width: 48),

                      Expanded(
                        child: Center(
                          child: Text(
                            _selectedLesson!['lessonTitle'] ?? '',
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),

                      showNext
                          ? IconButton(
                        icon: Icon(Icons.arrow_forward_ios, size: 20, color: isDarkMode ? Colors.white : Colors.black),
                        onPressed: () {
                          final nextDoc = currentGroupDocs[currentIndex + 1];
                          final nextData = nextDoc.data() as Map<String, dynamic>;
                          setState(() {
                            _selectedDoc = nextDoc;
                            _selectedLesson = nextData;
                            _isUserSelected = true;
                          });
                          final title = nextData['lessonTitle'] ?? '';
                          _checkBookmarkStatus(title);
                          _recordLessonHistory(
                            title,
                            nextData['sectionType'] == "History Section" ? "${widget.techName} History" : (nextData['moduleTitle'] ?? ''),
                            nextData['sectionType'] ?? 'Module Section',
                          );
                        },
                      )
                          : const SizedBox(width: 48),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Uniform Header Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade400,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _selectedLesson!['sectionType'] == "History Section"
                            ? "${widget.techName} History"
                            : (_selectedLesson!['moduleTitle'] ?? ''),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        "Learn and explore core concepts in detail.",
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Card View with Icon, Divider Line, and Definition Content
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            _getHistoryIcon(_selectedLesson!['lessonTitle'] ?? ''),
                            color: Colors.blue,
                            size: 24,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              _selectedLesson!['lessonTitle'] ?? '',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black),
                            ),
                          ),
                        ],
                      ),
                      Divider(height: 24, thickness: 1, color: isDarkMode ? Colors.grey.shade800 : Colors.grey),
                      Text(
                        _selectedLesson!['definition'] ?? 'No content provided.',
                        style: TextStyle(fontSize: 14, height: 1.5, color: isDarkMode ? Colors.white70 : Colors.black87),
                      ),
                    ],
                  ),
                ),

                // Code Snippet Section
                if (_selectedLesson!['codeSnippet'] != null &&
                    _selectedLesson!['codeSnippet'].toString().isNotEmpty) ...[
                  const SizedBox(height: 20),
                  Text("Code", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black)),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade900,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      _selectedLesson!['codeSnippet'],
                      style: const TextStyle(fontFamily: 'monospace', color: Colors.greenAccent, fontSize: 13),
                    ),
                  ),
                ],

                // Notes Section
                if (_selectedLesson!['notes'] != null &&
                    _selectedLesson!['notes'].toString().isNotEmpty) ...[
                  const SizedBox(height: 20),
                  Text("Notes", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black)),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300),
                    ),
                    child: Text(
                      _selectedLesson!['notes'],
                      style: TextStyle(fontSize: 14, height: 1.4, color: isDarkMode ? Colors.white70 : Colors.black87),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}