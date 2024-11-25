class Review {
  String? id;
  int? rating;
  String? comment;
  String? reviewDate;
  List<String>? images;
  String? userName;
  String? userEmail;

  Review(
      {this.id,
      this.rating,
      this.comment,
      this.reviewDate,
      this.images,
      this.userName,
      this.userEmail});

  Review.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    rating = json['rating'];
    comment = json['comment'];
    reviewDate = json['review_date'];
    images = json['images'].cast<String>();
    userName = json['user_name'];
    userEmail = json['user_email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['rating'] = rating;
    data['comment'] = comment;
    data['review_date'] = reviewDate;
    data['images'] = images;
    data['user_name'] = userName;
    data['user_email'] = userEmail;
    return data;
  }
}