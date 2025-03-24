import 'package:flutter/material.dart';
import '../screens/question_detail_page.dart';

class QuestionCard extends StatelessWidget {
  final Map<String, dynamic> questionData;

  QuestionCard({required this.questionData});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  QuestionDetailPage(questionData: questionData),
            ),
          );
        },
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.green.shade300,
                    child: Text(
                      questionData['author'][0],
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    questionData['author'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                questionData['title'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.green.shade700,
                ),
              ),
              SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  questionData['imageUrl'],
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: questionData['tags']
                    .map<Widget>((tag) => Chip(
                  label: Text(tag),
                  backgroundColor: Colors.green.shade100,
                ))
                    .toList(),
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      // Handle upvote
                    },
                    icon: Icon(Icons.thumb_up_alt_outlined),
                    label: Text('${questionData['upvotes']}'),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      // Handle comment
                    },
                    icon: Icon(Icons.comment_outlined),
                    label: Text('${questionData['commentsCount']}'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
