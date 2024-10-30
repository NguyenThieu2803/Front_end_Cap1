class Categories {
  String id;
  String name;
  // ... các trường khác nếu có

  Categories({
    required this.id,
    required this.name,
    // ... các tham số khác nếu có
  });

  factory Categories.fromJson(Map<String, dynamic> json) {
    return Categories(
      id: json['_id'] is Map ? json['_id']['$oid'] : json['_id'],
      name: json['name'],
      // ... các trường khác nếu có
    );
  }
}
