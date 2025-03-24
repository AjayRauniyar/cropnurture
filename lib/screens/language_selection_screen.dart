import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import '../providers/language_provider.dart';

class LanguageSelectionScreen extends StatelessWidget {
  final List<String> languages = [
    "English",
    "Hindi",
    "Tamil",
    "Telugu",
    "Kannada",
    "Malayalam",
    "Bengali",
    "Punjabi",
    "Gujarati",
  ];

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green.shade200, Colors.green.shade700],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 60),
            Center(
              child: Image.asset(
                'assets/images/farmer.jpg',
                height: 150,
              ),
            ),
            SizedBox(height: 20),
            AnimatedTextKit(
              animatedTexts: [
                TyperAnimatedText(
                  'Select Your Language',
                  textStyle: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
              isRepeatingAnimation: false,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: languages.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      languageProvider.setLanguage(languages[index]);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                          "${languages[index]} selected",
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.green,
                      ));
                    },
                    child: Card(
                      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                        child: Row(
                          children: [
                            Icon(Icons.language, color: Colors.green),
                            SizedBox(width: 15),
                            Text(
                              languages[index],
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: FloatingActionButton.extended(
                onPressed: () {
                  languageProvider.startListening((command) {
                    if (languages.contains(command)) {
                      languageProvider.setLanguage(command);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                          "$command selected via voice",
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.green,
                      ));
                    }
                  });
                },
                label: Text(languageProvider.isListening ? "Listening..." : "Use Voice"),
                icon: Icon(
                  languageProvider.isListening ? Icons.mic : Icons.mic_none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
