import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:techtionary/widgets/history_header.dart';

import '../../models/module.dart';
import '../../data/lessons/front/javascript_lessons.dart';
import '../../data/modules/front/javascript_modules.dart';
import '../../history/front/js/js_history_modules.dart';
import '../../history/front/js/js_history_lessons.dart';

import '../../quizzes/front/js/js_module1_quiz.dart';
import '../../quizzes/front/js/js_module2_quiz.dart';
import '../../quizzes/front/js/js_module3_quiz.dart';
import '../../quizzes/front/js/js_module4_quiz.dart';
import '../../quizzes/front/js/js_module5_quiz.dart';
import '../../quizzes/front/js/js_module6_quiz.dart';
import '../../quizzes/front/js/js_module7_quiz.dart';
import '../../quizzes/front/js/js_module8_quiz.dart';
import '../../quizzes/front/js/js_final_quiz.dart';

import '../../widgets/quiz_widget.dart';
import '../../widgets/lesson_code.dart';
import '../../widgets/lesson_card.dart';
import '../../services/bookmark_service.dart';

class JavascriptPage extends StatefulWidget {
  final String? initialTopic;

  const JavascriptPage({super.key, this.initialTopic});

  @override
  State<JavascriptPage> createState() => _JavascriptPageState();
}

class _JavascriptPageState extends State<JavascriptPage> {
  String currentTopic = "JS Introduction";
  bool showMenu = false;

  bool get isHistoryLesson {
    return javascriptHistoryModules.any(
          (module) => module.lessons.contains(currentTopic),
    );
  }

  Module? get currentModule {
    final allModules = [
      ...jsModules,
      ...javascriptHistoryModules,
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
      final moduleTitle = module?.title ?? "JavaScript Lessons";
      const String techName = "JavaScript";

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
        if (currentTopic.contains("Module 1") && jsModules.isNotEmpty) {
          currentTopic = jsModules[0].lessons.first;
        } else if (currentTopic.contains("Module 2") && jsModules.length > 1) {
          currentTopic = jsModules[1].lessons.first;
        } else if (currentTopic.contains("Module 3") && jsModules.length > 2) {
          currentTopic = jsModules[2].lessons.first;
        } else if (currentTopic.contains("Module 4") && jsModules.length > 3) {
          currentTopic = jsModules[3].lessons.first;
        } else if (currentTopic.contains("Module 5") && jsModules.length > 4) {
          currentTopic = jsModules[4].lessons.first;
        } else if (currentTopic.contains("Module 6") && jsModules.length > 5) {
          currentTopic = jsModules[5].lessons.first;
        } else if (currentTopic.contains("Module 7") && jsModules.length > 6) {
          currentTopic = jsModules[6].lessons.first;
        } else {
          currentTopic = "JS Introduction";
        }
      }
    });
    _saveLessonHistory(currentTopic);
  }

  String _getHistoryTopicText(String topic) {
    switch (topic) {
      case "Release Date":
        return "December 4, 1995 - JavaScript was created in just 10 days and first released in December 1995 as part of the Netscape Navigator web browser.";
      case "Creator":
        return "Brendan Eich - Developed JavaScript while working at Netscape Communications in only 10 days to make web pages interactive.";
      case "Country of Origin":
        return "United States - Developed at Netscape Communications in California, USA.";
      case "Why It Was Created":
        return "JavaScript was created to add interactivity to web pages. It allows developers to respond to user actions, validate forms, update content dynamically, and create engaging user experiences without reloading the page.";
      case "Brief History":
        return "Originally named Mocha, then LiveScript, JavaScript was officially introduced in 1995. One of the core technologies of the web, alongside HTML and CSS, and widely used for server-side development through Node.js.";
      case "Evolution Timeline":
        return "1995: Mocha Created & Renamed to JavaScript | 1997: ECMAScript Standard (ES1) | 2009: ECMAScript 5 (ES5) | 2015: ECMAScript 6 (ES6) | Today: Modern ECMAScript (ES2024+)";
      case "Major Milestones":
        return "1995: Created by Brendan Eich | 1997: Standardized as ECMAScript | 2009: ES5 introduced major updates | 2015: ES6 added Classes, Arrow Functions, Promises & Modules | Today: Powers websites and backend via Node.js";
      case "Famous Quote":
        return "\"Always bet on JavaScript.\" — Brendan Eich";
      default:
        return "Learn how JavaScript was created and evolved over time.";
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
        title: const Text("JavaScript Tutorial"),
        centerTitle: true,

        actions: [
          if (!isQuiz)
            Builder(
              builder: (context) {
                const String techName = "JavaScript";
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
                          title: "JavaScript History",
                          subtitle:
                          "Learn how JavaScript was created and evolved over time.",
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
                          ...javascriptHistoryModules.map((module) {
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

                          ...jsModules.map((module) {
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
                                      "JavaScript FINAL QUIZ",
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
                                                courseTitle: "JavaScript",
                                                moduleTitle: "Final Quiz",
                                                questions: jsFinalQuizQuestions,
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
      final lesson = jsLessons.firstWhere(
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
      return getJavaScriptHistoryContent(currentTopic, context);
    }

    final quizWidgets = {
      "Module 1 Quiz": (VoidCallback onBack) => JsModule1Quiz(onBackToModules: onBack),
      "Module 2 Quiz": (VoidCallback onBack) => JsModule2Quiz(onBackToModules: onBack),
      "Module 3 Quiz": (VoidCallback onBack) => JsModule3Quiz(onBackToModules: onBack),
      "Module 4 Quiz": (VoidCallback onBack) => JsModule4Quiz(onBackToModules: onBack),
      "Module 5 Quiz": (VoidCallback onBack) => JsModule5Quiz(onBackToModules: onBack),
      "Module 6 Quiz": (VoidCallback onBack) => JsModule6Quiz(onBackToModules: onBack),
      "Module 7 Quiz": (VoidCallback onBack) => JsModule7Quiz(onBackToModules: onBack),
      "Module 8 Quiz": (VoidCallback onBack) => JsModule8Quiz(onBackToModules: onBack),
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
            language: "javascript",
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