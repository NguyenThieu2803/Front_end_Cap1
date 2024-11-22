class AddressUser {
  final String id;
  final String userId;
  final String fullName;
  final String phoneNumber;
  final String streetAddress;
  final String district;
  final String ward;
  final String commune;
  final String city;
  final String province;
  bool isDefault;

  AddressUser({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.phoneNumber,
    required this.streetAddress,
    required this.district,
    required this.ward,
    required this.commune,
    required this.city,
    required this.province,
    this.isDefault = false,
  });

  factory AddressUser.fromJson(Map<String, dynamic> json) {
    return AddressUser(
      id: json['_id'] ?? '',
      userId: json['user_id'] ?? '',
      fullName: json['name'] ?? '',
      phoneNumber: json['phone'] ?? '',
      streetAddress: json['street'] ?? '',
      district: json['district'] ?? '',
      ward: json['ward'] ?? '',
      commune: json['commune'] ?? '',
      city: json['city'] ?? '',
      province: json['province'] ?? '',
      isDefault: json['isDefault'] ?? false,
    );
  }

  String get fullAddress => '$streetAddress, $ward, $district, $city, $province';
}
