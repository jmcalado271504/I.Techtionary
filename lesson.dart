import 'package:flutter/material.dart';

class Lesson {
  /// Lesson Title
  final String title;

  /// description
  final String description;

  /// Sample Code
  final String code;

  /// Preview Code
  final String? previewCode;

  /// Notes
  final String notes;

  /// Lesson Page
  final Widget? page;

  const Lesson({
    required this.title,
    required this.description,
    required this.code,
    this.previewCode,
    required this.notes,
    this.page,
  });
}

class LessonReference {
  final String title;
  final String source;
  final String link;

  const LessonReference({
    required this.title,
    required this.source,
    required this.link,
  });
}