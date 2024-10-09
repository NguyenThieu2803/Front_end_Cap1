import 'package:flutter/material.dart';
import 'package:furnitureapp/translate/localization.dart';

class LanguagePage extends StatefulWidget {
  final Function(String) onLanguageChanged; // Callback for language change

  const LanguagePage({super.key, required this.onLanguageChanged});

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  String _selectedLanguage = 'English';
  bool _hasChanges = false;

  final List<String> _languages = [
    'Tiếng Việt',
    'English',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Language',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          TextButton(
            onPressed: _hasChanges
                ? () {
                    widget.onLanguageChanged(_selectedLanguage); 
                    setState(() => _hasChanges = false);
                    Navigator.pop(context);
                  }
                : null,
            child: Text(
              'Save',
              style: TextStyle(
                color: _hasChanges ? Colors.pink : Colors.grey,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.grey[100],
      body: Container(
        margin: const EdgeInsets.only(top: 1),
        child: ListView.builder(
          itemCount: _languages.length,
          itemBuilder: (context, index) {
            final language = _languages[index];
            return Container(
              color: Colors.white,
              child: ListTile(
                title: Text(
                  language,
                  style: const TextStyle(fontSize: 16),
                ),
                trailing: _selectedLanguage == language
                    ? const Icon(Icons.check, color: Colors.black)
                    : null,
                onTap: () {
                  if (_selectedLanguage != language) {
                    setState(() {
                      _selectedLanguage = language;
                      _hasChanges = true;
                    });
                  }
                },
              ),
            );
          },
        ),
      ),
    );
  }
}