import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Siguraduhing tama ang import path ng iyong QuizQuestion model
import '../models/quiz_question.dart';

class QuizWidget extends StatefulWidget {
  final String courseTitle; // Default: "Arduino"
  final String moduleTitle;
  final List<QuizQuestion> questions; // 👈 QuizQuestion na ang gamit dito!
  final VoidCallback onBackToModules;

  const QuizWidget({
    super.key,
    this.courseTitle = "Arduino",
    required this.moduleTitle,
    required this.questions,
    required this.onBackToModules,
  });

  @override
  State<QuizWidget> createState() => _QuizWidgetState();
}

class _QuizWidgetState extends State<QuizWidget> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  int? _selectedAnswerIndex;
  bool _isAnswered = false;
  bool _isSaving = false;

  void _answerQuestion(int index) {
    if (_isAnswered) return;

    setState(() {
      _selectedAnswerIndex = index;
      _isAnswered = true;

      // Kinokompara ang piniling index sa answerIndex ng QuizQuestion
      if (index == widget.questions[_currentQuestionIndex].answerIndex) {
        _score++;
      }
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < widget.questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedAnswerIndex = null;
        _isAnswered = false;
      });
    } else {
      _finishQuiz();
    }
  }

  Future<void> _finishQuiz() async {
    setState(() {
      _isSaving = true;
    });

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final totalQuestions = widget.questions.length;
      final percentage = (_score / totalQuestions) * 100;

      await FirebaseFirestore.instance.collection('quiz_results').add({
        'userId': user.uid,
        'courseTitle': widget.courseTitle,
        'moduleTitle': widget.moduleTitle,
        'score': _score,
        'totalQuestions': totalQuestions,
        'percentage': percentage,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }

    if (mounted) {
      setState(() {
        _isSaving = false;
      });
      _showResultDialog();
    }
  }

  void _showResultDialog() {
    final total = widget.questions.length;
    final percent = (_score / total) * 100;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Quiz Completed!"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Your Score: $_score / $total",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "${percent.toStringAsFixed(0)}%",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: percent >= 50 ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              widget.onBackToModules();
            },
            child: const Text("Back to Lessons"),
          ),
        ],
      ),
    );
  }

  Color _getOptionColor(int index) {
    if (!_isAnswered) {
      return Colors.white;
    }

    final correctIndex = widget.questions[_currentQuestionIndex].answerIndex;

    if (index == correctIndex) {
      return Colors.green.shade100; // Iilaw ang tamang sagot
    }

    if (index == _selectedAnswerIndex && index != correctIndex) {
      return Colors.red.shade100; // Maling napiling sagot
    }

    return Colors.white;
  }

  BorderSide _getOptionBorder(int index) {
    if (!_isAnswered) {
      return BorderSide(color: Colors.grey.shade300, width: 2);
    }

    final correctIndex = widget.questions[_currentQuestionIndex].answerIndex;

    if (index == correctIndex) {
      return const BorderSide(color: Colors.green, width: 2);
    }

    if (index == _selectedAnswerIndex && index != correctIndex) {
      return const BorderSide(color: Colors.red, width: 2);
    }

    return BorderSide(color: Colors.grey.shade300, width: 2);
  }

  @override
  Widget build(BuildContext context) {
    if (_isSaving) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final currentQuestion = widget.questions[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("${widget.courseTitle} Quiz"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Progress Header
            Text(
              "Question ${_currentQuestionIndex + 1} of ${widget.questions.length}",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),

            // Question Card
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  currentQuestion.question,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Choices
            ...List.generate(
              currentQuestion.choices.length,
                  (index) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: _getOptionColor(index),
                      side: _getOptionBorder(index),
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () => _answerQuestion(index),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        currentQuestion.choices[index],
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

            if (_isAnswered) ...[
              const SizedBox(height: 20),

              // Next / Finish Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: _nextQuestion,
                child: Text(
                  _currentQuestionIndex == widget.questions.length - 1
                      ? "Finish Quiz"
                      : "Next Question",
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}