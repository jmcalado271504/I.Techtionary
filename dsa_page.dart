import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../data/lessons/sm/dsa_lessons.dart';
import '../../models/module.dart';
import '../../data/modules/sm/dsa_modules.dart';
import '../../history/sm/dsa/dsa_history_modules.dart';
import '../../history/sm/dsa/dsa_history_lessons.dart';

import 'package:techtionary/widgets/history_header.dart';
import '../../services/bookmark_service.dart';
import '../../widgets/lesson_code.dart';

import '../../widgets/quiz_widget.dart';
import '../../widgets/lesson_card.dart';

import '../../quizzes/sm/dsa/dsa_module1_quiz.dart';
import '../../quizzes/sm/dsa/dsa_module2_quiz.dart';
import '../../quizzes/sm/dsa/dsa_module3_quiz.dart';
import '../../quizzes/sm/dsa/dsa_module4_quiz.dart';
import '../../quizzes/sm/dsa/dsa_module5_quiz.dart';
import '../../quizzes/sm/dsa/dsa_module6_quiz.dart';
import '../../quizzes/sm/dsa/dsa_module7_quiz.dart';
import '../../quizzes/sm/dsa/dsa_module8_quiz.dart';
import '../../quizzes/sm/dsa/dsa_module9_quiz.dart';
import '../../quizzes/sm/dsa/dsa_module10_quiz.dart';
import '../../quizzes/sm/dsa/dsa_module11_quiz.dart';
import '../../quizzes/sm/dsa/dsa_final_quiz.dart';

class DsaPage extends StatefulWidget {
  final String? initialTopic;

  const DsaPage({
    super.key,
    this.initialTopic,
  });

  @override
  State<DsaPage> createState() => _DsaPageState();
}

class _DsaPageState extends State<DsaPage> {
  String currentTopic = "DSA Introduction";
  bool showMenu = false;
  static const String techName = "DSA";

  bool get isHistoryLesson {
    return dsaHistoryModules.any(
          (module) => module.lessons.contains(currentTopic),
    );
  }

  Module? get currentModule {
    final allModules = [
      ...dsaModules,
      ...dsaHistoryModules,
    ];

    for (final module in allModules) {
      if (module.lessons.contains(currentTopic)) {
        return module;
      }
    }

    return null;
  }

  @override
  void initState() {
    super.initState();

    if (widget.initialTopic != null) {
      currentTopic = widget.initialTopic!;
    }

    _saveLessonHistory(currentTopic);
  }

  void _saveLessonHistory(String topic) async {
    if (topic.contains("Quiz")) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final module = currentModule;
      final moduleTitle = module?.title ?? "DSA Lessons";

      final String cleanTopic = topic.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_');
      final docId = "${user.uid}_${techName}_$cleanTopic";

      await FirebaseFirestore.instance
          .collection('lesson_history')
          .doc(docId)
          .set({
        'userId': user.uid,
        'techName': techName,
        'moduleTitle': moduleTitle,
        'lessonTitle': topic,
        'visitedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }
  }

  void _backToModules() {
    setState(() {
      final module = currentModule;

      if (module != null && module.lessons.isNotEmpty) {
        currentTopic = module.lessons.first;
      } else {
        if (currentTopic.contains("Module 1") && dsaModules.isNotEmpty) {
          currentTopic = dsaModules[0].lessons.first;
        } else if (currentTopic.contains("Module 2") && dsaModules.length > 1) {
          currentTopic = dsaModules[1].lessons.first;
        } else if (currentTopic.contains("Module 3") && dsaModules.length > 2) {
          currentTopic = dsaModules[2].lessons.first;
        } else if (currentTopic.contains("Module 4") && dsaModules.length > 3) {
          currentTopic = dsaModules[3].lessons.first;
        } else if (currentTopic.contains("Module 5") && dsaModules.length > 4) {
          currentTopic = dsaModules[4].lessons.first;
        } else if (currentTopic.contains("Module 6") && dsaModules.length > 5) {
          currentTopic = dsaModules[5].lessons.first;
        } else if (currentTopic.contains("Module 7") && dsaModules.length > 6) {
          currentTopic = dsaModules[6].lessons.first;
        } else if (currentTopic.contains("Module 8") && dsaModules.length > 7) {
          currentTopic = dsaModules[7].lessons.first;
        } else if (currentTopic.contains("Module 9") && dsaModules.length > 8) {
          currentTopic = dsaModules[8].lessons.first;
        } else if (currentTopic.contains("Module 10") && dsaModules.length > 9) {
          currentTopic = dsaModules[9].lessons.first;
        } else if (currentTopic.contains("Module 11") && dsaModules.length > 10) {
          currentTopic = dsaModules[10].lessons.first;
        } else {
          currentTopic = "DSA Introduction";
        }
      }
    });
    _saveLessonHistory(currentTopic);
  }

  String _getHistoryTopicText(String topic) {
    switch (topic) {
      case "Release Date":
        return "1960s–1970s\n\nData Structures and Algorithms (DSA) emerged as a formal field of Computer Science during the 1960s and 1970s, alongside the development of modern programming languages and operating systems.";
      case "Creator":
        return "Multiple Computer Scientists\n\nDSA was not created by a single individual. It evolved through the work of many pioneers such as Donald Knuth, Edsger W. Dijkstra, Robert Tarjan, Tony Hoare, and others who developed fundamental algorithms and data structures.";
      case "Country of Origin":
        return "United States & Europe\n\nThe foundations of DSA were developed by researchers and universities in the United States and several European countries through academic research in computer science.";
      case "Why It Was Created":
        return "Data Structures and Algorithms were developed to solve computational problems efficiently. They help organize data, reduce execution time, minimize memory usage, and improve the performance of software applications.";
      case "Brief History":
        return "As computers became more powerful, programmers needed efficient ways to store and process data. Researchers developed algorithms for searching, sorting, graph processing, and optimization while introducing data structures such as arrays, linked lists, trees, graphs, stacks, and queues. Today, DSA forms the foundation of software engineering, artificial intelligence, databases, operating systems, and competitive programming.";
      case "Evolution Timeline":
        return "1950s\nEarly Sorting Algorithms\n│\n\n1960s\nData Structures Formalized\n│\n\n1973\nKnuth's 'The Art of Computer Programming'\n│\n\n1980s\nAdvanced Graph Algorithms\n│\n\n2000s\nCompetitive Programming Growth\n│\n\nToday\nFoundation of Modern Software Development";
      case "Major Milestones":
        return "• 1960s – Fundamental data structures became widely studied.\n\n• 1973 – Donald Knuth published major works on algorithms.\n\n• 1980s – Efficient graph and tree algorithms were developed.\n\n• 2000s – DSA became central to coding interviews and competitive programming.\n\n• Today – DSA is essential for software engineering, AI, cybersecurity, databases, and cloud computing.";
      case "Famous Quote":
        return "\"Premature optimization is the root of all evil.\"\n\n— Donald Knuth";
      default:
        return "Learn how DSA was created and evolved over time.";
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.sizeOf(context);

    final isQuiz = currentTopic.contains("Quiz");

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu_book),
          onPressed: () {
            setState(() {
              showMenu = !showMenu;
            });
          },
        ),
        automaticallyImplyLeading: false,
        title: const Text("DSA Tutorial"),
        centerTitle: true,
        actions: [
          if (!isQuiz)
            Builder(
              builder: (context) {
                final String bookmarkKey = "${techName}_$currentTopic";

                return FutureBuilder<bool>(
                  future: BookmarkService.isBookmarked(bookmarkKey),
                  builder: (context, snapshot) {
                    final bookmarked = snapshot.data ?? false;

                    return IconButton(
                      icon: Icon(
                        bookmarked ? Icons.bookmark : Icons.bookmark_border,
                      ),
                      onPressed: () async {
                        final topic = currentTopic;
                        String content = "";

                        if (isHistoryLesson) {
                          content = _getHistoryTopicText(topic);
                        } else {
                          final data = getTopicData(topic);
                          content = '''
${data["description"] ?? ""}

---------------- CODE ----------------

${data["code"] ?? ""}

---------------- NOTES ----------------

${data["extra"] ?? ""}
''';
                        }

                        if (bookmarked) {
                          await BookmarkService.removeBookmark(bookmarkKey);

                          if (mounted) {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                title: const Row(
                                  children: [
                                    Icon(Icons.info_outline, color: Colors.orange),
                                    SizedBox(width: 8),
                                    Text(
                                      "Bookmark",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                content: const Text("Bookmark removed successfully."),
                                actions: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text("OK"),
                                  ),
                                ],
                              ),
                            );
                          }
                        } else {
                          await BookmarkService.addBookmark(bookmarkKey, content);

                          if (mounted) {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                title: const Row(
                                  children: [
                                    Icon(Icons.check_circle, color: Colors.green),
                                    SizedBox(width: 8),
                                    Text(
                                      "Success",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                content: const Text("Bookmark added successfully!"),
                                actions: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text("OK"),
                                  ),
                                ],
                              ),
                            );
                          }
                        }

                        if (mounted) {
                          setState(() {});
                        }
                      },
                    );
                  },
                );
              },
            ),
        ],
      ),

      body: Stack(
        children: [
          Column(
            children: [
              if (!currentTopic.contains("Quiz"))
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Builder(
                    builder: (context) {
                      final module = currentModule;
                      final index = module?.lessons.indexOf(currentTopic) ?? -1;

                      final showPrevious = module != null && index > 0;
                      final showNext = module != null &&
                          index >= 0 &&
                          index < module.lessons.length - 1;

                      return Row(
                        children: [
                          if (showPrevious)
                            IconButton(
                              icon: const Icon(Icons.arrow_back_ios_new),
                              onPressed: () {
                                final nextTopic = module.lessons[index - 1];
                                setState(() {
                                  currentTopic = nextTopic;
                                });
                                _saveLessonHistory(nextTopic);
                              },
                            )
                          else
                            const SizedBox(width: 48),

                          Expanded(
                            child: Center(
                              child: Text(
                                currentTopic,
                                style: const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),

                          if (showNext)
                            IconButton(
                              icon: const Icon(Icons.arrow_forward_ios),
                              onPressed: () {
                                final nextTopic = module.lessons[index + 1];
                                setState(() {
                                  currentTopic = nextTopic;
                                });
                                _saveLessonHistory(nextTopic);
                              },
                            )
                          else
                            const SizedBox(width: 48),
                        ],
                      );
                    },
                  ),
                ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      if (isHistoryLesson) ...[
                        const HistoryHeader(
                          title: "DSA History",
                          subtitle:
                          "Learn how DSA was created and evolved over time.",
                          icon: Icons.palette,
                        ),
                        const SizedBox(height: 20),
                      ],

                      Expanded(
                        child: getTopicContent(context),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          if (showMenu)
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    showMenu = false;
                  });
                },
                child: Container(
                  color: Colors.black.withOpacity(0.3),
                ),
              ),
            ),

          if (showMenu)
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              width: mediaQuery.width * 0.55,
              child: Material(
                elevation: 16,
                color: theme.scaffoldBackgroundColor,
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          ...dsaHistoryModules.map((module) {
                            return ExpansionTile(
                              title: Text(
                                module.title,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              children: module.lessons.map((lesson) {
                                final isSelected = lesson == currentTopic;

                                return ListTile(
                                  dense: true,
                                  title: Text(
                                    lesson,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: isSelected
                                          ? theme.colorScheme.primary
                                          : theme.colorScheme.onSurface,
                                    ),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      currentTopic = lesson;
                                      showMenu = false;
                                    });
                                    _saveLessonHistory(lesson);
                                  },
                                );
                              }).toList(),
                            );
                          }),

                          ...dsaModules.map((module) {
                            return ExpansionTile(
                              title: Text(
                                module.title,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              children: module.lessons.map((lesson) {
                                final isSelected = lesson == currentTopic;

                                return ListTile(
                                  dense: true,
                                  title: Text(
                                    lesson,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: isSelected
                                          ? theme.colorScheme.primary
                                          : theme.colorScheme.onSurface,
                                    ),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      currentTopic = lesson;
                                      showMenu = false;
                                    });
                                    _saveLessonHistory(lesson);
                                  },
                                );
                              }).toList(),
                            );
                          }),

                          const Divider(),
                          const SizedBox(height: 10),

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  children: [
                                    const Icon(
                                      Icons.workspace_premium,
                                      size: 36,
                                      color: Colors.amber,
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      "DSA FINAL QUIZ",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 12),
                                    SizedBox(
                                      width: double.infinity,
                                      height: 40,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            showMenu = false;
                                          });
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => QuizWidget(
                                                courseTitle: "DSA",
                                                moduleTitle: "Final Quiz",
                                                questions:
                                                dsaFinalQuizQuestions,
                                                onBackToModules: () {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ),
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
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Map<String, dynamic> getTopicData(String topic) {
    try {
      final lesson = dsaLessons.firstWhere(
            (lesson) => lesson.title == topic,
      );

      return {
        "description": lesson.description,
        "code": lesson.code,
        "previewCode": lesson.previewCode ?? lesson.code,
        "extra": lesson.notes,
      };
    } catch (e) {
      return {
        "description": "Lesson not found.",
        "code": "",
        "previewCode": "",
        "extra": "",
      };
    }
  }

  Widget getTopicContent(BuildContext context) {
    if (isHistoryLesson) {
      return getDsaHistoryContent(currentTopic, context);
    }

    final quizWidgets = {
      "Module 1 Quiz": (VoidCallback onBack) => DsaModule1Quiz(onBackToModules: onBack),
      "Module 2 Quiz": (VoidCallback onBack) => DsaModule2Quiz(onBackToModules: onBack),
      "Module 3 Quiz": (VoidCallback onBack) => DsaModule3Quiz(onBackToModules: onBack),
      "Module 4 Quiz": (VoidCallback onBack) => DsaModule4Quiz(onBackToModules: onBack),
      "Module 5 Quiz": (VoidCallback onBack) => DsaModule5Quiz(onBackToModules: onBack),
      "Module 6 Quiz": (VoidCallback onBack) => DsaModule6Quiz(onBackToModules: onBack),
      "Module 7 Quiz": (VoidCallback onBack) => DsaModule7Quiz(onBackToModules: onBack),
      "Module 8 Quiz": (VoidCallback onBack) => DsaModule8Quiz(onBackToModules: onBack),
      "Module 9 Quiz": (VoidCallback onBack) => DsaModule9Quiz(onBackToModules: onBack),
      "Module 10 Quiz": (VoidCallback onBack) => DsaModule10Quiz(onBackToModules: onBack),
      "Module 11 Quiz": (VoidCallback onBack) => DsaModule11Quiz(onBackToModules: onBack),
    };

    if (quizWidgets.containsKey(currentTopic)) {
      return quizWidgets[currentTopic]!(_backToModules);
    }

    final data = getTopicData(currentTopic);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LessonCard(
            title: "Definition",
            content: data["description"] ?? "",
          ),

          LessonCode(
            code: data["code"] ?? "",
            previewCode: data["previewCode"] ?? data["code"] ?? "",
            language: "cpp",
          ),

          LessonCard(
            title: "Notes",
            content: data["extra"] ?? "",
          ),
        ],
      ),
    );
  }
}