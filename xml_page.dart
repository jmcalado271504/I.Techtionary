import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../data/lessons/sm/xml_lessons.dart';
import '../../models/module.dart';
import '../../data/modules/sm/xml_modules.dart';
import '../../history/sm/xml/xml_history_modules.dart';
import '../../history/sm/xml/xml_history_lessons.dart';

import 'package:techtionary/widgets/history_header.dart';
import '../../services/bookmark_service.dart';
import '../../widgets/lesson_code.dart';
import '../../widgets/lesson_card.dart';
import '../../widgets/quiz_widget.dart';

import '../../quizzes/sm/xml/xml_module1_quiz.dart';
import '../../quizzes/sm/xml/xml_module2_quiz.dart';
import '../../quizzes/sm/xml/xml_module3_quiz.dart';
import '../../quizzes/sm/xml/xml_module4_quiz.dart';
import '../../quizzes/sm/xml/xml_module5_quiz.dart';
import '../../quizzes/sm/xml/xml_module6_quiz.dart';
import '../../quizzes/sm/xml/xml_module7_quiz.dart';
import '../../quizzes/sm/xml/xml_module8_quiz.dart';
import '../../quizzes/sm/xml/xml_module9_quiz.dart';
import '../../quizzes/sm/xml/xml_module10_quiz.dart';
import '../../quizzes/sm/xml/xml_final_quiz.dart';

class XmlPage extends StatefulWidget {
  final String? initialTopic;

  const XmlPage({
    super.key,
    this.initialTopic,
  });

  @override
  State<XmlPage> createState() => _XmlPageState();
}

class _XmlPageState extends State<XmlPage> {
  String currentTopic = "XML Introduction";
  bool showMenu = false;
  static const String techName = "XML";

  bool get isHistoryLesson {
    return xmlHistoryModules.any(
          (module) => module.lessons.contains(currentTopic),
    );
  }

  Module? get currentModule {
    final allModules = [
      ...xmlModules,
      ...xmlHistoryModules,
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
      final moduleTitle = module?.title ?? "XML Lessons";

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
        if (currentTopic.contains("Module 1") && xmlModules.isNotEmpty) {
          currentTopic = xmlModules[0].lessons.first;
        } else if (currentTopic.contains("Module 2") && xmlModules.length > 1) {
          currentTopic = xmlModules[1].lessons.first;
        } else if (currentTopic.contains("Module 3") && xmlModules.length > 2) {
          currentTopic = xmlModules[2].lessons.first;
        } else if (currentTopic.contains("Module 4") && xmlModules.length > 3) {
          currentTopic = xmlModules[3].lessons.first;
        } else if (currentTopic.contains("Module 5") && xmlModules.length > 4) {
          currentTopic = xmlModules[4].lessons.first;
        } else if (currentTopic.contains("Module 6") && xmlModules.length > 5) {
          currentTopic = xmlModules[5].lessons.first;
        } else if (currentTopic.contains("Module 7") && xmlModules.length > 6) {
          currentTopic = xmlModules[6].lessons.first;
        } else if (currentTopic.contains("Module 8") && xmlModules.length > 7) {
          currentTopic = xmlModules[7].lessons.first;
        } else if (currentTopic.contains("Module 9") && xmlModules.length > 8) {
          currentTopic = xmlModules[8].lessons.first;
        } else if (currentTopic.contains("Module 10") && xmlModules.length > 9) {
          currentTopic = xmlModules[9].lessons.first;
        } else {
          currentTopic = "XML Introduction";
        }
      }
    });
    _saveLessonHistory(currentTopic);
  }

  String _getHistoryTopicText(String topic) {
    switch (topic) {
      case "Release Date":
        return "February 10, 1998\n\nXML (eXtensible Markup Language) became an official W3C Recommendation on February 10, 1998.";
      case "Creator":
        return "World Wide Web Consortium (W3C)\n\nXML was developed by the XML Working Group of the W3C, led by Jon Bosak with contributions from many experts in the web community.";
      case "Country of Origin":
        return "United States\n\nXML was standardized by the World Wide Web Consortium (W3C), an international organization headquartered in the United States.";
      case "Why It Was Created":
        return "XML was created to provide a flexible, self-descriptive, and platform-independent way of storing and transporting structured data between different systems and applications.";
      case "Brief History":
        return "XML was derived from SGML (Standard Generalized Markup Language) to create a simpler format suitable for the web. It was designed to separate data from presentation, making information easier to exchange across different platforms. Since becoming a W3C Recommendation in 1998, XML has been widely used in web services, configuration files, office documents, RSS feeds, and enterprise systems.";
      case "Evolution Timeline":
        return "1996\nXML Development Began\n│\n\n1998\nXML 1.0 Became W3C Recommendation\n│\n\n1999\nNamespaces in XML Introduced\n│\n\n2004\nXML 1.1 Released\n│\n\n2010+\nContinued Enterprise Adoption\n│\n\nToday\nWidely Used for Data Exchange";
      case "Major Milestones":
        return "• 1998 – XML 1.0 officially became a W3C Recommendation.\n\n• Introduced a universal standard for structured data exchange.\n\n• XML became the foundation of many web services and enterprise applications.\n\n• Office document formats, Android layouts, and RSS feeds adopted XML.\n\n• Today – XML remains an important technology for configuration, integration, and data storage.";
      case "Famous Quote":
        return "\"XML is designed to transport and store data.\"\n\n— W3Schools";
      default:
        return "Learn how XML was created and evolved over time.";
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
        title: const Text("XML Tutorial"),
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
                          title: "XML History",
                          subtitle:
                          "Learn how XML was created and evolved over time.",
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
                          ...xmlHistoryModules.map((module) {
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

                          ...xmlModules.map((module) {
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
                                      "XML FINAL QUIZ",
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
                                                courseTitle: "XML",
                                                moduleTitle: "Final Quiz",
                                                questions:
                                                xmlFinalQuizQuestions,
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
      final lesson = xmlLessons.firstWhere(
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
      return getXmlHistoryContent(currentTopic, context);
    }

    final quizWidgets = {
      "Module 1 Quiz": (VoidCallback onBack) => XmlModule1Quiz(onBackToModules: onBack),
      "Module 2 Quiz": (VoidCallback onBack) => XmlModule2Quiz(onBackToModules: onBack),
      "Module 3 Quiz": (VoidCallback onBack) => XmlModule3Quiz(onBackToModules: onBack),
      "Module 4 Quiz": (VoidCallback onBack) => XmlModule4Quiz(onBackToModules: onBack),
      "Module 5 Quiz": (VoidCallback onBack) => XmlModule5Quiz(onBackToModules: onBack),
      "Module 6 Quiz": (VoidCallback onBack) => XmlModule6Quiz(onBackToModules: onBack),
      "Module 7 Quiz": (VoidCallback onBack) => XmlModule7Quiz(onBackToModules: onBack),
      "Module 8 Quiz": (VoidCallback onBack) => XmlModule8Quiz(onBackToModules: onBack),
      "Module 9 Quiz": (VoidCallback onBack) => XmlModule9Quiz(onBackToModules: onBack),
      "Module 10 Quiz": (VoidCallback onBack) => XmlModule10Quiz(onBackToModules: onBack),
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
            language: "xml",
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