class Question {
  final String id;
  final String title;
  final String imageUrl;
  final int upvotes;
  final int commentsCount;
  final List<String> tags;

  Question({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.upvotes,
    required this.commentsCount,
    required this.tags,
  });
}
