import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../data/lessons/sm/postgresql_lessons.dart';
import '../../models/module.dart';
import '../../data/modules/sm/postgresql_modules.dart';
import '../../history/sm/postgresql/postgresql_history_modules.dart';
import '../../history/sm/postgresql/postgresql_history_lessons.dart';

import 'package:techtionary/widgets/history_header.dart';
import '../../widgets/quiz_widget.dart';
import '../../services/bookmark_service.dart';
import '../../widgets/lesson_code.dart';
import '../../widgets/lesson_card.dart';

// QUIZZES
import '../../quizzes/sm/postgresql/postgresql_module1_quiz.dart';
import '../../quizzes/sm/postgresql/postgresql_module2_quiz.dart';
import '../../quizzes/sm/postgresql/postgresql_module3_quiz.dart';
import '../../quizzes/sm/postgresql/postgresql_module4_quiz.dart';
import '../../quizzes/sm/postgresql/postgresql_module5_quiz.dart';
import '../../quizzes/sm/postgresql/postgresql_module6_quiz.dart';
import '../../quizzes/sm/postgresql/postgresql_module7_quiz.dart';
import '../../quizzes/sm/postgresql/postgresql_module8_quiz.dart';
import '../../quizzes/sm/postgresql/postgresql_module9_quiz.dart';
import '../../quizzes/sm/postgresql/postgresql_module10_quiz.dart';
import '../../quizzes/sm/postgresql/postgresql_module11_quiz.dart';
import '../../quizzes/sm/postgresql/postgresql_final_quiz.dart';

class PostgreSqlPage extends StatefulWidget {
  final String? initialTopic;

  const PostgreSqlPage({
    super.key,
    this.initialTopic,
  });

  @override
  State<PostgreSqlPage> createState() => _PostgreSqlPageState();
}

class _PostgreSqlPageState extends State<PostgreSqlPage> {
  String currentTopic = "PostgreSQL Introduction";
  bool showMenu = false;
  static const String techName = "PostgreSQL";

  bool get isHistoryLesson {
    return postgresqlHistoryModules.any(
          (module) => module.lessons.contains(currentTopic),
    );
  }

  Module? get currentModule {
    final allModules = [
      ...postgresqlModules,
      ...postgresqlHistoryModules,
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
      final moduleTitle = module?.title ?? "PostgreSQL Lessons";

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
        if (currentTopic.contains("Module 1") && postgresqlModules.isNotEmpty) {
          currentTopic = postgresqlModules[0].lessons.first;
        } else if (currentTopic.contains("Module 2") && postgresqlModules.length > 1) {
          currentTopic = postgresqlModules[1].lessons.first;
        } else if (currentTopic.contains("Module 3") && postgresqlModules.length > 2) {
          currentTopic = postgresqlModules[2].lessons.first;
        } else if (currentTopic.contains("Module 4") && postgresqlModules.length > 3) {
          currentTopic = postgresqlModules[3].lessons.first;
        } else if (currentTopic.contains("Module 5") && postgresqlModules.length > 4) {
          currentTopic = postgresqlModules[4].lessons.first;
        } else if (currentTopic.contains("Module 6") && postgresqlModules.length > 5) {
          currentTopic = postgresqlModules[5].lessons.first;
        } else if (currentTopic.contains("Module 7") && postgresqlModules.length > 6) {
          currentTopic = postgresqlModules[6].lessons.first;
        } else if (currentTopic.contains("Module 8") && postgresqlModules.length > 7) {
          currentTopic = postgresqlModules[7].lessons.first;
        } else if (currentTopic.contains("Module 9") && postgresqlModules.length > 8) {
          currentTopic = postgresqlModules[8].lessons.first;
        } else if (currentTopic.contains("Module 10") && postgresqlModules.length > 9) {
          currentTopic = postgresqlModules[9].lessons.first;
        } else if (currentTopic.contains("Module 11") && postgresqlModules.length > 10) {
          currentTopic = postgresqlModules[10].lessons.first;
        } else {
          currentTopic = "PostgreSQL Introduction";
        }
      }
    });
    _saveLessonHistory(currentTopic);
  }

  String _getHistoryTopicText(String topic) {
    switch (topic) {
      case "Release Date":
        return "July 8, 1996\n\nPostgreSQL was officially released in 1996 as the successor to the POSTGRES database project.";
      case "Creator":
        return "Michael Stonebraker\n\nPostgreSQL originated from the POSTGRES project led by Professor Michael Stonebraker at the University of California, Berkeley.";
      case "Country of Origin":
        return "United States\n\nPostgreSQL was developed at the University of California, Berkeley, in the United States.";
      case "Why It Was Created":
        return "PostgreSQL was created to provide a powerful, extensible, and standards-compliant relational database management system that supports advanced database features while remaining open source.";
      case "Brief History":
        return "The PostgreSQL project began as POSTGRES in 1986 under Professor Michael Stonebraker. It was designed to overcome limitations found in earlier database systems. In 1996, support for SQL was added and the project was renamed PostgreSQL. Today, PostgreSQL is recognized as one of the world's most advanced open-source relational database systems and is widely used in enterprise, cloud, and web applications.";
      case "Evolution Timeline":
        return "1986\nPOSTGRES Project Started\n│\n\n1994\nSQL Support Added\n│\n\n1996\nRenamed PostgreSQL\n│\n\n2005\nEnterprise Adoption Increased\n│\n\n2016\nPostgreSQL 9.6\nPerformance Improvements\n│\n\nToday\nPostgreSQL 17";
      case "Major Milestones":
        return "• 1986 – POSTGRES research project began.\n\n• 1996 – PostgreSQL officially released.\n\n• Introduced advanced SQL compliance and extensibility.\n\n• Became one of the world's leading open-source relational databases.\n\n• Today – Used by governments, enterprises, startups, and cloud platforms worldwide.";
      case "Famous Quote":
        return "\"The world's most advanced open source relational database.\"\n\n— PostgreSQL Global Development Group";
      default:
        return "Learn how PostgreSQL was created and evolved over time.";
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
        title: const Text("PostgreSQL Tutorial"),
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
                          title: "PostgreSQL History",
                          subtitle:
                          "Learn how PostgreSQL was created and evolved over time.",
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
                          ...postgresqlHistoryModules.map((module) {
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

                          ...postgresqlModules.map((module) {
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
                                      "POSTGRESQL FINAL QUIZ",
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
                                                courseTitle: "PostgreSQL",
                                                moduleTitle: "Final Quiz",
                                                questions:
                                                postgresqlFinalQuizQuestions,
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
      final lesson = postgresqlLessons.firstWhere(
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
      return getPostgreSQLHistoryContent(currentTopic, context);
    }

    final quizWidgets = {
      "Module 1 Quiz": (VoidCallback onBack) => PostgreSQLModule1Quiz(onBackToModules: onBack),
      "Module 2 Quiz": (VoidCallback onBack) => PostgreSQLModule2Quiz(onBackToModules: onBack),
      "Module 3 Quiz": (VoidCallback onBack) => PostgreSQLModule3Quiz(onBackToModules: onBack),
      "Module 4 Quiz": (VoidCallback onBack) => PostgreSQLModule4Quiz(onBackToModules: onBack),
      "Module 5 Quiz": (VoidCallback onBack) => PostgreSQLModule5Quiz(onBackToModules: onBack),
      "Module 6 Quiz": (VoidCallback onBack) => PostgreSQLModule6Quiz(onBackToModules: onBack),
      "Module 7 Quiz": (VoidCallback onBack) => PostgreSQLModule7Quiz(onBackToModules: onBack),
      "Module 8 Quiz": (VoidCallback onBack) => PostgreSQLModule8Quiz(onBackToModules: onBack),
      "Module 9 Quiz": (VoidCallback onBack) => PostgreSQLModule9Quiz(onBackToModules: onBack),
      "Module 10 Quiz": (VoidCallback onBack) => PostgreSQLModule10Quiz(onBackToModules: onBack),
      "Module 11 Quiz": (VoidCallback onBack) => PostgreSQLModule11Quiz(onBackToModules: onBack),
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