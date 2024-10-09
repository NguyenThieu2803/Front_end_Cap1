class Address {
  final String fullName;
  final String phoneNumber;
  final String streetAddress;
  final String province;
  final String district;
  final String commune;
  bool isDefault;

  Address({
    required this.fullName,
    required this.phoneNumber,
    required this.streetAddress,
    required this.province,
    required this.district,
    required this.commune,
    this.isDefault = false,
  });
}