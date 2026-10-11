import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../models/module.dart';
import '../../data/lessons/sm/csharp_lessons.dart';
import '../../data/modules/sm/csharp_modules.dart';
import '../../history/sm/csharp/csharp_history_modules.dart';
import '../../history/sm/csharp/csharp_history_lessons.dart';

import 'package:techtionary/widgets/history_header.dart';
import '../../quizzes/sm/csharp/csharp_module1_quiz.dart';
import '../../quizzes/sm/csharp/csharp_module2_quiz.dart';
import '../../quizzes/sm/csharp/csharp_module3_quiz.dart';
import '../../quizzes/sm/csharp/csharp_module4_quiz.dart';
import '../../quizzes/sm/csharp/csharp_module5_quiz.dart';
import '../../quizzes/sm/csharp/csharp_module6_quiz.dart';
import '../../quizzes/sm/csharp/csharp_module7_quiz.dart';
import '../../quizzes/sm/csharp/csharp_final_quiz.dart';

import '../../widgets/quiz_widget.dart';
import '../../widgets/lesson_code.dart';
import '../../widgets/lesson_card.dart';
import '../../services/bookmark_service.dart';

class CsharpPage extends StatefulWidget {
  final String? initialTopic;

  const CsharpPage({
    super.key,
    this.initialTopic,
  });

  @override
  State<CsharpPage> createState() => _CsharpPageState();
}

class _CsharpPageState extends State<CsharpPage> {
  String currentTopic = "CSharp Introduction";
  bool showMenu = false;
  static const String techName = "CSharp";

  bool get isHistoryLesson {
    return csharpHistoryModules.any(
          (module) => module.lessons.contains(currentTopic),
    );
  }

  Module? get currentModule {
    final allModules = [
      ...csharpModules,
      ...csharpHistoryModules,
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
      final moduleTitle = module?.title ?? "C# Lessons";

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
        if (currentTopic.contains("Module 1") && csharpModules.isNotEmpty) {
          currentTopic = csharpModules[0].lessons.first;
        } else if (currentTopic.contains("Module 2") && csharpModules.length > 1) {
          currentTopic = csharpModules[1].lessons.first;
        } else if (currentTopic.contains("Module 3") && csharpModules.length > 2) {
          currentTopic = csharpModules[2].lessons.first;
        } else if (currentTopic.contains("Module 4") && csharpModules.length > 3) {
          currentTopic = csharpModules[3].lessons.first;
        } else if (currentTopic.contains("Module 5") && csharpModules.length > 4) {
          currentTopic = csharpModules[4].lessons.first;
        } else if (currentTopic.contains("Module 6") && csharpModules.length > 5) {
          currentTopic = csharpModules[5].lessons.first;
        } else if (currentTopic.contains("Module 7") && csharpModules.length > 6) {
          currentTopic = csharpModules[6].lessons.first;
        } else {
          currentTopic = "CSharp Introduction";
        }
      }
    });
    _saveLessonHistory(currentTopic);
  }

  String _getHistoryTopicText(String topic) {
    switch (topic) {
      case "Release Date":
        return "January 2002\n\nC# was officially released by Microsoft in January 2002 alongside the .NET Framework.";
      case "Creator":
        return "Anders Hejlsberg\n\nC# was designed by Anders Hejlsberg, a Danish software engineer who also created Turbo Pascal and later contributed to TypeScript.";
      case "Country of Origin":
        return "United States\n\nC# was developed by Microsoft at its headquarters in Redmond, Washington, USA.";
      case "Why It Was Created":
        return "C# was created to provide a modern, object-oriented programming language for the .NET platform. It combines the power of C++ with the simplicity of Java while offering improved safety, productivity, and ease of development.";
      case "Brief History":
        return "Development of C# began in the late 1990s as part of Microsoft's .NET initiative. The language was officially released in 2002 and quickly became one of the primary languages for Windows application development. Over the years, C# evolved to support web development through ASP.NET, game development with Unity, cloud computing, mobile applications, and cross-platform development using .NET.";
      case "Evolution Timeline":
        return "1999\nDevelopment Began\n│\n\n2002\nC# 1.0 Released\n│\n\n2005\nC# 2.0\nGenerics Introduced\n│\n\n2010\nC# 4.0\nDynamic Features\n│\n\n2016\n.NET Core Expansion\n│\n\nToday\nC# 13 / .NET 9";
      case "Major Milestones":
        return "• 2002 – C# officially released with .NET Framework.\n\n• Generics introduced in C# 2.0.\n\n• LINQ added in C# 3.0.\n\n• .NET Core enabled true cross-platform development.\n\n• Today – C# is widely used for desktop, web, cloud, mobile, AI, and Unity game development.";
      case "Famous Quote":
        return "\"C# is intended to be a simple, modern, general-purpose programming language.\"\n\n— Microsoft";
      default:
        return "Learn how Csharp was created and evolved over time.";
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
        title: const Text("C# Tutorial"),
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
                          title: "Csharp History",
                          subtitle:
                          "Learn how Csharp was created and evolved over time.",
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
                          ...csharpHistoryModules.map((module) {
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

                          ...csharpModules.map((module) {
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
                                      "C# FINAL QUIZ",
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
                                                courseTitle: "C# Programming",
                                                moduleTitle: "Final Quiz",
                                                questions:
                                                csharpFinalQuizQuestions,
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
      final lesson = csharpLessons.firstWhere(
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
      return getCSharpHistoryContent(currentTopic, context);
    }

    final quizWidgets = {
      "Module 1 Quiz": (VoidCallback onBack) => CsharpModule1Quiz(onBackToModules: onBack),
      "Module 2 Quiz": (VoidCallback onBack) => CsharpModule2Quiz(onBackToModules: onBack),
      "Module 3 Quiz": (VoidCallback onBack) => CsharpModule3Quiz(onBackToModules: onBack),
      "Module 4 Quiz": (VoidCallback onBack) => CsharpModule4Quiz(onBackToModules: onBack),
      "Module 5 Quiz": (VoidCallback onBack) => CsharpModule5Quiz(onBackToModules: onBack),
      "Module 6 Quiz": (VoidCallback onBack) => CsharpModule6Quiz(onBackToModules: onBack),
      "Module 7 Quiz": (VoidCallback onBack) => CsharpModule7Quiz(onBackToModules: onBack),
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
            language: "csharp",
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