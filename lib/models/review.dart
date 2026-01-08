class Review {
  final String id;
  final String author;
  final double rating;
  final String tags;
  final String content;
  final DateTime createdAt;

  const Review({
    required this.id,
    required this.author,
    required this.rating,
    required this.tags,
    required this.content,
    required this.createdAt,
  });
}
