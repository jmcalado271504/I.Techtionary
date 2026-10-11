import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppRatingDialog extends StatefulWidget {
  const AppRatingDialog({super.key});

  /// Tatawagin ito pagkatapos ng Lesson, Quiz, o Game.
  /// Magpapakita lang ito KUNG nakalipas na ang Cooldown Hours.
  static Future<void> showWithCooldown(
      BuildContext context, {
        int cooldownHours = 1,
      }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final lastShownTimestamp = prefs.getInt('last_rating_prompt_time') ?? 0;
      final currentTime = DateTime.now().millisecondsSinceEpoch;

      final hoursPassed = (currentTime - lastShownTimestamp) / (1000 * 60 * 60);

      if (hoursPassed < cooldownHours) {
        return;
      }

      await prefs.setInt('last_rating_prompt_time', currentTime);

      if (!context.mounted) return;

      // Isara muna ang Drawer kung nakabukas ito
      final scaffold = Scaffold.maybeOf(context);
      if (scaffold != null && scaffold.isDrawerOpen) {
        Navigator.of(context).pop();
        await Future.delayed(const Duration(milliseconds: 200));
      }

      if (!context.mounted) return;

      final isDark = Theme.of(context).brightness == Brightness.dark;

      showDialog(
        context: context,
        barrierDismissible: true,
        barrierColor: isDark
            ? Colors.black.withOpacity(0.75)
            : Colors.black.withOpacity(0.25),
        builder: (context) => const AppRatingDialog(),
      );
    } catch (e) {
      debugPrint("Error checking rating cooldown: $e");
    }
  }

  @override
  State<AppRatingDialog> createState() => _AppRatingDialogState();
}

class _AppRatingDialogState extends State<AppRatingDialog> {
  int selectedRating = 0;
  bool isSaving = false;

  final List<String> _ratingLabels = [
    "Tap a star to rate",
    "Poor 😞",
    "Fair 😐",
    "Good 🙂",
    "Very Good 😊",
    "Excellent! 🤩"
  ];

  Future<void> saveRating() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() => isSaving = true);

    try {
      await FirebaseFirestore.instance
          .collection('app_ratings')
          .doc(user.uid)
          .set({
        'userId': user.uid,
        'rating': selectedRating,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      if (!mounted) return;

      Navigator.of(context).pop();

      // Thank You Success Alert
      showDialog(
        context: context,
        builder: (BuildContext context) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          return AlertDialog(
            backgroundColor: isDark ? const Color(0xFF242526) : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            title: Text(
              "Thank You!",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            content: Text(
              "Thank you for your rating! ⭐",
              style: TextStyle(
                color: isDark ? Colors.grey.shade300 : Colors.black87,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "OK",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          );
        },
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => isSaving = false);
    }
  }

  Widget buildStar(int star, bool isDarkMode) {
    final isSelected = star <= selectedRating;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            selectedRating = star;
          });
        },
        borderRadius: BorderRadius.circular(30),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
          child: Icon(
            isSelected ? Icons.star_rounded : Icons.star_outline_rounded,
            size: 40,
            color: isSelected
                ? Colors.amber.shade600
                : (isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    final cardBgColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    final primaryTextColor = isDarkMode ? Colors.white : Colors.black87;
    final secondaryTextColor = isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600;

    final iconBgColor = isDarkMode ? Colors.amber.shade900.withOpacity(0.3) : const Color(0xFFFFFBEB);
    final iconColor = isDarkMode ? Colors.amber.shade400 : Colors.amber.shade600;
    final borderColor = isDarkMode ? Colors.grey.shade800 : const Color(0xFFE5E7EB);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Center(
        child: SingleChildScrollView(
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
              decoration: BoxDecoration(
                color: cardBgColor,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: borderColor, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDarkMode ? 0.4 : 0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // App Badge Header Icon (Star Icon)
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: iconBgColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.star_rounded,
                      size: 44,
                      color: iconColor,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Text(
                    "How was your experience?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: primaryTextColor,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    _ratingLabels[selectedRating],
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: selectedRating == 0
                          ? secondaryTextColor
                          : Colors.amber.shade600,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Stars Selection
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      5,
                          (index) => buildStar(index + 1, isDarkMode),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDarkMode ? Colors.blue.shade700 : const Color(0xFF2563EB),
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: isDarkMode ? Colors.grey.shade800 : const Color(0xFFF3F4F6),
                        disabledForegroundColor: isDarkMode ? Colors.grey.shade600 : const Color(0xFF9CA3AF),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: (selectedRating == 0 || isSaving) ? null : saveRating,
                      child: isSaving
                          ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                          : const Text(
                        "Submit Rating",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Dismiss Button
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      foregroundColor: secondaryTextColor,
                    ),
                    child: const Text(
                      "Maybe Later",
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}