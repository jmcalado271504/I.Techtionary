import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../models/module.dart';
import '../../data/lessons/sm/cpp_lessons.dart';
import '../../data/modules/sm/cpp_modules.dart';
import '../../history/sm/cpp/cpp_history_modules.dart';
import '../../history/sm/cpp/cpp_history_lessons.dart';

import 'package:techtionary/widgets/history_header.dart';
import '../../quizzes/sm/cpp/cpp_module1_quiz.dart';
import '../../quizzes/sm/cpp/cpp_module2_quiz.dart';
import '../../quizzes/sm/cpp/cpp_module3_quiz.dart';
import '../../quizzes/sm/cpp/cpp_module4_quiz.dart';
import '../../quizzes/sm/cpp/cpp_module5_quiz.dart';
import '../../quizzes/sm/cpp/cpp_module6_quiz.dart';
import '../../quizzes/sm/cpp/cpp_module7_quiz.dart';
import '../../quizzes/sm/cpp/cpp_module8_quiz.dart';
import '../../quizzes/sm/cpp/cpp_module9_quiz.dart';
import '../../quizzes/sm/cpp/cpp_module10_quiz.dart';
import '../../quizzes/sm/cpp/cpp_final_quiz.dart';

import '../../widgets/quiz_widget.dart';
import '../../widgets/lesson_code.dart';
import '../../widgets/lesson_card.dart';

import '../../services/bookmark_service.dart';

class CppPage extends StatefulWidget {
  final String? initialTopic;

  const CppPage({super.key, this.initialTopic});

  @override
  State<CppPage> createState() => _CppPageState();
}

class _CppPageState extends State<CppPage> {
  String currentTopic = "Cpp Introduction";
  bool showMenu = false;
  static const String techName = "Cpp";

  bool get isHistoryLesson {
    return cppHistoryModules.any(
          (module) => module.lessons.contains(currentTopic),
    );
  }

  Module? get currentModule {
    final allModules = [
      ...cppModules,
      ...cppHistoryModules,
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
      final moduleTitle = module?.title ?? "C++ Lessons";

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
        if (currentTopic.contains("Module 1") && cppModules.isNotEmpty) {
          currentTopic = cppModules[0].lessons.first;
        } else if (currentTopic.contains("Module 2") && cppModules.length > 1) {
          currentTopic = cppModules[1].lessons.first;
        } else if (currentTopic.contains("Module 3") && cppModules.length > 2) {
          currentTopic = cppModules[2].lessons.first;
        } else if (currentTopic.contains("Module 4") && cppModules.length > 3) {
          currentTopic = cppModules[3].lessons.first;
        } else if (currentTopic.contains("Module 5") && cppModules.length > 4) {
          currentTopic = cppModules[4].lessons.first;
        } else if (currentTopic.contains("Module 6") && cppModules.length > 5) {
          currentTopic = cppModules[5].lessons.first;
        } else if (currentTopic.contains("Module 7") && cppModules.length > 6) {
          currentTopic = cppModules[6].lessons.first;
        } else if (currentTopic.contains("Module 8") && cppModules.length > 7) {
          currentTopic = cppModules[7].lessons.first;
        } else if (currentTopic.contains("Module 9") && cppModules.length > 8) {
          currentTopic = cppModules[8].lessons.first;
        } else if (currentTopic.contains("Module 10") && cppModules.length > 9) {
          currentTopic = cppModules[9].lessons.first;
        } else {
          currentTopic = "Cpp Introduction";
        }
      }
    });
    _saveLessonHistory(currentTopic);
  }

  String _getHistoryTopicText(String topic) {
    switch (topic) {
      case "Release Date":
        return "1985\n\nC++ was officially released in 1985 after several years of development at Bell Laboratories.";
      case "Creator":
        return "Bjarne Stroustrup\n\nBjarne Stroustrup created C++ while working at Bell Laboratories. His goal was to improve the C programming language by adding object-oriented programming features without sacrificing performance.";
      case "Country of Origin":
        return "United States\n\nC++ was developed at Bell Laboratories in New Jersey, United States.";
      case "Why It Was Created":
        return "C++ was created to combine the speed and efficiency of C with object-oriented programming, making it easier to build large, complex, and reusable software systems.";
      case "Brief History":
        return "Originally called 'C with Classes,' C++ was developed by Bjarne Stroustrup beginning in 1979. The language added classes, inheritance, polymorphism, and many other object-oriented features to C. It was renamed C++ in 1983, where '++' refers to the increment operator in C, symbolizing an improved version of C. Today, C++ is widely used in operating systems, game engines, embedded systems, high-performance applications, and financial software.";
      case "Evolution Timeline":
        return "1979\nC with Classes Started\n│\n\n1983\nRenamed to C++\n│\n\n1985\nFirst Commercial Release\n│\n\n1998\nISO C++98 Standard\n│\n\n2011\nModern C++11 Released\n│\n\nToday\nC++23 Standard";
      case "Major Milestones":
        return "• 1979 – Development of C with Classes began.\n\n• 1983 – Language renamed to C++.\n\n• 1985 – First official release of C++.\n\n• 1998 – First ISO C++ standard published.\n\n• Today – C++ powers game engines, operating systems, browsers, embedded devices, and high-performance software.";
      case "Famous Quote":
        return "\"There are only two kinds of languages: the ones people complain about and the ones nobody uses.\"\n\n— Bjarne Stroustrup";
      default:
        return "Learn how Cpp was created and evolved over time.";
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
        title: const Text("CPP Tutorial"),
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
                          title: "Cpp History",
                          subtitle:
                          "Learn how Cpp was created and evolved over time.",
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
                          ...cppHistoryModules.map((module) {
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

                          ...cppModules.map((module) {
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
                                      "CPP FINAL QUIZ",
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
                                                courseTitle: "C++ Programming",
                                                moduleTitle: "Final Quiz",
                                                questions:
                                                cppFinalQuizQuestions,
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
      final lesson = cppLessons.firstWhere(
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
      return getCppHistoryContent(currentTopic, context);
    }

    final quizWidgets = {
      "Module 1 Quiz": (VoidCallback onBack) => CppModule1Quiz(onBackToModules: onBack),
      "Module 2 Quiz": (VoidCallback onBack) => CppModule2Quiz(onBackToModules: onBack),
      "Module 3 Quiz": (VoidCallback onBack) => CppModule3Quiz(onBackToModules: onBack),
      "Module 4 Quiz": (VoidCallback onBack) => CppModule4Quiz(onBackToModules: onBack),
      "Module 5 Quiz": (VoidCallback onBack) => CppModule5Quiz(onBackToModules: onBack),
      "Module 6 Quiz": (VoidCallback onBack) => CppModule6Quiz(onBackToModules: onBack),
      "Module 7 Quiz": (VoidCallback onBack) => CppModule7Quiz(onBackToModules: onBack),
      "Module 8 Quiz": (VoidCallback onBack) => CppModule8Quiz(onBackToModules: onBack),
      "Module 9 Quiz": (VoidCallback onBack) => CppModule9Quiz(onBackToModules: onBack),
      "Module 10 Quiz": (VoidCallback onBack) => CppModule10Quiz(onBackToModules: onBack),
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