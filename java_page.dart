import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:techtionary/widgets/history_header.dart';

import '../../models/module.dart';
import '../../data/lessons/front/java_lessons.dart';
import '../../data/modules/front/java_modules.dart';
import '../../history/front/java/java_history_modules.dart';
import '../../history/front/java/java_history_lessons.dart';

import '../../quizzes/front/java/java_module1_quiz.dart';
import '../../quizzes/front/java/java_module2_quiz.dart';
import '../../quizzes/front/java/java_module3_quiz.dart';
import '../../quizzes/front/java/java_module4_quiz.dart';
import '../../quizzes/front/java/java_module5_quiz.dart';
import '../../quizzes/front/java/java_module6_quiz.dart';
import '../../quizzes/front/java/java_module7_quiz.dart';
import '../../quizzes/front/java/java_module8_quiz.dart';
import '../../quizzes/front/java/java_module9_quiz.dart';
import '../../quizzes/front/java/java_module10_quiz.dart';
import '../../quizzes/front/java/java_module11_quiz.dart';
import '../../quizzes/front/java/java_module12_quiz.dart';
import '../../quizzes/front/java/java_final_quiz.dart';

import '../../widgets/quiz_widget.dart';
import '../../widgets/lesson_code.dart';
import '../../widgets/lesson_card.dart';

import '../../services/bookmark_service.dart';

class JavaPage extends StatefulWidget {
  final String? initialTopic;

  const JavaPage({super.key, this.initialTopic});

  @override
  State<JavaPage> createState() => _JavaPageState();
}

class _JavaPageState extends State<JavaPage> {
  String currentTopic = "Java Introduction";
  bool showMenu = false;

  bool get isHistoryLesson {
    return javaHistoryModules.any(
          (module) => module.lessons.contains(currentTopic),
    );
  }

  Module? get currentModule {
    final allModules = [
      ...javaModules,
      ...javaHistoryModules,
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
      final moduleTitle = module?.title ?? "Java Lessons";
      const String techName = "Java";

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
        if (currentTopic.contains("Module 1") && javaModules.isNotEmpty) {
          currentTopic = javaModules[0].lessons.first;
        } else if (currentTopic.contains("Module 2") && javaModules.length > 1) {
          currentTopic = javaModules[1].lessons.first;
        } else if (currentTopic.contains("Module 3") && javaModules.length > 2) {
          currentTopic = javaModules[2].lessons.first;
        } else if (currentTopic.contains("Module 4") && javaModules.length > 3) {
          currentTopic = javaModules[3].lessons.first;
        } else if (currentTopic.contains("Module 5") && javaModules.length > 4) {
          currentTopic = javaModules[4].lessons.first;
        } else if (currentTopic.contains("Module 6") && javaModules.length > 5) {
          currentTopic = javaModules[5].lessons.first;
        } else if (currentTopic.contains("Module 7") && javaModules.length > 6) {
          currentTopic = javaModules[6].lessons.first;
        } else if (currentTopic.contains("Module 8") && javaModules.length > 7) {
          currentTopic = javaModules[7].lessons.first;
        } else if (currentTopic.contains("Module 9") && javaModules.length > 8) {
          currentTopic = javaModules[8].lessons.first;
        } else if (currentTopic.contains("Module 10") && javaModules.length > 9) {
          currentTopic = javaModules[9].lessons.first;
        } else if (currentTopic.contains("Module 11") && javaModules.length > 10) {
          currentTopic = javaModules[10].lessons.first;
        } else if (currentTopic.contains("Module 12") && javaModules.length > 11) {
          currentTopic = javaModules[11].lessons.first;
        } else {
          currentTopic = "Java Introduction";
        }
      }
    });
    _saveLessonHistory(currentTopic);
  }

  String _getHistoryTopicText(String topic) {
    switch (topic) {
      case "Release Date":
        return "May 23, 1995 - Java was officially released by Sun Microsystems on May 23, 1995. It quickly became one of the world's most popular programming languages because of its portability and reliability.";
      case "Creator":
        return "James Gosling - James Gosling, often called the 'Father of Java,' developed Java while working at Sun Microsystems together with Mike Sheridan and Patrick Naughton.";
      case "Country of Origin":
        return "United States - Java was developed by Sun Microsystems in California, USA. Today, it is maintained by Oracle Corporation.";
      case "Why It Was Created":
        return "Java was created to allow developers to write software that could run on different devices without changing the source code. Its famous principle is 'Write Once, Run Anywhere' (WORA).";
      case "Brief History":
        return "Java began as a project named Oak in 1991 for interactive television systems but later evolved into a programming language for the internet. Used for web applications, enterprise software, Android development, and cloud computing.";
      case "Evolution Timeline":
        return "1991: Oak Project Started | 1995: Java 1.0 Released | 1998: Java 2 (J2SE) | 2004: Java 5 (Generics) | 2014: Java 8 (Lambda) | Today: Java 21+ (LTS)";
      case "Major Milestones":
        return "1991: Oak project started | 1995: Java officially released | 1998: Java 2 platform improvements | 2004: Java 5 Generics & Enums | 2014: Java 8 Lambdas & Streams | Today: Widely used global programming language";
      case "Famous Quote":
        return "\"Write Once, Run Anywhere.\" — Java Design Philosophy";
      default:
        return "Learn how Java was created and evolved over time.";
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
        title: const Text("JAVA Tutorial"),
        centerTitle: true,

        actions: [
          if (!isQuiz)
            Builder(
              builder: (context) {
                const String techName = "Java";
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
                          title: "Java History",
                          subtitle: "Learn how Java was created and evolved over time.",
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
                          ...javaHistoryModules.map((module) {
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

                          ...javaModules.map((module) {
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
                                      "JAVA FINAL QUIZ",
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
                                                courseTitle: "JAVA",
                                                moduleTitle: "Final Quiz",
                                                questions: javaFinalQuizQuestions,
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
      final lesson = javaLessons.firstWhere(
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
      return getJavaHistoryContent(currentTopic, context);
    }

    final quizWidgets = {
      "Module 1 Quiz": (VoidCallback onBack) => JavaModule1Quiz(onBackToModules: onBack),
      "Module 2 Quiz": (VoidCallback onBack) => JavaModule2Quiz(onBackToModules: onBack),
      "Module 3 Quiz": (VoidCallback onBack) => JavaModule3Quiz(onBackToModules: onBack),
      "Module 4 Quiz": (VoidCallback onBack) => JavaModule4Quiz(onBackToModules: onBack),
      "Module 5 Quiz": (VoidCallback onBack) => JavaModule5Quiz(onBackToModules: onBack),
      "Module 6 Quiz": (VoidCallback onBack) => JavaModule6Quiz(onBackToModules: onBack),
      "Module 7 Quiz": (VoidCallback onBack) => JavaModule7Quiz(onBackToModules: onBack),
      "Module 8 Quiz": (VoidCallback onBack) => JavaModule8Quiz(onBackToModules: onBack),
      "Module 9 Quiz": (VoidCallback onBack) => JavaModule9Quiz(onBackToModules: onBack),
      "Module 10 Quiz": (VoidCallback onBack) => JavaModule10Quiz(onBackToModules: onBack),
      "Module 11 Quiz": (VoidCallback onBack) => JavaModule11Quiz(onBackToModules: onBack),
      "Module 12 Quiz": (VoidCallback onBack) => JavaModule12Quiz(onBackToModules: onBack),
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
            language: "java",
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