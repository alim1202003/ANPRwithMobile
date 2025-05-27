import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isDarkMode = false;
  String selectedLanguage = 'Türkçe';

  final List<String> languages = ['Türkçe', 'English', 'Deutsch'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.grey[300],
      appBar: AppBar(
        title: Text(
          'Ayarlar',
          style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
        ),
        backgroundColor: isDarkMode ? Colors.grey[900] : Colors.grey[300],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Dark Mode Ayarı
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              color: isDarkMode ? Colors.grey[800] : Colors.white,
              child: ListTile(
                leading: Icon(
                  Icons.dark_mode,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
                title: Text(
                  'Karanlık Mod',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                trailing: Switch(
                  value: isDarkMode,
                  onChanged: (value) {
                    setState(() {
                      isDarkMode = value;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Dil Değişimi Ayarı
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              color: isDarkMode ? Colors.grey[800] : Colors.white,
              child: ListTile(
                leading: Icon(
                  Icons.language,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
                title: Text(
                  'Dil',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                trailing: DropdownButton<String>(
                  value: selectedLanguage,
                  dropdownColor: isDarkMode ? Colors.grey[800] : Colors.white,
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                  underline: Container(), // Alt çizgiyi gizle
                  iconEnabledColor: isDarkMode ? Colors.white : Colors.black,
                  items:
                      languages
                          .map(
                            (lang) => DropdownMenuItem(
                              value: lang,
                              child: Text(lang),
                            ),
                          )
                          .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedLanguage = value!;
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
