import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../data/lessons/sm/go_lessons.dart';
import '../../models/module.dart';
import '../../data/modules/sm/go_modules.dart';
import '../../history/sm/go/go_history_modules.dart';
import '../../history/sm/go/go_history_lessons.dart';

import 'package:techtionary/widgets/history_header.dart';
import '../../services/bookmark_service.dart';
import '../../widgets/lesson_code.dart';

import '../../widgets/quiz_widget.dart';
import '../../widgets/lesson_card.dart';

// QUIZZES
import '../../quizzes/sm/go/go_module1_quiz.dart';
import '../../quizzes/sm/go/go_module2_quiz.dart';
import '../../quizzes/sm/go/go_module3_quiz.dart';
import '../../quizzes/sm/go/go_module4_quiz.dart';
import '../../quizzes/sm/go/go_module5_quiz.dart';
import '../../quizzes/sm/go/go_module6_quiz.dart';
import '../../quizzes/sm/go/go_module7_quiz.dart';
import '../../quizzes/sm/go/go_module8_quiz.dart';
import '../../quizzes/sm/go/go_module9_quiz.dart';
import '../../quizzes/sm/go/go_module10_quiz.dart';
import '../../quizzes/sm/go/go_final_quiz.dart';

class GoPage extends StatefulWidget {
  final String? initialTopic;

  const GoPage({
    super.key,
    this.initialTopic,
  });

  @override
  State<GoPage> createState() => _GoPageState();
}

class _GoPageState extends State<GoPage> {
  String currentTopic = "Go Introduction";
  bool showMenu = false;
  static const String techName = "Go";

  bool get isHistoryLesson {
    return goHistoryModules.any(
          (module) => module.lessons.contains(currentTopic),
    );
  }

  Module? get currentModule {
    final allModules = [
      ...goModules,
      ...goHistoryModules,
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
      final moduleTitle = module?.title ?? "Go Lessons";

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
        if (currentTopic.contains("Module 1") && goModules.isNotEmpty) {
          currentTopic = goModules[0].lessons.first;
        } else if (currentTopic.contains("Module 2") && goModules.length > 1) {
          currentTopic = goModules[1].lessons.first;
        } else if (currentTopic.contains("Module 3") && goModules.length > 2) {
          currentTopic = goModules[2].lessons.first;
        } else if (currentTopic.contains("Module 4") && goModules.length > 3) {
          currentTopic = goModules[3].lessons.first;
        } else if (currentTopic.contains("Module 5") && goModules.length > 4) {
          currentTopic = goModules[4].lessons.first;
        } else if (currentTopic.contains("Module 6") && goModules.length > 5) {
          currentTopic = goModules[5].lessons.first;
        } else if (currentTopic.contains("Module 7") && goModules.length > 6) {
          currentTopic = goModules[6].lessons.first;
        } else if (currentTopic.contains("Module 8") && goModules.length > 7) {
          currentTopic = goModules[7].lessons.first;
        } else if (currentTopic.contains("Module 9") && goModules.length > 8) {
          currentTopic = goModules[8].lessons.first;
        } else if (currentTopic.contains("Module 10") && goModules.length > 9) {
          currentTopic = goModules[9].lessons.first;
        } else {
          currentTopic = "Go Introduction";
        }
      }
    });
    _saveLessonHistory(currentTopic);
  }

  String _getHistoryTopicText(String topic) {
    switch (topic) {
      case "Release Date":
        return "November 10, 2009\n\nThe Go programming language, commonly called Golang, was officially announced by Google on November 10, 2009.";
      case "Creator":
        return "Robert Griesemer, Rob Pike, and Ken Thompson\n\nGo was designed by three experienced computer scientists at Google. Their goal was to create a language that combines the speed of C with the simplicity of modern programming languages.";
      case "Country of Origin":
        return "United States\n\nGo was developed at Google headquarters in Mountain View, California, USA.";
      case "Why It Was Created":
        return "Go was created to solve common software engineering problems such as slow compilation, complex dependency management, and poor support for concurrent programming. It emphasizes simplicity, speed, and reliability.";
      case "Brief History":
        return "Development of Go started in 2007 at Google. The language was publicly announced in 2009 and quickly gained popularity because of its clean syntax, fast compilation, built-in concurrency, and strong performance. Today, Go is widely used in cloud computing, backend services, networking, and DevOps tools.";
      case "Evolution Timeline":
        return "2007\nGo Development Begins\n│\n\n2009\nPublic Release\n│\n\n2012\nGo 1.0 Released\n│\n\n2018\nGo Modules Introduced\n│\n\n2022\nGo 1.18\nGenerics Added\n│\n\nToday\nGo 1.x";
      case "Major Milestones":
        return "• 2009 – Go was announced by Google.\n\n• 2012 – Go 1.0 established compatibility guarantees.\n\n• 2018 – Go Modules simplified dependency management.\n\n• 2022 – Generics were introduced in Go 1.18.\n\n• Today – Go is one of the leading languages for cloud-native applications and backend systems.";
      case "Famous Quote":
        return "\"Clear is better than clever.\"\n\n— Rob Pike";
      default:
        return "Learn how Go was created and evolved over time.";
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
        title: const Text("Go Tutorial"),
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
                          title: "Go History",
                          subtitle:
                          "Learn how Go was created and evolved over time.",
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
                          ...goHistoryModules.map((module) {
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

                          ...goModules.map((module) {
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
                                      "GO FINAL QUIZ",
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
                                                courseTitle: "Go",
                                                moduleTitle: "Final Quiz",
                                                questions: goFinalQuizQuestions,
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
      final lesson = goLessons.firstWhere(
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
      return getGoHistoryContent(currentTopic, context);
    }

    final quizWidgets = {
      "Module 1 Quiz": (VoidCallback onBack) => GoModule1Quiz(onBackToModules: onBack),
      "Module 2 Quiz": (VoidCallback onBack) => GoModule2Quiz(onBackToModules: onBack),
      "Module 3 Quiz": (VoidCallback onBack) => GoModule3Quiz(onBackToModules: onBack),
      "Module 4 Quiz": (VoidCallback onBack) => GoModule4Quiz(onBackToModules: onBack),
      "Module 5 Quiz": (VoidCallback onBack) => GoModule5Quiz(onBackToModules: onBack),
      "Module 6 Quiz": (VoidCallback onBack) => GoModule6Quiz(onBackToModules: onBack),
      "Module 7 Quiz": (VoidCallback onBack) => GoModule7Quiz(onBackToModules: onBack),
      "Module 8 Quiz": (VoidCallback onBack) => GoModule8Quiz(onBackToModules: onBack),
      "Module 9 Quiz": (VoidCallback onBack) => GoModule9Quiz(onBackToModules: onBack),
      "Module 10 Quiz": (VoidCallback onBack) => GoModule10Quiz(onBackToModules: onBack),
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
            language: "go",
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