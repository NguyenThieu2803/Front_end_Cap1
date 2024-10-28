class Address {
  final String id;
  final String userId;
  final String fullName;
  final String phoneNumber;
  final String streetAddress;
  final String district;
  final String ward;
  final String commune; // Add commune field
  final String city;
  final String province;
  bool isDefault; // Change from final to mutable

  Address({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.phoneNumber,
    required this.streetAddress,
    required this.district,
    required this.ward,
    required this.commune, // Add commune field
    required this.city,
    required this.province,
    this.isDefault = false, // Provide a default value
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['_id'] ?? '', // Provide a default value
      userId: json['user_id'] ?? '', // Provide a default value
      fullName: json['name'] ?? '', // Provide a default value
      phoneNumber: json['phone'] ?? '', // Provide a default value
      streetAddress: json['street'] ?? '', // Provide a default value
      district: json['district'] ?? '', // Provide a default value
      ward: json['ward'] ?? '', // Provide a default value
      commune: json['commune'] ?? '', // Provide a default value
      city: json['city'] ?? '', // Provide a default value
      province: json['province'] ?? '', // Provide a default value
      isDefault: json['isDefault'] ?? false,
    );
  }
}
