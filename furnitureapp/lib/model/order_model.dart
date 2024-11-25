import 'product.dart'; // Import the Product model
import 'address_model.dart'; // Import the AddressUser model
import 'dart:convert';

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
    try {
      return Order(
        success: json['success'] ?? false,
        message: json['message'] ?? '',
        data: ((json['data'] as List?) ?? [])
            .map((orderData) => OrderData.fromJson(orderData))
            .toList(),
      );
    } catch (e) {
      print('Error parsing Order: $e');
      rethrow;
    }
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
    try {
      print("Parsing OrderData from JSON: $json"); // Debug log
      
      // Parse shipping address
      Map<String, dynamic> shippingAddressData = {};
      if (json['shipping_address'] != null) {
        if (json['shipping_address'] is String) {
          try {
            shippingAddressData = jsonDecode(json['shipping_address']);
          } catch (e) {
            print("Error parsing shipping_address string: $e");
            shippingAddressData = {};
          }
        } else if (json['shipping_address'] is Map) {
          shippingAddressData = Map<String, dynamic>.from(json['shipping_address']);
        }
      }

      return OrderData(
        id: json['_id']?.toString() ?? '',
        userId: json['user_id']?.toString() ?? '',
        products: ((json['products'] as List?) ?? [])
            .map((product) => ProductOrder.fromJson(product))
            .toList(),
        totalAmount: (json['total_amount'] is num)
            ? (json['total_amount'] as num).toDouble()
            : double.tryParse(json['total_amount']?.toString() ?? '0') ?? 0.0,
        transactionId: json['transaction_id']?.toString(),
        waitingConfirmation: json['waiting_confirmation'] ?? false,
        paymentStatus: json['payment_status']?.toString() ?? '',
        deliveryStatus: json['delivery_status']?.toString() ?? '',
        shippingAddress: AddressUser.fromJson(shippingAddressData),
        paymentMethod: json['payment_method']?.toString() ?? '',
        orderDate: DateTime.tryParse(json['order_date']?.toString() ?? '') ?? DateTime.now(),
        createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ?? DateTime.now(),
        updatedAt: DateTime.tryParse(json['updatedAt']?.toString() ?? '') ?? DateTime.now(),
      );
    } catch (e) {
      print('Error parsing OrderData: $e');
      print('Problematic JSON: $json');
      rethrow;
    }
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
    try {
      print("Parsing ProductOrder from JSON: $json"); // Debug log
      return ProductOrder(
        product: Product.fromJson(json['product'] is String 
            ? jsonDecode(json['product']) 
            : (json['product'] ?? {})),
        amount: (json['amount'] is num)
            ? (json['amount'] as num).toDouble()
            : double.tryParse(json['amount']?.toString() ?? '0') ?? 0.0,
        quantity: (json['quantity'] is num)
            ? (json['quantity'] as num).toInt()
            : int.tryParse(json['quantity']?.toString() ?? '0') ?? 0,
        id: json['_id']?.toString() ?? '',
      );
    } catch (e) {
      print('Error parsing ProductOrder: $e');
      print('Problematic JSON: $json');
      rethrow;
    }
  }
}