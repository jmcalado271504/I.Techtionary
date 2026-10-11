import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:techtionary/widgets/history_header.dart';

import '../../models/module.dart';
import '../../data/lessons/front/mysql_lessons.dart';
import '../../data/modules/front/mysql_modules.dart';
import '../../history/front/mysql/mysql_history_modules.dart';
import '../../history/front/mysql/mysql_history_lessons.dart';

import '../../quizzes/front/mysql/mysql_module1_quiz.dart';
import '../../quizzes/front/mysql/mysql_module2_quiz.dart';
import '../../quizzes/front/mysql/mysql_module3_quiz.dart';
import '../../quizzes/front/mysql/mysql_module4_quiz.dart';
import '../../quizzes/front/mysql/mysql_module5_quiz.dart';
import '../../quizzes/front/mysql/mysql_module6_quiz.dart';
import '../../quizzes/front/mysql/mysql_module7_quiz.dart';
import '../../quizzes/front/mysql/mysql_module8_quiz.dart';
import '../../quizzes/front/mysql/mysql_module9_quiz.dart';
import '../../quizzes/front/mysql/mysql_final_quiz.dart';

import '../../widgets/quiz_widget.dart';
import '../../widgets/lesson_code.dart';
import '../../widgets/lesson_card.dart';

import '../../services/bookmark_service.dart';

class MysqlPage extends StatefulWidget {
  final String? initialTopic;

  const MysqlPage({super.key, this.initialTopic});

  @override
  State<MysqlPage> createState() => _MysqlPageState();
}

class _MysqlPageState extends State<MysqlPage> {
  String currentTopic = "MySQL Introduction";
  bool showMenu = false;

  bool get isHistoryLesson {
    return mysqlHistoryModules.any(
          (module) => module.lessons.contains(currentTopic),
    );
  }

  Module? get currentModule {
    final allModules = [
      ...mysqlModules,
      ...mysqlHistoryModules,
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
      final moduleTitle = module?.title ?? "MySQL Lessons";
      const String techName = "MySQL";

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
        if (currentTopic.contains("Module 1") && mysqlModules.isNotEmpty) {
          currentTopic = mysqlModules[0].lessons.first;
        } else if (currentTopic.contains("Module 2") && mysqlModules.length > 1) {
          currentTopic = mysqlModules[1].lessons.first;
        } else if (currentTopic.contains("Module 3") && mysqlModules.length > 2) {
          currentTopic = mysqlModules[2].lessons.first;
        } else if (currentTopic.contains("Module 4") && mysqlModules.length > 3) {
          currentTopic = mysqlModules[3].lessons.first;
        } else if (currentTopic.contains("Module 5") && mysqlModules.length > 4) {
          currentTopic = mysqlModules[4].lessons.first;
        } else if (currentTopic.contains("Module 6") && mysqlModules.length > 5) {
          currentTopic = mysqlModules[5].lessons.first;
        } else if (currentTopic.contains("Module 7") && mysqlModules.length > 6) {
          currentTopic = mysqlModules[6].lessons.first;
        } else if (currentTopic.contains("Module 8") && mysqlModules.length > 7) {
          currentTopic = mysqlModules[7].lessons.first;
        } else if (currentTopic.contains("Module 9") && mysqlModules.length > 8) {
          currentTopic = mysqlModules[8].lessons.first;
        } else {
          currentTopic = "MySQL Introduction";
        }
      }
    });
    _saveLessonHistory(currentTopic);
  }

  String _getHistoryTopicText(String topic) {
    switch (topic) {
      case "Release Date":
        return "May 23, 1995 - MySQL was first released on May 23, 1995. It quickly became one of the world's most popular relational database management systems due to its speed, reliability, and open-source nature.";
      case "Creator":
        return "Michael 'Monty' Widenius, David Axmark, Allan Larsson - The three Swedish developers created MySQL while working for MySQL AB. Michael Widenius is widely recognized as the principal creator.";
      case "Country of Origin":
        return "Sweden - MySQL was developed in Sweden by MySQL AB before later becoming part of Sun Microsystems and eventually Oracle Corporation.";
      case "Why It Was Created":
        return "MySQL was created to provide a fast, lightweight, and reliable relational database management system to efficiently store, organize, and retrieve large amounts of data for web and business applications.";
      case "Brief History":
        return "Development began in 1994 and the first public version was released in 1995. Sun Microsystems acquired MySQL AB in 2008, and in 2010 Oracle Corporation became its owner. It remains one of the most widely used database systems.";
      case "Evolution Timeline":
        return "1995: MySQL 1.0 Released | 2000: MySQL 3.23 Stability | 2005: MySQL 5.0 (Stored Procedures & Views) | 2008: Sun Microsystems Acquisition | 2010: Oracle Acquired MySQL | Today: MySQL 8.x";
      case "Major Milestones":
        return "1995: First public release | 2000: Adopted widely for web development | 2005: MySQL 5.0 introduced Stored Procedures, Views & Triggers | 2008: Sun Microsystems Acquisition | 2010: Oracle Corporation ownership | Today: Powers millions of systems";
      case "Famous Quote":
        return "\"The world's most popular open-source database.\" — MySQL Official Slogan";
      default:
        return "Learn how MySQL was created and evolved over time.";
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
        title: const Text("MySQL Tutorial"),
        centerTitle: true,

        actions: [
          if (!isQuiz)
            Builder(
              builder: (context) {
                const String techName = "CSS";
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
                          title: "MySQL History",
                          subtitle:
                          "Learn how MySQL was created and evolved over time.",
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
                          ...mysqlHistoryModules.map((module) {
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

                          ...mysqlModules.map((module) {
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
                                      "MYSQL FINAL QUIZ",
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
                                                courseTitle: "MySQL",
                                                moduleTitle: "Final Quiz",
                                                questions:
                                                mysqlFinalQuizQuestions,
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
      final lesson = mysqlLessons.firstWhere(
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
      return getMySqlHistoryContent(currentTopic, context);
    }

    final quizWidgets = {
      "Module 1 Quiz": (VoidCallback onBack) => MysqlModule1Quiz(onBackToModules: onBack),
      "Module 2 Quiz": (VoidCallback onBack) => MysqlModule2Quiz(onBackToModules: onBack),
      "Module 3 Quiz": (VoidCallback onBack) => MysqlModule3Quiz(onBackToModules: onBack),
      "Module 4 Quiz": (VoidCallback onBack) => MysqlModule4Quiz(onBackToModules: onBack),
      "Module 5 Quiz": (VoidCallback onBack) => MysqlModule5Quiz(onBackToModules: onBack),
      "Module 6 Quiz": (VoidCallback onBack) => MysqlModule6Quiz(onBackToModules: onBack),
      "Module 7 Quiz": (VoidCallback onBack) => MysqlModule7Quiz(onBackToModules: onBack),
      "Module 8 Quiz": (VoidCallback onBack) => MysqlModule8Quiz(onBackToModules: onBack),
      "Module 9 Quiz": (VoidCallback onBack) => MysqlModule9Quiz(onBackToModules: onBack),
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
            language: "sql",
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