class Review {
  final String id;
  final String userName;
  final String userImage;
  final int rating;
  final String comment;
  final int likes;
  final String date;

  Review({
    required this.id,
    required this.userName,
    required this.userImage,
    required this.rating,
    required this.comment,
    required this.likes,
    required this.date,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      userName: json['user_name'],
      userImage: json['user_image'],
      rating: json['rating'],
      comment: json['comment'],
      likes: json['likes'],
      date: json['date'],
    );
  }
}
