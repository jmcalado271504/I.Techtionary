import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:techtionary/services/auth_service.dart';
import 'package:techtionary/pages/sign_in_page.dart';
import 'package:techtionary/userhub/about_us_page.dart';
import 'package:techtionary/userhub/bookmarks_page.dart';
import 'package:techtionary/userhub/profile_page.dart';
import 'package:techtionary/userhub/privacy_policy_page.dart';
import 'package:techtionary/userhub/quiz_history_page.dart';
import 'package:techtionary/userhub/app_rating_page.dart';
import 'package:techtionary/userhub/lesson_history_page.dart';
import 'package:techtionary/userhub/reference_page.dart';

class AppDrawer extends StatelessWidget {
  final bool isDark;
  final VoidCallback toggleTheme;

  const AppDrawer({
    super.key,
    required this.isDark,
    required this.toggleTheme,
  });

  @override
  Widget build(BuildContext context) {
    // Kukunin ang background at text color mula sa active ThemeData
    final theme = Theme.of(context);
    final drawerBackgroundColor = theme.colorScheme.surface;
    final textColor = theme.textTheme.bodyLarge?.color;
    final iconColor = theme.iconTheme.color;

    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.72,
      child: Drawer(
        backgroundColor: drawerBackgroundColor, // Dynamic Theme Background
        child: Stack(
          children: [
            ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/logo.png",
                        width: 70,
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        "I.Techtionary",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        "Learn • Practice • Explore",
                        style: TextStyle(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),

                // PROFILE
                ListTile(
                  leading: Icon(Icons.person, color: iconColor),
                  title: Text("Profile", style: TextStyle(color: textColor)),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ProfilePage(),
                      ),
                    );
                  },
                ),

                // BOOKMARKS
                ListTile(
                  leading: Icon(Icons.bookmark, color: iconColor),
                  title: Text("Bookmarks", style: TextStyle(color: textColor)),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const BookmarksPage(),
                      ),
                    );
                  },
                ),

                // QUIZ HISTORY
                ListTile(
                  leading: Icon(Icons.bar_chart, color: iconColor),
                  title: Text("Quiz History", style: TextStyle(color: textColor)),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const QuizHistoryPage(),
                      ),
                    );
                  },
                ),

                // LESSON HISTORY
                ListTile(
                  leading: Icon(Icons.history_edu, color: iconColor),
                  title: Text("Lesson History", style: TextStyle(color: textColor)),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const LessonHistoryPage(),
                      ),
                    );
                  },
                ),

                // DARK MODE SWITCH
                SwitchListTile(
                  secondary: Icon(Icons.dark_mode, color: iconColor),
                  title: Text("Dark Mode", style: TextStyle(color: textColor)),
                  value: isDark,
                  onChanged: (_) => toggleTheme(),
                ),

                // ABOUT US
                ListTile(
                  leading: Icon(Icons.info_outline, color: iconColor),
                  title: Text("About Us", style: TextStyle(color: textColor)),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AboutUsPage(),
                      ),
                    );
                  },
                ),

                // PRIVACY POLICY
                ListTile(
                  leading: Icon(Icons.privacy_tip_outlined, color: iconColor),
                  title: Text("Privacy Policy", style: TextStyle(color: textColor)),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const PrivacyPolicyPage(),
                      ),
                    );
                  },
                ),

                // RATE APP
                ListTile(
                  leading: Icon(Icons.star_rate, color: iconColor),
                  title: Text("Rate I.Techtionary", style: TextStyle(color: textColor)),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AppRatingDialog(),
                      ),
                    );
                  },
                ),

                // SHARE APP
                ListTile(
                  leading: Icon(Icons.share, color: iconColor),
                  title: Text("Share I.Techtionary", style: TextStyle(color: textColor)),
                  onTap: () {
                    Share.share(
                      "🚀 Install I.Techtionary App Now!\n\n"
                          "✔ Learn Programming Language\n"
                          "📥 Download APK here:\n"
                          "https://drive.google.com/file/d/1J51VTidWBzEp5jJLRKp0OK59ClKyfBWD/view?usp=sharing",
                    );
                  },
                ),

                // REFERENCE
                ListTile(
                  leading: Icon(Icons.star_rate, color: iconColor),
                  title: Text("Reference", style: TextStyle(color: textColor)),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ReferencePage(),
                      ),
                    );
                  },
                ),

                Divider(color: theme.dividerColor),

                // LOGOUT
                ListTile(
                  leading: Icon(Icons.logout, color: iconColor),
                  title: Text("Logout", style: TextStyle(color: textColor)),
                  onTap: () async {
                    await AuthService.signOut();

                    if (!context.mounted) return;

                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SignInPage(),
                      ),
                          (route) => false,
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}