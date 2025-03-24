import 'package:flutter/material.dart';

class AddQuestionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ask a Question'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Question',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                // Implement image upload
              },
              icon: Icon(Icons.image),
              label: Text('Upload Image'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Save question logic
              },
              child: Text('Submit Question'),
            ),
          ],
        ),
      ),
    );
  }
}
