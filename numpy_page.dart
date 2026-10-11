import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../data/lessons/sm/numpy_lessons.dart';
import '../../models/module.dart';
import '../../data/modules/sm/numpy_modules.dart';
import '../../history/sm/numpy/numpy_history_modules.dart';
import '../../history/sm/numpy/numpy_history_lessons.dart';

import 'package:techtionary/widgets/history_header.dart';
import '../../services/bookmark_service.dart';
import '../../widgets/lesson_code.dart';
import '../../widgets/quiz_widget.dart';
import '../../widgets/lesson_card.dart';

// QUIZZES
import '../../quizzes/sm/numpy/numpy_module1_quiz.dart';
import '../../quizzes/sm/numpy/numpy_module2_quiz.dart';
import '../../quizzes/sm/numpy/numpy_module3_quiz.dart';
import '../../quizzes/sm/numpy/numpy_module4_quiz.dart';
import '../../quizzes/sm/numpy/numpy_module5_quiz.dart';
import '../../quizzes/sm/numpy/numpy_final_quiz.dart';

class NumpyPage extends StatefulWidget {
  final String? initialTopic;

  const NumpyPage({
    super.key,
    this.initialTopic,
  });

  @override
  State<NumpyPage> createState() => _NumpyPageState();
}

class _NumpyPageState extends State<NumpyPage> {
  String currentTopic = "NumPy Introduction";
  bool showMenu = false;
  static const String techName = "Numpy";

  bool get isHistoryLesson {
    return numpyHistoryModules.any(
          (module) => module.lessons.contains(currentTopic),
    );
  }

  Module? get currentModule {
    final allModules = [
      ...numpyModules,
      ...numpyHistoryModules,
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
      final moduleTitle = module?.title ?? "NumPy Lessons";

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
        if (currentTopic.contains("Module 1") && numpyModules.isNotEmpty) {
          currentTopic = numpyModules[0].lessons.first;
        } else if (currentTopic.contains("Module 2") && numpyModules.length > 1) {
          currentTopic = numpyModules[1].lessons.first;
        } else if (currentTopic.contains("Module 3") && numpyModules.length > 2) {
          currentTopic = numpyModules[2].lessons.first;
        } else if (currentTopic.contains("Module 4") && numpyModules.length > 3) {
          currentTopic = numpyModules[3].lessons.first;
        } else if (currentTopic.contains("Module 5") && numpyModules.length > 4) {
          currentTopic = numpyModules[4].lessons.first;
        } else {
          currentTopic = "NumPy Introduction";
        }
      }
    });
    _saveLessonHistory(currentTopic);
  }

  String _getHistoryTopicText(String topic) {
    switch (topic) {
      case "Release Date":
        return "2006\n\nNumPy version 1.0 was officially released in 2006, becoming the foundation of scientific computing in Python.";
      case "Creator":
        return "Travis Oliphant\n\nNumPy was created by Travis Oliphant by combining the ideas and capabilities of the earlier Numeric and Numarray libraries into a single, more powerful package.";
      case "Country of Origin":
        return "United States\n\nNumPy was primarily developed by Travis Oliphant and contributors in the United States as an open-source Python project.";
      case "Why It Was Created":
        return "NumPy was created to provide fast numerical computation, efficient multidimensional arrays, and mathematical functions for Python. It allows developers and researchers to process large amounts of numerical data efficiently.";
      case "Brief History":
        return "Before NumPy, Python relied on two separate numerical libraries: Numeric and Numarray. In 2006, Travis Oliphant merged the best features of both into NumPy, creating a standard library for numerical computing. Today, NumPy is the foundation of many scientific and machine learning libraries such as Pandas, SciPy, TensorFlow, and Scikit-learn.";
      case "Evolution Timeline":
        return "1995\nNumeric Library Created\n│\n\n2001\nNumarray Released\n│\n\n2006\nNumPy 1.0 Released\n│\n\n2010s\nFoundation of Data Science\n│\n\n2020s\nContinued Performance Improvements\n│\n\nToday\nNumPy 2.x";
      case "Major Milestones":
        return "• 2006 – NumPy 1.0 officially released.\n\n• Became the standard numerical computing library for Python.\n\n• Formed the foundation for Pandas, SciPy, Matplotlib, TensorFlow, and Scikit-learn.\n\n• 2024 – NumPy 2.0 introduced major modernization improvements.\n\n• Today – Used worldwide in AI, machine learning, engineering, finance, and scientific research.";
      case "Famous Quote":
        return "\"NumPy is the fundamental package for scientific computing with Python.\"\n\n— NumPy Documentation";
      default:
        return "Learn how NumPy was created and evolved over time.";
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
        title: const Text("NumPy Tutorial"),
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
                          title: "NumPy History",
                          subtitle:
                          "Learn how NumPy was created and evolved over time.",
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
                          ...numpyHistoryModules.map((module) {
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

                          ...numpyModules.map((module) {
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
                                      "NUMPY FINAL QUIZ",
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
                                                courseTitle: "NumPy",
                                                moduleTitle: "Final Quiz",
                                                questions:
                                                numpyFinalQuizQuestions,
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
      final lesson = numpyLessons.firstWhere(
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

  // ===========================================================================
  // TOPIC CONTENT ROUTING
  // ===========================================================================
  Widget getTopicContent(BuildContext context) {
    if (isHistoryLesson) {
      return getNumPyHistoryContent(currentTopic, context);
    }

    final quizWidgets = {
      "Module 1 Quiz": (VoidCallback onBack) => NumpyModule1Quiz(onBackToModules: onBack),
      "Module 2 Quiz": (VoidCallback onBack) => NumpyModule2Quiz(onBackToModules: onBack),
      "Module 3 Quiz": (VoidCallback onBack) => NumpyModule3Quiz(onBackToModules: onBack),
      "Module 4 Quiz": (VoidCallback onBack) => NumpyModule4Quiz(onBackToModules: onBack),
      "Module 5 Quiz": (VoidCallback onBack) => NumpyModule5Quiz(onBackToModules: onBack),
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
            language: "python",
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