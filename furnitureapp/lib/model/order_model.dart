import 'product.dart'; // Import the Product model
import 'address_model.dart'; // Import the AddressUser model

class Order {
  final bool success;
  final String message;
  final List<OrderData> data;

  Order({
    required this.success,
    required this.message,
    required this.data,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      success: json['success'],
      message: json['message'],
      data: (json['data'] as List)
          .map((orderData) => OrderData.fromJson(orderData))
          .toList(),
    );
  }
}

class OrderData {
  final String id;
  final String userId;
  final List<ProductOrder> products;
  final double totalAmount;
  final String? transactionId;
  final bool waitingConfirmation;
  final String paymentStatus;
  final String deliveryStatus;
  final AddressUser shippingAddress;
  final String paymentMethod;
  final DateTime orderDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  OrderData({
    required this.id,
    required this.userId,
    required this.products,
    required this.totalAmount,
    this.transactionId,
    required this.waitingConfirmation,
    required this.paymentStatus,
    required this.deliveryStatus,
    required this.shippingAddress,
    required this.paymentMethod,
    required this.orderDate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OrderData.fromJson(Map<String, dynamic> json) {
    return OrderData(
      id: json['_id'],
      userId: json['user_id'],
      products: (json['products'] as List)
          .map((product) => ProductOrder.fromJson(product))
          .toList(),
      totalAmount: (json['total_amount'] as num).toDouble(),
      transactionId: json['transaction_id'],
      waitingConfirmation: json['waiting_confirmation'],
      paymentStatus: json['payment_status'],
      deliveryStatus: json['delivery_status'],
      shippingAddress: AddressUser.fromJson(json['shipping_address']),
      paymentMethod: json['payment_method'],
      orderDate: DateTime.parse(json['order_date']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class ProductOrder {
  final Product product;
  final double amount;
  final int quantity;
  final String id;

  ProductOrder({
    required this.product,
    required this.amount,
    required this.quantity,
    required this.id,
  });

  factory ProductOrder.fromJson(Map<String, dynamic> json) {
    return ProductOrder(
      product: Product.fromJson(json['product']),
      amount: (json['amount'] as num).toDouble(),
      quantity: json['quantity'],
      id: json['_id'],
    );
  }
}