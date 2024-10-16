import 'package:flutter/material.dart';

class OrderNotification {
  final String orderCode;
  final String message;
  final String imageUrl;

  OrderNotification({
    required this.orderCode,
    required this.message,
    required this.imageUrl,
  });
}

class MessageNotification {
  final String storeName;
  final String message;
  final String imageUrl;
  final String date;

  MessageNotification({
    required this.storeName,
    required this.message,
    required this.imageUrl,
    required this.date,
  });
}

class NotificationItemSamples extends StatefulWidget {
  const NotificationItemSamples({super.key});

  @override
  _NotificationItemSamplesState createState() => _NotificationItemSamplesState();
}

class _NotificationItemSamplesState extends State<NotificationItemSamples> {
  final List<OrderNotification> orders = [
    OrderNotification(
      orderCode: "024332323",
      message: "Cảm ơn bạn đã mua sắm cùng FurniFit AR",
      imageUrl: "assets/images/1.png",
    ),
    OrderNotification(
      orderCode: "012334555",
      message: "Cảm ơn bạn đã mua sắm cùng FurniFit AR",
      imageUrl: "assets/images/2.png",
    ),
    OrderNotification(
      orderCode: "23923232",
      message: "Cảm ơn bạn đã mua sắm cùng FurniFit AR",
      imageUrl: "assets/images/3.png",
    ),
  ];

  final List<MessageNotification> messages = [
    MessageNotification(
      storeName: "Nội Thất Việt Đức Việt Nam",
      message: "Ưu đãi đặc biệt chỉ dành cho bạn!",
      imageUrl: "assets/images/logo_1.png",
      date: "3 ngày trước",
    ),
    MessageNotification(
      storeName: "DecoFuni",
      message: "Chiếc khấu đặc biệt chỉ dành cho bạn!",
      imageUrl: "assets/images/logo_2.png",
      date: "20-8",
    ),
    MessageNotification(
      storeName: "AConcept Việt Nam",
      message: "Ưu đãi đặc biệt chỉ dành cho bạn!",
      imageUrl: "assets/images/logo_3.png",
      date: "10-7",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Orders Section
        Container(
          padding: EdgeInsets.all(16),
          child: Column(
            children: orders.map((order) => _buildOrderItem(order)).toList(),
          ),
        ),
        
        // Message Header
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Message',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        
        // Messages Section
        Container(
          child: Column(
            children: messages.map((message) => _buildMessageItem(message)).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildOrderItem(OrderNotification order) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: Colors.black),
            ),
            child: Icon(Icons.shopping_bag_rounded, color: Colors.black, size: 37),
          ),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Đơn hàng đã được đặt',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('Mã hàng ${order.orderCode}'),
                Text(order.message),
              ],
            ),
          ),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(order.imageUrl, fit: BoxFit.cover),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageItem(MessageNotification message) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 13),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundImage: AssetImage(message.imageUrl),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message.storeName,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(message.message),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                message.date,
                style: TextStyle(color: Colors.grey),
              ),
              Container(
                width: 10,
                height: 18,
                margin: EdgeInsets.only(top: 4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}