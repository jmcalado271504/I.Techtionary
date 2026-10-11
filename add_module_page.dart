import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddModulePage extends StatefulWidget {
  const AddModulePage({super.key});

  @override
  State<AddModulePage> createState() => _AddModulePageState();
}

class _AddModulePageState extends State<AddModulePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _iconController = TextEditingController(text: "Icons.bubble_chart");

  String selectedCategory = "Programming Languages";
  String selectedRoadmap = "None";
  String selectedDisplayLocation = "Main Dashboard (Default List)";
  String selectedLevelType = "High";
  bool isFeature = false;
  bool _isLoading = false;

  final List<String> categories = [
    "Hardware & Embedded",
    "Programming Languages",
    "Frameworks & Libraries",
    "Databases & Tools",
    "Features / App Options",
  ];

  final List<String> roadmaps = [
    "None",
    "Web Development",
    "Mobile Development",
    "Game Development",
  ];

  final List<String> displayLocations = [
    "Main Dashboard (Default List)",
    "More Dashboard Page",
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _iconController.dispose();
    super.dispose();
  }

  Future<void> _saveModule() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        String newName = _nameController.text.trim();

        final querySnapshot = await FirebaseFirestore.instance
            .collection('custom_technologies')
            .get();

        bool isExisting = querySnapshot.docs.any((doc) {
          final data = doc.data();
          final existingName = (data['name'] ?? '').toString().trim().toLowerCase();
          return existingName == newName.toLowerCase();
        });

        if (isExisting) {
          if (!mounted) return;
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("This Technology name already exists!"),
              backgroundColor: Colors.black,
            ),
          );
          return;
        }

        await FirebaseFirestore.instance.collection('custom_technologies').add({
          'name': newName,
          'category': selectedCategory,
          'roadmap': selectedRoadmap,
          'track': 'None',
          'isLowLevel': selectedLevelType == "Low",
          'isFeature': isFeature,
          'displayLocation': selectedDisplayLocation,
          'icon': _iconController.text.trim().isEmpty ? 'Icons.bubble_chart' : _iconController.text.trim(),
          'createdAt': FieldValue.serverTimestamp(),
        });

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Successfully added!"), backgroundColor: Colors.black),
        );
        Navigator.pop(context);
      } catch (e) {
        if (!mounted) return;
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        cardColor: Colors.black,
        canvasColor: Colors.black,
        dialogBackgroundColor: Colors.black,
        colorScheme: const ColorScheme.dark(
          surface: Colors.black,
          primary: Colors.white,
          onSurface: Colors.white,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Add Dashboard Icon / Module", style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.black,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  controller: _nameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: "Tech Name (Text sa baba)",
                    labelStyle: TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: Colors.black,
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white54),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  validator: (value) => value == null || value.trim().isEmpty ? "Please enter a name" : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _iconController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: "Icon Code",
                    labelStyle: TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: Colors.black,
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white54),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedDisplayLocation,
                  dropdownColor: Colors.black,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: "Display Location",
                    labelStyle: TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: Colors.black,
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white54),
                    ),
                  ),
                  items: displayLocations.map((loc) => DropdownMenuItem(
                      value: loc,
                      child: Text(loc, style: const TextStyle(color: Colors.white))
                  )).toList(),
                  onChanged: (val) => setState(() => selectedDisplayLocation = val!),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  dropdownColor: Colors.black,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: "Category",
                    labelStyle: TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: Colors.black,
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white54),
                    ),
                  ),
                  items: categories.map((cat) => DropdownMenuItem(
                      value: cat,
                      child: Text(cat, style: const TextStyle(color: Colors.white))
                  )).toList(),
                  onChanged: (val) => setState(() => selectedCategory = val!),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedRoadmap,
                  dropdownColor: Colors.black,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: "Software Dev Roadmap",
                    labelStyle: TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: Colors.black,
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white54),
                    ),
                  ),
                  items: roadmaps.map((map) => DropdownMenuItem(
                      value: map,
                      child: Text(map, style: const TextStyle(color: Colors.white))
                  )).toList(),
                  onChanged: (val) => setState(() => selectedRoadmap = val!),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Level Type:",
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => setState(() => selectedLevelType = "Low"),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            border: Border.all(
                              color: selectedLevelType == "Low" ? Colors.white : Colors.white54,
                              width: selectedLevelType == "Low" ? 2 : 1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Radio<String>(
                                value: "Low",
                                groupValue: selectedLevelType,
                                activeColor: Colors.white,
                                fillColor: MaterialStateProperty.resolveWith((states) => Colors.white),
                                onChanged: (val) => setState(() => selectedLevelType = val!),
                              ),
                              const Text(
                                "Low",
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: InkWell(
                        onTap: () => setState(() => selectedLevelType = "High"),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            border: Border.all(
                              color: selectedLevelType == "High" ? Colors.white : Colors.white54,
                              width: selectedLevelType == "High" ? 2 : 1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Radio<String>(
                                value: "High",
                                groupValue: selectedLevelType,
                                activeColor: Colors.white,
                                fillColor: MaterialStateProperty.resolveWith((states) => Colors.white),
                                onChanged: (val) => setState(() => selectedLevelType = val!),
                              ),
                              const Text(
                                "High",
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: const Text("Is Feature Option? (Like Code Lab)", style: TextStyle(color: Colors.white)),
                  value: isFeature,
                  activeColor: Colors.white,
                  onChanged: (val) => setState(() => isFeature = val),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                  ),
                  onPressed: _isLoading ? null : _saveModule,
                  child: _isLoading
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
                  )
                      : const Text("Save Module to Dashboard", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}