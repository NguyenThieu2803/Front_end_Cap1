class Categories {
  String? id;
  String? name;
  String? description;
  List<String>? images;

  Categories({
    this.id,
    this.name,
    this.description,
    this.images,
  });

  Categories.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
    description = json['description'];
    images = json['images'] != null ? List<String>.from(json['images']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['images'] = images;
    return data;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Categories &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => name ?? 'Unknown Category';
}
