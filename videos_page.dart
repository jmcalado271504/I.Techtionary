import 'package:flutter/material.dart';
import 'video_player_page.dart';

class VideosPage extends StatelessWidget {
  const VideosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Video Tutorials",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _VideoCard(
            title: "Arduino Introduction",
            subtitle: "Learn the basics of microcontrollers and hardware programming.",
            thumbnail: "assets/images/arduino_thumbnail.png",
            videoPath: "",
            duration: "Coming Soon",
            tag: "Arduino",
            fallbackGradient: [Color(0xFF00979D), Color(0xFF005960)],
          ),
          SizedBox(height: 16),
          _VideoCard(
            title: "CSS Introduction",
            subtitle: "Learn the basics of CSS styling, selectors, and layout.",
            thumbnail: "assets/images/css_thumbnail.png",
            videoPath: "assets/videos/css_intro.mp4",
            duration: "04:13",
            tag: "CSS3",
            fallbackGradient: [Color(0xFF264DE4), Color(0xFF2965F1)],
          ),
          SizedBox(height: 16),
          _VideoCard(
            title: "Excel Introduction",
            subtitle: "Learn the basics of spreadsheets, formulas, and data management.",
            thumbnail: "assets/images/excel_thumbnail.png",
            videoPath: "assets/videos/excel_intro.mp4",
            duration: "05:00",
            tag: "EXCEL",
            fallbackGradient: [Color(0xFF107C41), Color(0xFF185ABD)],
          ),
          SizedBox(height: 16),
          _VideoCard(
            title: "HTML Introduction",
            subtitle: "Learn the basics of HTML structure, tags, and web syntax.",
            thumbnail: "assets/images/html_thumbnail.png",
            videoPath: "assets/videos/html_intro.mp4",
            duration: "07:16",
            tag: "HTML5",
            fallbackGradient: [Color(0xFFE44D26), Color(0xFFF16529)],
          ),
          SizedBox(height: 16),
          _VideoCard(
            title: "Java Introduction",
            subtitle: "Learn the fundamentals of Java programming and OOP concepts.",
            thumbnail: "assets/images/java_thumbnail.png",
            videoPath: "assets/videos/java_intro.mp4",
            duration: "06:30",
            tag: "JAVA",
            fallbackGradient: [Color(0xFFEA2D2E), Color(0xFF007396)],
          ),
          SizedBox(height: 16),
          _VideoCard(
            title: "JavaScript Introduction",
            subtitle: "Learn the basics of JavaScript programming and web interactivity.",
            thumbnail: "assets/images/javascript_thumbnail.png",
            videoPath: "assets/videos/javascript_intro.mp4",
            duration: "05:45",
            tag: "JS",
            fallbackGradient: [Color(0xFFF7DF1E), Color(0xFF323330)],
          ),
          SizedBox(height: 16),
          _VideoCard(
            title: "MySQL Introduction",
            subtitle: "Learn the basics of relational databases, tables, and SQL queries.",
            thumbnail: "assets/images/mysql_thumbnail.png",
            videoPath: "assets/videos/mysql_intro.mp4",
            duration: "03:58",
            tag: "MySQL",
            fallbackGradient: [Color(0xFF00758F), Color(0xFFF29111)],
          ),
          SizedBox(height: 16),
          _VideoCard(
            title: "Networking Introduction",
            subtitle: "Learn the basics of computer networks, IP addresses, and routing.",
            thumbnail: "assets/images/networking_thumbnail.png",
            videoPath: "",
            duration: "Coming Soon",
            tag: "Network",
            fallbackGradient: [Color(0xFF2C3E50), Color(0xFF4CA1AF)],
          ),
          SizedBox(height: 16),
          _VideoCard(
            title: "PHP Introduction",
            subtitle: "Learn the basics of server-side scripting and backend development.",
            thumbnail: "assets/images/php_thumbnail.png",
            videoPath: "",
            duration: "Coming Soon",
            tag: "PHP",
            fallbackGradient: [Color(0xFF777BB4), Color(0xFF4F5B93)],
          ),
          SizedBox(height: 16),
          _VideoCard(
            title: "SQL Introduction",
            subtitle: "Learn the basics of querying databases and managing relational data.",
            thumbnail: "assets/images/sql_thumbnail.png",
            videoPath: "",
            duration: "Coming Soon",
            tag: "SQL",
            fallbackGradient: [Color(0xFFCC292B), Color(0xFF00758F)],
          ),
        ],
      ),
    );
  }
}

class _VideoCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String thumbnail;
  final String videoPath;
  final String duration;
  final String tag;
  final List<Color> fallbackGradient;

  const _VideoCard({
    required this.title,
    required this.subtitle,
    required this.thumbnail,
    required this.videoPath,
    required this.duration,
    required this.tag,
    required this.fallbackGradient,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final bool hasVideo = videoPath.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDarkMode ? Colors.black.withOpacity(0.3) : Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: hasVideo
              ? () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => VideoPlayerPage(
                  title: title,
                  videoPath: videoPath,
                  description: subtitle,
                ),
              ),
            );
          }
              : () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("Coming Soon"),
                  content: Text("$title tutorial is coming soon!"),
                  actions: [
                    TextButton(
                      child: const Text("Okay"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.asset(
                      thumbnail,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: fallbackGradient,
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.code_rounded,
                                  size: 50,
                                  color: Colors.white70,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: hasVideo ? Colors.black.withOpacity(0.75) : Colors.orange.shade800,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        duration,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.deepPurpleAccent.withOpacity(0.85),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        tag,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}