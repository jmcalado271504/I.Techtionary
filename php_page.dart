import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:techtionary/widgets/history_header.dart';

import '../../models/module.dart';
import '../../data/lessons/front/php_lessons.dart';
import '../../data/modules/front/php_modules.dart';
import '../../history/front/php/php_history_modules.dart';
import '../../history/front/php/php_history_lessons.dart';

import '../../quizzes/front/php/php_module1_quiz.dart';
import '../../quizzes/front/php/php_module2_quiz.dart';
import '../../quizzes/front/php/php_module3_quiz.dart';
import '../../quizzes/front/php/php_module4_quiz.dart';
import '../../quizzes/front/php/php_module5_quiz.dart';
import '../../quizzes/front/php/php_module6_quiz.dart';
import '../../quizzes/front/php/php_module7_quiz.dart';
import '../../quizzes/front/php/php_module8_quiz.dart';
import '../../quizzes/front/php/php_module9_quiz.dart';
import '../../quizzes/front/php/php_module10_quiz.dart';
import '../../quizzes/front/php/php_final_quiz.dart';

import '../../widgets/quiz_widget.dart';
import '../../widgets/lesson_code.dart';
import '../../widgets/lesson_card.dart';

import '../../services/bookmark_service.dart';

class PhpPage extends StatefulWidget {
  final String? initialTopic;

  const PhpPage({super.key, this.initialTopic});

  @override
  State<PhpPage> createState() => _PhpPageState();
}

class _PhpPageState extends State<PhpPage> {
  String currentTopic = "PHP Introduction";
  bool showMenu = false;

  bool get isHistoryLesson {
    return phpHistoryModules.any(
          (module) => module.lessons.contains(currentTopic),
    );
  }

  Module? get currentModule {
    final allModules = [
      ...phpModules,
      ...phpHistoryModules,
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
      final moduleTitle = module?.title ?? "PHP Lessons";
      const String techName = "PHP";

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
        if (currentTopic.contains("Module 1") && phpModules.isNotEmpty) {
          currentTopic = phpModules[0].lessons.first;
        } else if (currentTopic.contains("Module 2") && phpModules.length > 1) {
          currentTopic = phpModules[1].lessons.first;
        } else if (currentTopic.contains("Module 3") && phpModules.length > 2) {
          currentTopic = phpModules[2].lessons.first;
        } else if (currentTopic.contains("Module 4") && phpModules.length > 3) {
          currentTopic = phpModules[3].lessons.first;
        } else if (currentTopic.contains("Module 5") && phpModules.length > 4) {
          currentTopic = phpModules[4].lessons.first;
        } else if (currentTopic.contains("Module 6") && phpModules.length > 5) {
          currentTopic = phpModules[5].lessons.first;
        } else if (currentTopic.contains("Module 7") && phpModules.length > 6) {
          currentTopic = phpModules[6].lessons.first;
        } else if (currentTopic.contains("Module 8") && phpModules.length > 7) {
          currentTopic = phpModules[7].lessons.first;
        } else if (currentTopic.contains("Module 9") && phpModules.length > 8) {
          currentTopic = phpModules[8].lessons.first;
        } else if (currentTopic.contains("Module 10") && phpModules.length > 9) {
          currentTopic = phpModules[9].lessons.first;
        } else {
          currentTopic = "PHP Introduction";
        }
      }
    });
    _saveLessonHistory(currentTopic);
  }

  String _getHistoryTopicText(String topic) {
    switch (topic) {
      case "Release Date":
        return "June 8, 1995 - PHP was officially released on June 8, 1995. It quickly became one of the most popular server-side scripting languages for web development.";
      case "Creator":
        return "Rasmus Lerdorf - A Danish-Canadian programmer who created PHP in 1994 to monitor visitors to his personal website before expanding it into a complete programming language.";
      case "Country of Origin":
        return "Canada - Created by Rasmus Lerdorf while working in Canada. Today, it is maintained by contributors around the world.";
      case "Why It Was Created":
        return "PHP was created to simplify the development of dynamic websites. It allows developers to process forms, interact with databases, manage user sessions, and generate web pages dynamically on the server.";
      case "Brief History":
        return "PHP began in 1994 as a collection of CGI scripts called 'Personal Home Page Tools.' Evolved into a powerful server-side language that now powers millions of websites globally.";
      case "Evolution Timeline":
        return "1995: PHP/FI Released | 1998: PHP 3 (Redesigned Core) | 2000: PHP 4 (Zend Engine) | 2004: PHP 5 (OOP Improvements) | 2015: PHP 7 (Performance Speed) | 2020: PHP 8 (JIT Compiler)";
      case "Major Milestones":
        return "1995: First public release | 1998: PHP 3 redesigned architecture | 2000: PHP 4 launched with Zend Engine | 2004: PHP 5 improved OOP | 2015: PHP 7 increased speed | 2020: PHP 8 JIT compiler";
      case "Famous Quote":
        return "\"I'm not a language designer. I just kept adding the next logical step.\" — Rasmus Lerdorf";
      default:
        return "Learn how PHP was created and evolved over time.";
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
        title: const Text("PHP Tutorial"),
        centerTitle: true,

        actions: [
          if (!isQuiz)
            Builder(
              builder: (context) {
                const String techName = "PHP";
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
                          title: "PHP History",
                          subtitle:
                          "Learn how PHP was created and evolved over time.",
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
                          ...phpHistoryModules.map((module) {
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

                          ...phpModules.map((module) {
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
                                      "PHP FINAL QUIZ",
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
                                                courseTitle: "PHP",
                                                moduleTitle: "Final Quiz",
                                                questions:
                                                phpFinalQuizQuestions,
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
      final lesson = phpLessons.firstWhere(
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
      return getPhpHistoryContent(currentTopic, context);
    }

    final quizWidgets = {
      "Module 1 Quiz": (VoidCallback onBack) => PhpModule1Quiz(onBackToModules: onBack),
      "Module 2 Quiz": (VoidCallback onBack) => PhpModule2Quiz(onBackToModules: onBack),
      "Module 3 Quiz": (VoidCallback onBack) => PhpModule3Quiz(onBackToModules: onBack),
      "Module 4 Quiz": (VoidCallback onBack) => PhpModule4Quiz(onBackToModules: onBack),
      "Module 5 Quiz": (VoidCallback onBack) => PhpModule5Quiz(onBackToModules: onBack),
      "Module 6 Quiz": (VoidCallback onBack) => PhpModule6Quiz(onBackToModules: onBack),
      "Module 7 Quiz": (VoidCallback onBack) => PhpModule7Quiz(onBackToModules: onBack),
      "Module 8 Quiz": (VoidCallback onBack) => PhpModule8Quiz(onBackToModules: onBack),
      "Module 9 Quiz": (VoidCallback onBack) => PhpModule9Quiz(onBackToModules: onBack),
      "Module 10 Quiz": (VoidCallback onBack) => PhpModule10Quiz(onBackToModules: onBack),
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
            language: "php",
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