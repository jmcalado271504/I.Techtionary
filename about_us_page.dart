import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 240,
            pinned: true,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: const Text(
                "About Us",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF2563EB),
                      Color(0xFF3B82F6),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Center(
                  child: CircleAvatar(
                    radius: 48,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.people_alt_rounded,
                      size: 54,
                      color: Color(0xFF2563EB),
                    ),
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Meet the Team",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    "I.Techtionary: An Interactive IT Dictionary Application is a capstone project developed to provide students, beginners, and IT learners with an accessible and interactive learning resource. The application provides simplified explanations of Information Technology terms and programming concepts through definitions, sample codes, quizzes, videos, and other interactive learning activities.",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      height: 1.6,
                      color: colorScheme.onSurface.withOpacity(0.8),
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    "The project was developed through the collaborative efforts of the team in application development, research, content preparation, and technical documentation.",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      height: 1.6,
                      color: colorScheme.onSurface.withOpacity(0.8),
                    ),
                  ),

                  const SizedBox(height: 28),

                  Text(
                    "Development Team",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  const _DeveloperCard(
                    name: "Calado, John Michael Constantino",
                    role: "Lead Developer / Mobile App Developer",
                    description:
                    "Responsible for the design and development of the I.Techtionary mobile application, including its user interface, navigation, core functionalities, and overall system structure.",
                    avatarIcon: Icons.code_rounded,
                  ),

                  const SizedBox(height: 24),

                  Text(
                    "Research & Documentation Team",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  const _DeveloperCard(
                    name: "Endaya Jr., Arsenio Carreon",
                    role: "Research & Documentation Lead",
                    description:
                    "Responsible for leading the research and documentation process, including the preparation of the research manuscript, related literature, research requirements, and supporting project documents.",
                    avatarIcon: Icons.article_outlined,
                  ),

                  const SizedBox(height: 12),

                  const _DeveloperCard(
                    name: "Gacad, Julie Ann Gacayan",
                    role: "Research & Content Specialist",
                    description:
                    "Responsible for assisting in the preparation, organization, and review of IT terms, definitions, learning materials, sample codes, quizzes, and other educational content included in the application.",
                    avatarIcon: Icons.find_in_page_outlined,
                  ),

                  const SizedBox(height: 12),

                  const _DeveloperCard(
                    name: "Caasi, Monica Tique",
                    role: "Technical Documentation Specialist",
                    description:
                    "Responsible for preparing and organizing technical documentation, system requirements, development records, testing documentation, and other technical project materials.",
                    avatarIcon: Icons.description_outlined,
                  ),

                  const SizedBox(height: 28),

                  Text(
                    "Project Details",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  const _InfoCard(
                    icon: Icons.info_outline,
                    title: "Project Information",
                    content:
                    "• Title: I.Techtionary: An Interactive IT Dictionary Application\n"
                        "• Type: Capstone Project\n"
                        "• Program: Bachelor of Science in Information Technology\n"
                        "• Platform: Android\n"
                        "• Technologies: Flutter, Dart, Android Studio, and Firebase",
                  ),

                  const SizedBox(height: 30),

                  const Divider(),

                  const SizedBox(height: 12),

                  Text(
                    "Version 1.0.0",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    "© I.Techtionary Team\nAll Rights Reserved.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: colorScheme.onSurface.withOpacity(0.6),
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DeveloperCard extends StatelessWidget {
  final String name;
  final String role;
  final String description;
  final IconData avatarIcon;

  const _DeveloperCard({
    required this.name,
    required this.role,
    required this.description,
    required this.avatarIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: const Color(0xFF2563EB).withOpacity(0.1),
              child: Icon(avatarIcon, color: const Color(0xFF2563EB)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    role,
                    style: TextStyle(
                      fontSize: 13,
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.4,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 32, color: const Color(0xFF2563EB)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    content,
                    style: const TextStyle(height: 1.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}