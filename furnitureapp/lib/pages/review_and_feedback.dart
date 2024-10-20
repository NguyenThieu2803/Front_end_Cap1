// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

// class ProductPage extends StatefulWidget {
//   final product; // Nhận một đối tượng Product

//   const ProductPage({super.key, required this.product}); // Constructor

//   @override
//   _ProductPageState createState() => _ProductPageState();
// }

// class _ProductPageState extends State<ProductPage> {
//   int quantity = 1;
//   double rating = 4; // Bạn có thể thay đổi theo yêu cầu của mình
//   bool isFavorite = false;

//   List<Map<String, dynamic>> favoriteProducts = [];
//   List<Map<String, dynamic>> customerReviews = [
//     {
//       'name': 'Nguyen Van A',
//       'rating': 5,
//       'review': 'Sản phẩm tuyệt vời, rất đáng tiền!',
//     },
//     {
//       'name': 'Tran Thi B',
//       'rating': 4,
//       'review': 'Chất lượng ổn, sẽ mua lần sau.',
//     },
//     {
//       'name': 'Le Van C',
//       'rating': 3,
//       'review': 'Cũng bình thường, chưa thật sự hài lòng.',
//     },
//   ];

//   // Biến để lưu thông tin đánh giá từ form
//   final _reviewController = TextEditingController();
//   final _nameController = TextEditingController();
//   double _userRating = 5;

//   void increaseQuantity() {
//     setState(() {
//       quantity++;
//     });
//   }

//   void decreaseQuantity() {
//     if (quantity > 1) {
//       setState(() {
//         quantity--;
//       });
//     }
//   }

//   void toggleFavorite() {
//     setState(() {
//       isFavorite = !isFavorite;
//       if (isFavorite) {
//         // Thêm sản phẩm vào danh sách yêu thích
//         favoriteProducts.add({
//           'name': widget.product.name,
//           'image': widget.product.image,
//           'price': widget.product.price,
//           'quantity': quantity,
//         });
//       } else {
//         // Xóa sản phẩm khỏi danh sách yêu thích
//         favoriteProducts.removeWhere((p) => p['name'] == widget.product.name);
//       }
//     });
//   }

//   // Hàm xử lý khi gửi đánh giá
//   void submitReview() {
//     if (_nameController.text.isNotEmpty && _reviewController.text.isNotEmpty) {
//       setState(() {
//         customerReviews.add({
//           'name': _nameController.text,
//           'rating': _userRating,
//           'review': _reviewController.text,
//         });
//         _nameController.clear();
//         _reviewController.clear();
//         _userRating = 5; // Đặt lại đánh giá mặc định
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;

//     return Scaffold(
//       backgroundColor: const Color(0xFFF2F2F7),
//       appBar: AppBar(
//         toolbarHeight: 80, // Tăng chiều cao của AppBar
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           iconSize: 30,
//           color: const Color(0xFF2B2321),
//           onPressed: () {
//             Navigator.pop(context); // Quay lại trang trước
//           },
//         ),
//         title: const Text(
//           'Product',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 23,
//             color: Color(0xFF2B2321),
//           ),
//         ),
//         actions: [
//           Padding(
//             padding: const EdgeInsets.only(right: 16.0), // Thêm khoảng cách bên phải
//             child: IconButton(
//               icon: Icon(
//                 isFavorite ? Icons.favorite : Icons.favorite_border,
//                 color: isFavorite ? Colors.red : Colors.black,
//               ),
//               iconSize: 30,
//               onPressed: toggleFavorite,
//             ),
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   // Phần thông tin sản phẩm ở đây
//                   const SizedBox(height: 20), // Tạo khoảng trống trước phần đánh giá
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                     child: Container(
//                       color: Colors.grey[100],
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Text(
//                             'Customer Reviews',
//                             style: TextStyle(
//                               fontSize: 22,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           const SizedBox(height: 10),
//                           Column(
//                             children: customerReviews.map((review) {
//                               return Padding(
//                                 padding: const EdgeInsets.only(bottom: 10.0),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Row(
//                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Text(
//                                           review['name'],
//                                           style: const TextStyle(
//                                             fontSize: 16,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                         Row(
//                                           children: List.generate(5, (index) {
//                                             return Icon(
//                                               index < review['rating']
//                                                   ? Icons.star
//                                                   : Icons.star_border,
//                                               color: Colors.black,
//                                               size: 15,
//                                             );
//                                           }),
//                                         ),
//                                       ],
//                                     ),
//                                     const SizedBox(height: 5),
//                                     Text(
//                                       review['review'],
//                                       style: const TextStyle(
//                                         fontSize: 14,
//                                         fontStyle: FontStyle.italic,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               );
//                             }).toList(),
//                           ),
//                           const SizedBox(height: 20),
//                           const Text(
//                             'Write a Review',
//                             style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           const SizedBox(height: 10),
//                           TextField(
//                             controller: _nameController,
//                             decoration: const InputDecoration(
//                               labelText: 'Your Name',
//                               border: OutlineInputBorder(),
//                             ),
//                           ),
//                           const SizedBox(height: 10),
//                           Row(
//                             children: [
//                               const Text(
//                                 'Your Rating:',
//                                 style: TextStyle(fontSize: 16),
//                               ),
//                               const SizedBox(width: 10),
//                               DropdownButton<double>(
//                                 value: _userRating,
//                                 items: [1, 2, 3, 4, 5]
//                                     .map((e) => DropdownMenuItem(
//                                           value: e.toDouble(),
//                                           child: Text(e.toString()),
//                                         ))
//                                     .toList(),
//                                 onChanged: (value) {
//                                   setState(() {
//                                     _userRating = value!;
//                                   });
//                                 },
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 10),
//                           TextField(
//                             controller: _reviewController,
//                             maxLines: 3,
//                             decoration: const InputDecoration(
//                               labelText: 'Your Review',
//                               border: OutlineInputBorder(),
//                             ),
//                           ),
//                           const SizedBox(height: 10),
//                           ElevatedButton(
//                             onPressed: submitReview,
//                             child: const Text('Submit Review'),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 80), // Tạo khoảng trống dưới
//                 ],
//               ),
//             ),
//           ),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
//             color: Colors.white,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   '${(widget.product.price * quantity).toStringAsFixed(0)}\$',
//                   style: const TextStyle(
//                     fontSize: 30,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 ElevatedButton.icon(
//                   onPressed: () {},
//                   style: ElevatedButton.styleFrom(
//                     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//                     backgroundColor: Colors.black,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(30),
//                     ),
//                   ),
//                   icon: const Icon(
//                     Icons.shopping_cart,
//                     color: Colors.white, // Thay đổi màu của icon thành trắng
//                   ),
//                   label: const Text(
//                     'Add To Cart',
//                     style: TextStyle(
//                       fontSize: 18,
//                       color: Colors.white, // Thay đổi màu chữ thành trắng
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
