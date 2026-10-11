import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../data/lessons/sm/nodejs_lessons.dart';
import '../../models/module.dart';
import '../../data/modules/sm/nodejs_modules.dart';
import '../../history/sm/nodejs/nodejs_history_modules.dart';
import '../../history/sm/nodejs/nodejs_history_lessons.dart';

import 'package:techtionary/widgets/history_header.dart';
import '../../services/bookmark_service.dart';
import '../../widgets/lesson_code.dart';
import '../../widgets/quiz_widget.dart';
import '../../widgets/lesson_card.dart';

// QUIZZES
import '../../quizzes/sm/nodejs/nodejs_module1_quiz.dart';
import '../../quizzes/sm/nodejs/nodejs_module2_quiz.dart';
import '../../quizzes/sm/nodejs/nodejs_module3_quiz.dart';
import '../../quizzes/sm/nodejs/nodejs_module4_quiz.dart';
import '../../quizzes/sm/nodejs/nodejs_module5_quiz.dart';
import '../../quizzes/sm/nodejs/nodejs_module6_quiz.dart';
import '../../quizzes/sm/nodejs/nodejs_module7_quiz.dart';
import '../../quizzes/sm/nodejs/nodejs_module8_quiz.dart';
import '../../quizzes/sm/nodejs/nodejs_module9_quiz.dart';
import '../../quizzes/sm/nodejs/nodejs_module10_quiz.dart';
import '../../quizzes/sm/nodejs/nodejs_module11_quiz.dart';
import '../../quizzes/sm/nodejs/nodejs_module12_quiz.dart';
import '../../quizzes/sm/nodejs/nodejs_module13_quiz.dart';
import '../../quizzes/sm/nodejs/nodejs_module14_quiz.dart';
import '../../quizzes/sm/nodejs/nodejs_final_quiz.dart';

class NodeJsPage extends StatefulWidget {
  final String? initialTopic;

  const NodeJsPage({
    super.key,
    this.initialTopic,
  });

  @override
  State<NodeJsPage> createState() => _NodeJsPageState();
}

class _NodeJsPageState extends State<NodeJsPage> {
  String currentTopic = "Node Introduction";
  bool showMenu = false;
  static const String techName = "NodeJs";

  bool get isHistoryLesson {
    return nodejsHistoryModules.any(
          (module) => module.lessons.contains(currentTopic),
    );
  }

  Module? get currentModule {
    final allModules = [
      ...nodejsModules,
      ...nodejsHistoryModules,
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
      final moduleTitle = module?.title ?? "Node.js Lessons";

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
        if (currentTopic.contains("Module 1") && nodejsModules.isNotEmpty) {
          currentTopic = nodejsModules[0].lessons.first;
        } else if (currentTopic.contains("Module 2") && nodejsModules.length > 1) {
          currentTopic = nodejsModules[1].lessons.first;
        } else if (currentTopic.contains("Module 3") && nodejsModules.length > 2) {
          currentTopic = nodejsModules[2].lessons.first;
        } else if (currentTopic.contains("Module 4") && nodejsModules.length > 3) {
          currentTopic = nodejsModules[3].lessons.first;
        } else if (currentTopic.contains("Module 5") && nodejsModules.length > 4) {
          currentTopic = nodejsModules[4].lessons.first;
        } else if (currentTopic.contains("Module 6") && nodejsModules.length > 5) {
          currentTopic = nodejsModules[5].lessons.first;
        } else if (currentTopic.contains("Module 7") && nodejsModules.length > 6) {
          currentTopic = nodejsModules[6].lessons.first;
        } else if (currentTopic.contains("Module 8") && nodejsModules.length > 7) {
          currentTopic = nodejsModules[7].lessons.first;
        } else if (currentTopic.contains("Module 9") && nodejsModules.length > 8) {
          currentTopic = nodejsModules[8].lessons.first;
        } else if (currentTopic.contains("Module 10") && nodejsModules.length > 9) {
          currentTopic = nodejsModules[9].lessons.first;
        } else if (currentTopic.contains("Module 11") && nodejsModules.length > 10) {
          currentTopic = nodejsModules[10].lessons.first;
        } else if (currentTopic.contains("Module 12") && nodejsModules.length > 11) {
          currentTopic = nodejsModules[11].lessons.first;
        } else if (currentTopic.contains("Module 13") && nodejsModules.length > 12) {
          currentTopic = nodejsModules[12].lessons.first;
        } else if (currentTopic.contains("Module 14") && nodejsModules.length > 13) {
          currentTopic = nodejsModules[13].lessons.first;
        } else {
          currentTopic = "Node Introduction";
        }
      }
    });
    _saveLessonHistory(currentTopic);
  }

  String _getHistoryTopicText(String topic) {
    switch (topic) {
      case "Release Date":
        return "May 27, 2009\n\nNode.js was officially introduced by Ryan Dahl during the European JSConf in 2009.";
      case "Creator":
        return "Ryan Dahl\n\nRyan Dahl created Node.js to enable JavaScript to run outside the browser using Google's V8 JavaScript engine.";
      case "Country of Origin":
        return "United States\n\nNode.js was developed in the United States and quickly became one of the most popular runtime environments for JavaScript.";
      case "Why It Was Created":
        return "Node.js was created to build fast, scalable, and event-driven network applications. It allows JavaScript developers to create server-side applications using the same language used in the browser.";
      case "Brief History":
        return "Before Node.js, JavaScript was mainly used for client-side web development. Ryan Dahl developed Node.js in 2009 to overcome limitations of traditional web servers by using an event-driven, non-blocking I/O model. It rapidly gained popularity for backend development, APIs, real-time applications, and cloud services. Today, Node.js powers millions of web applications worldwide.";
      case "Evolution Timeline":
        return "2009\nNode.js Released\n│\n\n2011\nnpm Growth Begins\n│\n\n2015\nNode.js Foundation Created\n│\n\n2019\nNode.js 12 (LTS)\n│\n\n2022\nNode.js 18 (LTS)\n│\n\nToday\nNode.js 22.x";
      case "Major Milestones":
        return "• 2009 – Node.js was introduced by Ryan Dahl.\n\n• 2011 – npm became the world's largest JavaScript package manager.\n\n• 2015 – Node.js Foundation was established.\n\n• 2019 – Node.js matured with long-term support releases.\n\n• Today – Node.js is widely used for APIs, backend systems, microservices, and real-time web applications.";
      case "Famous Quote":
        return "\"JavaScript everywhere.\"\n\n— Ryan Dahl";
      default:
        return "Learn how NodeJS was created and evolved over time.";
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
        title: const Text("Node.js Tutorial"),
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
                          title: "NodeJS History",
                          subtitle:
                          "Learn how NodeJS was created and evolved over time.",
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
                          ...nodejsHistoryModules.map((module) {
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

                          ...nodejsModules.map((module) {
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
                                      "NODE.JS FINAL QUIZ",
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
                                                courseTitle: "Node.js",
                                                moduleTitle: "Final Quiz",
                                                questions:
                                                nodejsFinalQuizQuestions,
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
      final lesson = nodejsLessons.firstWhere(
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
      return getNodeJsHistoryContent(currentTopic, context);
    }

    final quizWidgets = {
      "Module 1 Quiz": (VoidCallback onBack) => NodejsModule1Quiz(onBackToModules: onBack),
      "Module 2 Quiz": (VoidCallback onBack) => NodejsModule2Quiz(onBackToModules: onBack),
      "Module 3 Quiz": (VoidCallback onBack) => NodejsModule3Quiz(onBackToModules: onBack),
      "Module 4 Quiz": (VoidCallback onBack) => NodejsModule4Quiz(onBackToModules: onBack),
      "Module 5 Quiz": (VoidCallback onBack) => NodejsModule5Quiz(onBackToModules: onBack),
      "Module 6 Quiz": (VoidCallback onBack) => NodejsModule6Quiz(onBackToModules: onBack),
      "Module 7 Quiz": (VoidCallback onBack) => NodejsModule7Quiz(onBackToModules: onBack),
      "Module 8 Quiz": (VoidCallback onBack) => NodejsModule8Quiz(onBackToModules: onBack),
      "Module 9 Quiz": (VoidCallback onBack) => NodejsModule9Quiz(onBackToModules: onBack),
      "Module 10 Quiz": (VoidCallback onBack) => NodejsModule10Quiz(onBackToModules: onBack),
      "Module 11 Quiz": (VoidCallback onBack) => NodejsModule11Quiz(onBackToModules: onBack),
      "Module 12 Quiz": (VoidCallback onBack) => NodejsModule12Quiz(onBackToModules: onBack),
      "Module 13 Quiz": (VoidCallback onBack) => NodejsModule13Quiz(onBackToModules: onBack),
      "Module 14 Quiz": (VoidCallback onBack) => NodejsModule14Quiz(onBackToModules: onBack),
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