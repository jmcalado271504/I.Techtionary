class QuizQuestion {
  final String question;
  final List<String> choices;
  final int answerIndex;

  QuizQuestion({
    required this.question,
    required this.choices,
    required this.answerIndex,
  });
}