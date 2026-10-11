import 'package:flutter/material.dart';
import 'example_code.dart';

class LessonCode extends StatelessWidget {
  final String code;
  final String previewCode;
  final String language;

  const LessonCode({
    super.key,
    required this.code,
    required this.previewCode,
    required this.language,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 20), // Sapat na espasyo bago mag-Notes
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.dividerColor,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // const Text(
          //   "Code",
          //   style: TextStyle(
          //     fontSize: 18,
          //     fontWeight: FontWeight.bold,
          //   ),
          // ),
          const SizedBox(height: 12),
          ExampleCode(
            code: code,
            previewCode: previewCode,
            language: language,
          ),
        ],
      ),
    );
  }
}