import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddOrEditLessonPage extends StatefulWidget {
  final String initialTech;
  final DocumentSnapshot? existingDoc;

  const AddOrEditLessonPage({
    super.key,
    required this.initialTech,
    this.existingDoc,
  });

  @override
  State<AddOrEditLessonPage> createState() => _AddOrEditLessonPageState();
}

class _AddOrEditLessonPageState extends State<AddOrEditLessonPage> {
  String _selectedSectionType = "Module Section";
  final List<String> _sectionTypes = ["Module Section", "History Section"];

  // Predefined history types with built-in icons support
  String _selectedHistoryTitle = "Release Date";
  final List<String> _historySubTypes = [
    "Release Date",
    "Creator",
    "Country of Origin",
    "Why It Was Created",
    "Brief History",
    "Evolution Timeline",
    "Major Milestones",
    "Famous Quote"
  ];

  final _moduleTitleController = TextEditingController();
  final _lessonTitleController = TextEditingController();
  final _historyCategoryController = TextEditingController();
  final _definitionController = TextEditingController();
  final _codeSnippetController = TextEditingController();
  final _notesController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.existingDoc != null) {
      final data = widget.existingDoc!.data() as Map<String, dynamic>;
      _selectedSectionType = data['sectionType'] ?? "Module Section";
      _moduleTitleController.text = data['moduleTitle'] ?? '';
      _lessonTitleController.text = data['lessonTitle'] ?? '';
      _historyCategoryController.text = data['historyCategory'] ?? '${widget.initialTech} History';

      String lessonTitle = data['lessonTitle'] ?? '';
      if (_historySubTypes.contains(lessonTitle)) {
        _selectedHistoryTitle = lessonTitle;
      }

      _definitionController.text = data['definition'] ?? '';
      _codeSnippetController.text = data['codeSnippet'] ?? '';
      _notesController.text = data['notes'] ?? '';
    } else {
      _historyCategoryController.text = "${widget.initialTech} History";
    }
  }

  @override
  void dispose() {
    _moduleTitleController.dispose();
    _lessonTitleController.dispose();
    _historyCategoryController.dispose();
    _definitionController.dispose();
    _codeSnippetController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _saveContent() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final lessonData = {
        'techName': widget.initialTech,
        'sectionType': _selectedSectionType,
        'moduleTitle': _selectedSectionType == "Module Section" ? _moduleTitleController.text.trim() : '',
        'lessonTitle': _selectedSectionType == "Module Section"
            ? _lessonTitleController.text.trim()
            : _selectedHistoryTitle,
        'historyCategory': _selectedSectionType == "History Section" ? _historyCategoryController.text.trim() : '',
        'definition': _definitionController.text.trim(),
        'codeSnippet': _selectedSectionType == "Module Section" ? _codeSnippetController.text.trim() : '',
        'notes': _selectedSectionType == "Module Section" ? _notesController.text.trim() : '',
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (widget.existingDoc != null) {
        await FirebaseFirestore.instance
            .collection('lessons')
            .doc(widget.existingDoc!.id)
            .update(lessonData);
      } else {
        lessonData['createdAt'] = FieldValue.serverTimestamp();
        await FirebaseFirestore.instance.collection('lessons').add(lessonData);
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(widget.existingDoc != null ? "Successfully updated content!" : "Successfully added content!")),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving: $e")),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isEditing = widget.existingDoc != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? "Edit Content in ${widget.initialTech}" : "Add Content to ${widget.initialTech}"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Technology", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 6),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade400),
              ),
              child: Text(
                widget.initialTech,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
            ),
            const SizedBox(height: 16),

            const Text("Section Type", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade400),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedSectionType,
                  isExpanded: true,
                  items: _sectionTypes.map((String type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedSectionType = newValue!;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),

            if (_selectedSectionType == "Module Section") ...[
              TextField(
                controller: _moduleTitleController,
                decoration: const InputDecoration(
                  labelText: "Module Title (e.g. Module 1: Intro)",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _lessonTitleController,
                decoration: const InputDecoration(
                  labelText: "Lesson Title (e.g. Ecosystem)",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _definitionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: "Definition / Explanation Text",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _codeSnippetController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: "Code Snippet (Text format)",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _notesController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: "Notes (Optional)",
                  border: OutlineInputBorder(),
                ),
              ),
            ] else ...[
              TextField(
                controller: _historyCategoryController,
                decoration: const InputDecoration(
                  labelText: "History Category Title (e.g. Arduino History)",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              const Text("History Type (Select from Dropdown)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedHistoryTitle,
                    isExpanded: true,
                    items: _historySubTypes.map((String subType) {
                      return DropdownMenuItem<String>(
                        value: subType,
                        child: Text(subType),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedHistoryTitle = newValue!;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _definitionController,
                maxLines: 6,
                decoration: const InputDecoration(
                  labelText: "History Content / Explanation Text (Type here below the line)",
                  border: OutlineInputBorder(),
                ),
              ),
            ],

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: _isLoading ? null : _saveContent,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(isEditing ? "Update Content" : "Save Content", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}