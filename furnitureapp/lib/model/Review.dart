class Review {
  final String avatarUrl;
  final String name;
  final int rating;
  final String color;
  final String comment;
  final List<String> images;

  Review({
    required this.avatarUrl,
    required this.name,
    required this.rating,
    required this.color,
    required this.comment,
    required this.images,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      avatarUrl: json['avatarUrl'] as String,
      name: json['name'] as String,
      rating: json['rating'] as int,
      color: json['color'] as String,
      comment: json['comment'] as String,
      images: List<String>.from(json['images'] as List),
    );
  }
}
