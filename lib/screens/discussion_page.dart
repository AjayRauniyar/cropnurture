import 'package:flutter/material.dart';
import '../widgets/question_card.dart';
import 'add_question_page.dart';

class DiscussionPage extends StatelessWidget {
  final List<Map<String, dynamic>> sampleQuestions = [
    {
      "id": "1",
      "title": "What is this pest on my wheat?",
      "author": "Farmer John",
      "imageUrl": "https://via.placeholder.com/150",
      "upvotes": 24,
      "commentsCount": 8,
      "tags": ["Wheat", "Pests"],
    },
    {
      "id": "2",
      "title": "How to prevent overwatering in rice?",
      "author": "Farmer Jane",
      "imageUrl": "https://via.placeholder.com/150",
      "upvotes": 15,
      "commentsCount": 5,
      "tags": ["Rice", "Watering"],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(
          'Farmers’ Forum',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              _showFilterOptions(context);
            },
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Implement search functionality
            },
          ),
        ],
        backgroundColor: Colors.green.shade700,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: ListView.builder(
          itemCount: sampleQuestions.length,
          itemBuilder: (context, index) {
            return QuestionCard(questionData: sampleQuestions[index]);
          },
        ),
      ),
      floatingActionButton: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green.shade600,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddQuestionPage()),
          );
        },
        icon: Icon(Icons.add),
        label: Text('Ask a Question'),
      ),

    );
  }

  void _showFilterOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.trending_up),
                title: Text('Most Upvoted'),
                onTap: () {
                  // Sort by upvotes
                },
              ),
              ListTile(
                leading: Icon(Icons.access_time),
                title: Text('Recent'),
                onTap: () {
                  // Sort by recent
                },
              ),
              ListTile(
                leading: Icon(Icons.question_answer),
                title: Text('Unanswered'),
                onTap: () {
                  // Filter unanswered questions
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
