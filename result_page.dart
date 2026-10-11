import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ResultPage extends StatefulWidget {
  final List<dynamic> files;

  const ResultPage({
    super.key,
    required this.files,
  });

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  late final WebViewController _controller;

  String html = "";
  String css = "";
  String javascript = "";

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(
        JavaScriptMode.unrestricted,
      );

    _buildProject();
  }

  //=========================================
  // BUILD PROJECT
  //=========================================

  void _buildProject() {
    html = "";
    css = "";
    javascript = "";

    for (final file in widget.files) {
      switch (file.type) {
        case "html":
          html += "${file.code}\n";
          break;

        case "css":
          css += "${file.code}\n";
          break;

        case "js":
          javascript += "${file.code}\n";
          break;
      }
    }

    final document = '''
<!DOCTYPE html>

<html>

<head>

<meta charset="UTF-8">

<meta
name="viewport"
content="width=device-width, initial-scale=1.0">

<style>

$css

</style>

</head>

<body>

$html

<script>

$javascript

</script>

</body>

</html>
''';

    _controller.loadHtmlString(document);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Result"),
      ),

      body: SafeArea(
        child: WebViewWidget(
          controller: _controller,
        ),
      ),
    );
  }
}