import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../data/lessons/sm/bootstrap_lessons.dart';
import '../../models/module.dart';
import '../../data/modules/sm/bootstrap_modules.dart';
import '../../history/sm/bootstrap/bootstrap_history_modules.dart';
import '../../history/sm/bootstrap/bootstrap_history_lessons.dart';

import 'package:techtionary/widgets/history_header.dart';
import '../../services/bookmark_service.dart';
import '../../widgets/lesson_code.dart';
import '../../widgets/quiz_widget.dart';
import '../../widgets/lesson_card.dart';

// QUIZZES
import '../../quizzes/sm/bootstrap/bootstrap_module1_quiz.dart';
import '../../quizzes/sm/bootstrap/bootstrap_module2_quiz.dart';
import '../../quizzes/sm/bootstrap/bootstrap_module3_quiz.dart';
import '../../quizzes/sm/bootstrap/bootstrap_module4_quiz.dart';
import '../../quizzes/sm/bootstrap/bootstrap_module5_quiz.dart';
import '../../quizzes/sm/bootstrap/bootstrap_module6_quiz.dart';
import '../../quizzes/sm/bootstrap/bootstrap_module7_quiz.dart';
import '../../quizzes/sm/bootstrap/bootstrap_module8_quiz.dart';
import '../../quizzes/sm/bootstrap/bootstrap_module9_quiz.dart';
import '../../quizzes/sm/bootstrap/bootstrap_final_quiz.dart';

class BootstrapPage extends StatefulWidget {
  final String? initialTopic;

  const BootstrapPage({
    super.key,
    this.initialTopic,
  });

  @override
  State<BootstrapPage> createState() => _BootstrapPageState();
}

class _BootstrapPageState extends State<BootstrapPage> {
  String currentTopic = "Bootstrap Introduction";
  bool showMenu = false;
  static const String techName = "Bootstrap";

  bool get isHistoryLesson {
    return bootstrapHistoryModules.any(
          (module) => module.lessons.contains(currentTopic),
    );
  }

  Module? get currentModule {
    final allModules = [
      ...bootstrapModules,
      ...bootstrapHistoryModules,
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
      final moduleTitle = module?.title ?? "Bootstrap Lessons";

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
        if (currentTopic.contains("Module 1") && bootstrapModules.isNotEmpty) {
          currentTopic = bootstrapModules[0].lessons.first;
        } else if (currentTopic.contains("Module 2") && bootstrapModules.length > 1) {
          currentTopic = bootstrapModules[1].lessons.first;
        } else if (currentTopic.contains("Module 3") && bootstrapModules.length > 2) {
          currentTopic = bootstrapModules[2].lessons.first;
        } else if (currentTopic.contains("Module 4") && bootstrapModules.length > 3) {
          currentTopic = bootstrapModules[3].lessons.first;
        } else if (currentTopic.contains("Module 5") && bootstrapModules.length > 4) {
          currentTopic = bootstrapModules[4].lessons.first;
        } else if (currentTopic.contains("Module 6") && bootstrapModules.length > 5) {
          currentTopic = bootstrapModules[5].lessons.first;
        } else if (currentTopic.contains("Module 7") && bootstrapModules.length > 6) {
          currentTopic = bootstrapModules[6].lessons.first;
        } else if (currentTopic.contains("Module 8") && bootstrapModules.length > 7) {
          currentTopic = bootstrapModules[7].lessons.first;
        } else if (currentTopic.contains("Module 9") && bootstrapModules.length > 8) {
          currentTopic = bootstrapModules[8].lessons.first;
        } else {
          currentTopic = "Bootstrap Introduction";
        }
      }
    });
    _saveLessonHistory(currentTopic);
  }

  String _getHistoryTopicText(String topic) {
    switch (topic) {
      case "Release Date":
        return "August 19, 2011\n\nBootstrap was officially released on August 19, 2011 as an open-source front-end framework for building responsive websites.";
      case "Creator":
        return "Mark Otto and Jacob Thornton\n\nBootstrap was created by Mark Otto and Jacob Thornton while working at Twitter. It was originally called Twitter Blueprint before being released as Bootstrap.";
      case "Country of Origin":
        return "United States\n\nBootstrap was developed at Twitter in San Francisco, California, USA.";
      case "Why It Was Created":
        return "Bootstrap was created to provide developers with a consistent and efficient way to design responsive websites. It includes pre-built CSS, JavaScript components, and layout utilities that speed up web development.";
      case "Brief History":
        return "Bootstrap began as an internal framework at Twitter to standardize web development across projects. In 2011, it was released as open-source software and quickly became one of the world's most popular front-end frameworks. Today, Bootstrap continues to help developers build responsive and mobile-first websites efficiently.";
      case "Evolution Timeline":
        return "2011\nBootstrap 1.0\n│\n\n2012\nBootstrap 2\nResponsive Design\n│\n\n2013\nBootstrap 3\nMobile-First Framework\n│\n\n2018\nBootstrap 4\nFlexbox Support\n│\n\n2021\nBootstrap 5\nRemoved jQuery Dependency\n│\n\nToday\nBootstrap 5.x";
      case "Major Milestones":
        return "• 2011 – Bootstrap was released as an open-source framework.\n\n• 2012 – Bootstrap 2 introduced responsive layouts.\n\n• 2013 – Bootstrap 3 adopted a mobile-first approach.\n\n• 2018 – Bootstrap 4 introduced Flexbox and improved components.\n\n• 2021 – Bootstrap 5 removed the jQuery dependency and added modern utilities.";
      case "Famous Quote":
        return "\"Build fast, responsive sites with Bootstrap.\"\n\n— Bootstrap Team";
      default:
        return "Learn how Bootstrap was created and evolved over time.";
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
        title: const Text("Bootstrap Tutorial"),
        centerTitle: true,
        actions: [
          if (!isQuiz)
            Builder(
              builder: (context) {
                const String techName = "Bootstrap";
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
                          title: "Bootstrap History",
                          subtitle:
                          "Learn how Bootstrap was created and evolved over time.",
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
                          ...bootstrapHistoryModules.map((module) {
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

                          ...bootstrapModules.map((module) {
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
                                      "BOOTSTRAP FINAL QUIZ",
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
                                                courseTitle: "Bootstrap",
                                                moduleTitle: "Final Quiz",
                                                questions:
                                                bootstrapFinalQuizQuestions,
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

  Map<String, dynamic> getTopicData(
      String topic,
      ) {
    try {
      final lesson = bootstrapLessons.firstWhere(
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

  Widget getTopicContent(
      BuildContext context,
      ) {
    if (isHistoryLesson) {
      return getBootstrapHistoryContent(currentTopic, context);
    }

    final quizWidgets = {
      "Module 1 Quiz": (VoidCallback onBack) => BootstrapModule1Quiz(onBackToModules: onBack),
      "Module 2 Quiz": (VoidCallback onBack) => BootstrapModule2Quiz(onBackToModules: onBack),
      "Module 3 Quiz": (VoidCallback onBack) => BootstrapModule3Quiz(onBackToModules: onBack),
      "Module 4 Quiz": (VoidCallback onBack) => BootstrapModule4Quiz(onBackToModules: onBack),
      "Module 5 Quiz": (VoidCallback onBack) => BootstrapModule5Quiz(onBackToModules: onBack),
      "Module 6 Quiz": (VoidCallback onBack) => BootstrapModule6Quiz(onBackToModules: onBack),
      "Module 7 Quiz": (VoidCallback onBack) => BootstrapModule7Quiz(onBackToModules: onBack),
      "Module 8 Quiz": (VoidCallback onBack) => BootstrapModule8Quiz(onBackToModules: onBack),
      "Module 9 Quiz": (VoidCallback onBack) => BootstrapModule9Quiz(onBackToModules: onBack),
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
            language: "html",
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