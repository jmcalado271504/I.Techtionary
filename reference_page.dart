import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// ==========================================
// 1. DATA MODELS & DATA SOURCES
// ==========================================

class ReferenceLink {
  final String title;
  final String url;

  const ReferenceLink({
    required this.title,
    required this.url,
  });
}

class ReferenceLesson {
  final String title;
  final String note;
  final List<ReferenceLink> links;

  const ReferenceLesson({
    required this.title,
    required this.note,
    required this.links,
  });
}

class ReferenceCategory {
  final String title;
  final List<ReferenceLesson> lessons;

  const ReferenceCategory({
    required this.title,
    required this.lessons,
  });
}

const referenceCategories = [
  ReferenceCategory(
    title: "References",
    lessons: [
      ReferenceLesson(
        title: "Learn More",
        note:
        "This document contains the references used for the modules of I.Techtionary. The materials were compiled and adapted from trusted educational sources for learning purposes.",
        links: [
          ReferenceLink(
            title: "AngularJS",
            url: "https://angularjs.org",
          ),
          ReferenceLink(
            title: "GeeksforGeeks",
            url: "https://www.geeksforgeeks.org",
          ),
          ReferenceLink(
            title: "MicrosoftSupport",
            url: "https://support.microsoft.com",
          ),
          ReferenceLink(
            title: "Official Docs",
            url: "https://docs.microsoft.com",
          ),
          ReferenceLink(
            title: "TutorialsPoint",
            url: "https://www.tutorialspoint.com",
          ),
          ReferenceLink(
            title: "w3school",
            url: "https://www.w3schools.com",
          ),
        ],
      ),
    ],
  ),
];

// ==========================================
// 2. REFERENCE CARD WIDGET (STATIC / NO DROPDOWN)
// ==========================================

class ReferenceCardWidget extends StatelessWidget {
  final ReferenceLesson lesson;

  const ReferenceCardWidget({
    super.key,
    required this.lesson,
  });

  Future<void> openLink(BuildContext context, String urlString) async {
    final Uri uri = Uri.parse(urlString);

    try {
      final bool opened = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!opened && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Unable to open the reference link.",
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Unable to open the reference link.",
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      elevation: 2,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Header
            Row(
              children: [
                const Icon(
                  Icons.menu_book_rounded,
                  color: Colors.blue,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    lesson.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 12),

            // Reference Note
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.06),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.info_outline_rounded,
                    color: Colors.blue,
                    size: 22,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      lesson.note,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // List of Reference Links
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: lesson.links.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final linkItem = lesson.links[index];
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.2),
                    ),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    leading: const Icon(
                      Icons.link_rounded,
                      color: Colors.blue,
                    ),
                    title: Text(
                      linkItem.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 16,
                      color: Colors.grey,
                    ),
                    onTap: () => openLink(context, linkItem.url),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 3. MAIN REFERENCE PAGE
// ==========================================

class ReferencePage extends StatelessWidget {
  const ReferencePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("References"),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF1565C0),
                  Color(0xFF42A5F5),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.menu_book_rounded,
                  color: Colors.white,
                  size: 45,
                ),
                SizedBox(height: 12),
                Text(
                  "Learning References",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "The lessons included in I.Techtionary were compiled and adapted from trusted educational websites. Full credit belongs to the original authors and organizations.",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Categories
          ...referenceCategories.map(
                (category) => Padding(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: 25,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.title,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 3,
                    width: 70,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 15),
                  ...category.lessons.map(
                        (lesson) => ReferenceCardWidget(
                      lesson: lesson,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "© 2026 I.Techtionary\n\n"
                  "All references are provided "
                  "for educational purposes only.\n"
                  "All copyrights belong to their respective owners.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                height: 1.5,
              ),
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}