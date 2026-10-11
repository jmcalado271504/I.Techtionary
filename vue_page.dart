import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../data/lessons/sm/vue_lessons.dart';
import '../../models/module.dart';
import '../../data/modules/sm/vue_modules.dart';
import '../../history/sm/vue/vue_history_modules.dart';
import '../../history/sm/vue/vue_history_lessons.dart';

import 'package:techtionary/widgets/history_header.dart';
import '../../services/bookmark_service.dart';
import '../../widgets/lesson_code.dart';
import '../../widgets/lesson_card.dart';
import '../../widgets/quiz_widget.dart';

import '../../quizzes/sm/vue/vue_module1_quiz.dart';
import '../../quizzes/sm/vue/vue_module2_quiz.dart';
import '../../quizzes/sm/vue/vue_module3_quiz.dart';
import '../../quizzes/sm/vue/vue_module4_quiz.dart';
import '../../quizzes/sm/vue/vue_module5_quiz.dart';
import '../../quizzes/sm/vue/vue_module6_quiz.dart';
import '../../quizzes/sm/vue/vue_module7_quiz.dart';
import '../../quizzes/sm/vue/vue_module8_quiz.dart';
import '../../quizzes/sm/vue/vue_module9_quiz.dart';
import '../../quizzes/sm/vue/vue_module10_quiz.dart';
import '../../quizzes/sm/vue/vue_module11_quiz.dart';
import '../../quizzes/sm/vue/vue_module12_quiz.dart';
import '../../quizzes/sm/vue/vue_module13_quiz.dart';
import '../../quizzes/sm/vue/vue_module14_quiz.dart';
import '../../quizzes/sm/vue/vue_module15_quiz.dart';
import '../../quizzes/sm/vue/vue_module16_quiz.dart';
import '../../quizzes/sm/vue/vue_final_quiz.dart';

class VuePage extends StatefulWidget {
  final String? initialTopic;

  const VuePage({
    super.key,
    this.initialTopic,
  });

  @override
  State<VuePage> createState() => _VuePageState();
}

class _VuePageState extends State<VuePage> {
  String currentTopic = "Vue Introduction";
  bool showMenu = false;
  static const String techName = "Vue";

  bool get isHistoryLesson {
    return vueHistoryModules.any(
          (module) => module.lessons.contains(currentTopic),
    );
  }

  Module? get currentModule {
    final allModules = [
      ...vueModules,
      ...vueHistoryModules,
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
      final moduleTitle = module?.title ?? "Vue Lessons";

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
        if (currentTopic.contains("Module 1") && vueModules.isNotEmpty) {
          currentTopic = vueModules[0].lessons.first;
        } else if (currentTopic.contains("Module 2") && vueModules.length > 1) {
          currentTopic = vueModules[1].lessons.first;
        } else if (currentTopic.contains("Module 3") && vueModules.length > 2) {
          currentTopic = vueModules[2].lessons.first;
        } else if (currentTopic.contains("Module 4") && vueModules.length > 3) {
          currentTopic = vueModules[3].lessons.first;
        } else if (currentTopic.contains("Module 5") && vueModules.length > 4) {
          currentTopic = vueModules[4].lessons.first;
        } else if (currentTopic.contains("Module 6") && vueModules.length > 5) {
          currentTopic = vueModules[5].lessons.first;
        } else if (currentTopic.contains("Module 7") && vueModules.length > 6) {
          currentTopic = vueModules[6].lessons.first;
        } else if (currentTopic.contains("Module 8") && vueModules.length > 7) {
          currentTopic = vueModules[7].lessons.first;
        } else if (currentTopic.contains("Module 9") && vueModules.length > 8) {
          currentTopic = vueModules[8].lessons.first;
        } else if (currentTopic.contains("Module 10") && vueModules.length > 9) {
          currentTopic = vueModules[9].lessons.first;
        } else if (currentTopic.contains("Module 11") && vueModules.length > 10) {
          currentTopic = vueModules[10].lessons.first;
        } else if (currentTopic.contains("Module 12") && vueModules.length > 11) {
          currentTopic = vueModules[11].lessons.first;
        } else if (currentTopic.contains("Module 13") && vueModules.length > 12) {
          currentTopic = vueModules[12].lessons.first;
        } else if (currentTopic.contains("Module 14") && vueModules.length > 13) {
          currentTopic = vueModules[13].lessons.first;
        } else if (currentTopic.contains("Module 15") && vueModules.length > 14) {
          currentTopic = vueModules[14].lessons.first;
        } else if (currentTopic.contains("Module 16") && vueModules.length > 15) {
          currentTopic = vueModules[15].lessons.first;
        } else {
          currentTopic = "Vue Introduction";
        }
      }
    });
    _saveLessonHistory(currentTopic);
  }

  String _getHistoryTopicText(String topic) {
    switch (topic) {
      case "Release Date":
        return "February 2014\n\nVue.js was officially released in February 2014 as an open-source JavaScript framework for building user interfaces.";
      case "Creator":
        return "Evan You\n\nVue.js was created by Evan You, a former Google engineer who previously worked with AngularJS. He designed Vue to be lightweight, flexible, and easy to learn.";
      case "Country of Origin":
        return "China\n\nVue.js was created by Evan You, a Chinese software engineer. Although he worked in the United States, Vue's creator is from China.";
      case "Why It Was Created":
        return "Vue.js was created to provide a simpler and more approachable frontend framework than existing solutions. It focuses on progressive adoption, allowing developers to use as little or as much of the framework as needed.";
      case "Brief History":
        return "After working with AngularJS at Google, Evan You wanted to build a framework that combined the best features of Angular while removing unnecessary complexity. Vue.js was released in 2014 and quickly gained popularity because of its simplicity, excellent documentation, and strong performance. Today, Vue is one of the world's most widely used JavaScript frameworks.";
      case "Evolution Timeline":
        return "2014\nVue.js Released\n│\n\n2016\nVue 2 Released\n│\n\n2020\nVue 3 Released\nComposition API Introduced\n│\n\n2021+\nGrowing Ecosystem\n│\n\nToday\nVue 3.x";
      case "Major Milestones":
        return "• 2014 – Vue.js officially released.\n\n• 2016 – Vue 2 introduced Virtual DOM improvements.\n\n• 2020 – Vue 3 added the Composition API and significant performance improvements.\n\n• Built a large ecosystem including Vue Router, Pinia, and Nuxt.\n\n• Today – Vue is one of the three most popular frontend JavaScript frameworks.";
      case "Famous Quote":
        return "\"The Progressive JavaScript Framework.\"\n\n— Vue.js Official Website";
      default:
        return "Learn how Vue was created and evolved over time.";
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
        title: const Text("Vue Tutorial"),
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
                          title: "Vue History",
                          subtitle:
                          "Learn how Vue was created and evolved over time.",
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
                          ...vueHistoryModules.map((module) {
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

                          ...vueModules.map((module) {
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
                                      "VUE FINAL QUIZ",
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
                                                courseTitle: "Vue",
                                                moduleTitle: "Final Quiz",
                                                questions:
                                                vueFinalQuizQuestions,
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
      final lesson = vueLessons.firstWhere(
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
      return getVueHistoryContent(currentTopic, context);
    }

    final quizWidgets = {
      "Module 1 Quiz": (VoidCallback onBack) => VueModule1Quiz(onBackToModules: onBack),
      "Module 2 Quiz": (VoidCallback onBack) => VueModule2Quiz(onBackToModules: onBack),
      "Module 3 Quiz": (VoidCallback onBack) => VueModule3Quiz(onBackToModules: onBack),
      "Module 4 Quiz": (VoidCallback onBack) => VueModule4Quiz(onBackToModules: onBack),
      "Module 5 Quiz": (VoidCallback onBack) => VueModule5Quiz(onBackToModules: onBack),
      "Module 6 Quiz": (VoidCallback onBack) => VueModule6Quiz(onBackToModules: onBack),
      "Module 7 Quiz": (VoidCallback onBack) => VueModule7Quiz(onBackToModules: onBack),
      "Module 8 Quiz": (VoidCallback onBack) => VueModule8Quiz(onBackToModules: onBack),
      "Module 9 Quiz": (VoidCallback onBack) => VueModule9Quiz(onBackToModules: onBack),
      "Module 10 Quiz": (VoidCallback onBack) => VueModule10Quiz(onBackToModules: onBack),
      "Module 11 Quiz": (VoidCallback onBack) => VueModule11Quiz(onBackToModules: onBack),
      "Module 12 Quiz": (VoidCallback onBack) => VueModule12Quiz(onBackToModules: onBack),
      "Module 13 Quiz": (VoidCallback onBack) => VueModule13Quiz(onBackToModules: onBack),
      "Module 14 Quiz": (VoidCallback onBack) => VueModule14Quiz(onBackToModules: onBack),
      "Module 15 Quiz": (VoidCallback onBack) => VueModule15Quiz(onBackToModules: onBack),
      "Module 16 Quiz": (VoidCallback onBack) => VueModule16Quiz(onBackToModules: onBack),
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