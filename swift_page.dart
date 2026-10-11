import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../data/lessons/sm/swift_lessons.dart';
import '../../models/module.dart';
import '../../data/modules/sm/swift_modules.dart';
import '../../history/sm/swift/swift_history_modules.dart';
import '../../history/sm/swift/swift_history_lessons.dart';

import 'package:techtionary/widgets/history_header.dart';
import '../../services/bookmark_service.dart';
import '../../widgets/lesson_code.dart';
import '../../widgets/lesson_card.dart';
import '../../widgets/quiz_widget.dart';

// QUIZZES (10 MODULES)
import '../../quizzes/sm/swift/swift_module1_quiz.dart';
import '../../quizzes/sm/swift/swift_module2_quiz.dart';
import '../../quizzes/sm/swift/swift_module3_quiz.dart';
import '../../quizzes/sm/swift/swift_module4_quiz.dart';
import '../../quizzes/sm/swift/swift_module5_quiz.dart';
import '../../quizzes/sm/swift/swift_module6_quiz.dart';
import '../../quizzes/sm/swift/swift_module7_quiz.dart';
import '../../quizzes/sm/swift/swift_module8_quiz.dart';
import '../../quizzes/sm/swift/swift_module9_quiz.dart';
import '../../quizzes/sm/swift/swift_final_quiz.dart';

class SwiftPage extends StatefulWidget {
  final String? initialTopic;

  const SwiftPage({super.key, this.initialTopic});

  @override
  State<SwiftPage> createState() => _SwiftPageState();
}

class _SwiftPageState extends State<SwiftPage> {
  String currentTopic = "Swift Introduction";
  bool showMenu = false;
  static const String techName = "Swift";

  bool get isHistoryLesson {
    return swiftHistoryModules.any(
          (module) => module.lessons.contains(currentTopic),
    );
  }

  Module? get currentModule {
    final allModules = [
      ...swiftModules,
      ...swiftHistoryModules,
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
      final moduleTitle = module?.title ?? "Swift Lessons";

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
        if (currentTopic.contains("Module 1") && swiftModules.isNotEmpty) {
          currentTopic = swiftModules[0].lessons.first;
        } else if (currentTopic.contains("Module 2") && swiftModules.length > 1) {
          currentTopic = swiftModules[1].lessons.first;
        } else if (currentTopic.contains("Module 3") && swiftModules.length > 2) {
          currentTopic = swiftModules[2].lessons.first;
        } else if (currentTopic.contains("Module 4") && swiftModules.length > 3) {
          currentTopic = swiftModules[3].lessons.first;
        } else if (currentTopic.contains("Module 5") && swiftModules.length > 4) {
          currentTopic = swiftModules[4].lessons.first;
        } else if (currentTopic.contains("Module 6") && swiftModules.length > 5) {
          currentTopic = swiftModules[5].lessons.first;
        } else if (currentTopic.contains("Module 7") && swiftModules.length > 6) {
          currentTopic = swiftModules[6].lessons.first;
        } else if (currentTopic.contains("Module 8") && swiftModules.length > 7) {
          currentTopic = swiftModules[7].lessons.first;
        } else if (currentTopic.contains("Module 9") && swiftModules.length > 8) {
          currentTopic = swiftModules[8].lessons.first;
        } else if (currentTopic.contains("Module 10") && swiftModules.length > 9) {
          currentTopic = swiftModules[9].lessons.first;
        } else {
          currentTopic = "Swift Introduction";
        }
      }
    });
    _saveLessonHistory(currentTopic);
  }

  String _getHistoryTopicText(String topic) {
    switch (topic) {
      case "Release Date":
        return "June 2, 2014\n\nSwift was officially introduced by Apple during the Worldwide Developers Conference (WWDC) on June 2, 2014.";
      case "Creator":
        return "Chris Lattner\n\nSwift was created by Chris Lattner with contributions from many Apple engineers to replace Objective-C with a safer and more modern programming language.";
      case "Country of Origin":
        return "United States\n\nSwift was developed by Apple Inc. in Cupertino, California, USA.";
      case "Why It Was Created":
        return "Swift was created to provide a fast, safe, and modern programming language for developing applications on Apple's platforms including iOS, macOS, watchOS, and tvOS.";
      case "Brief History":
        return "Development of Swift began in 2010 under Chris Lattner. Apple officially announced Swift in 2014 as the successor to Objective-C. In 2015, Swift became open source, allowing developers around the world to contribute to its growth. Today, Swift is the primary language for Apple application development.";
      case "Evolution Timeline":
        return "2010\nSwift Development Began\n│\n\n2014\nSwift Announced at WWDC\n│\n\n2015\nSwift Open Source\n│\n\n2019\nSwiftUI Introduced\n│\n\n2021+\nContinuous Language Improvements\n│\n\nToday\nSwift 6.x";
      case "Major Milestones":
        return "• 2014 – Swift officially introduced.\n\n• 2015 – Swift became open source.\n\n• Swift replaced Objective-C as Apple's primary programming language.\n\n• 2019 – SwiftUI simplified app development.\n\n• Today – Swift powers millions of iOS, macOS, watchOS, and tvOS applications.";
      case "Famous Quote":
        return "\"Swift is a powerful and intuitive programming language for Apple platforms.\"\n\n— Apple";
      default:
        return "Learn how Swift was created and evolved over time.";
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
        title: const Text("Swift Tutorial"),
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
                          title: "Swift History",
                          subtitle:
                          "Learn how Swift was created and evolved over time.",
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
                          ...swiftHistoryModules.map((module) {
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

                          ...swiftModules.map((module) {
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
                                      "SWIFT FINAL QUIZ",
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
                                                courseTitle: "Swift",
                                                moduleTitle: "Final Quiz",
                                                questions:
                                                swiftFinalQuizQuestions,
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
      final lesson = swiftLessons.firstWhere(
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
      return getSwiftHistoryContent(currentTopic, context);
    }

    final quizWidgets = {
      "Module 1 Quiz": (VoidCallback onBack) => SwiftModule1Quiz(onBackToModules: onBack),
      "Module 2 Quiz": (VoidCallback onBack) => SwiftModule2Quiz(onBackToModules: onBack),
      "Module 3 Quiz": (VoidCallback onBack) => SwiftModule3Quiz(onBackToModules: onBack),
      "Module 4 Quiz": (VoidCallback onBack) => SwiftModule4Quiz(onBackToModules: onBack),
      "Module 5 Quiz": (VoidCallback onBack) => SwiftModule5Quiz(onBackToModules: onBack),
      "Module 6 Quiz": (VoidCallback onBack) => SwiftModule6Quiz(onBackToModules: onBack),
      "Module 7 Quiz": (VoidCallback onBack) => SwiftModule7Quiz(onBackToModules: onBack),
      "Module 8 Quiz": (VoidCallback onBack) => SwiftModule8Quiz(onBackToModules: onBack),
      "Module 9 Quiz": (VoidCallback onBack) => SwiftModule9Quiz(onBackToModules: onBack),
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
            language: "swift",
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