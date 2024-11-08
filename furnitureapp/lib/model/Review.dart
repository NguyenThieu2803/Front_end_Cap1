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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['rating'] = this.rating;
    data['comment'] = this.comment;
    data['review_date'] = this.reviewDate;
    data['images'] = this.images;
    data['user_name'] = this.userName;
    data['user_email'] = this.userEmail;
    return data;
  }
}