import 'package:flutter/material.dart';

class QuestionDetailPage extends StatelessWidget {
  final Map<String, dynamic> questionData;

  QuestionDetailPage({required this.questionData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Question Details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              questionData['title'],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 8),
            Image.network(questionData['imageUrl']),
            SizedBox(height: 16),
            Text(
              'Answers',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            // Add logic to list answers here
          ],
        ),
      ),
    );
  }
}
