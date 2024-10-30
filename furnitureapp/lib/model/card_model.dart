class CardModel {
  final String id;
  final String cardHolderName;
  final String cardNumber;
  final String expiryMonth;
  final String expiryYear;
  final String cardType;

  CardModel({
    required this.id,
    required this.cardHolderName,
    required this.cardNumber,
    required this.expiryMonth,
    required this.expiryYear,
    required this.cardType,
  });

  String get lastFourDigits => cardNumber.length >= 4
      ? cardNumber.substring(cardNumber.length - 4)
      : '****';

  factory CardModel.fromJson(Map<String, dynamic> json) {
    return CardModel(
      id: json['_id'] ?? '',
      cardHolderName: json['Card_name'] ?? '',
      cardNumber: json['Cardnumber'] ?? '',
      expiryMonth: json['cardExpmonth'] ?? '',
      expiryYear: json['cardExpyears'] ?? '',
      cardType: json['cardType'] ?? '',
    );
  }
}
