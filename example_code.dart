import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';

class ExampleCode extends StatefulWidget {
  final String code;
  final String previewCode;
  final String language;

  const ExampleCode({
    super.key,
    required this.code,
    required this.previewCode,
    required this.language,
  });

  @override
  State<ExampleCode> createState() => _ExampleCodeState();
}

class _ExampleCodeState extends State<ExampleCode> {
  Future<void> _copyCode() async {
    await Clipboard.setData(
      ClipboardData(text: widget.code),
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Code copied"),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xff282C34),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header kung nasaan ang "Code" text at ang Copy button na magkasama
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            color: Colors.black26,
            child: Row(
              children: [
                const Text(
                  "Code",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  tooltip: "Copy",
                  onPressed: _copyCode,
                  icon: const Icon(
                    Icons.copy,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
          // Code body na may tamang kulay at walang numero sa gilid
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: HighlightView(
              widget.code,
              language: widget.language,
              theme: atomOneDarkTheme,
              padding: const EdgeInsets.all(16),
              textStyle: const TextStyle(
                fontFamily: "monospace",
                fontSize: 14,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}