import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:furnitureapp/model/Cart_User_Model.dart';
import 'package:furnitureapp/services/data_service.dart';

class CartItemSamples extends StatefulWidget {
  final Function(double) onTotalPriceChanged;

  const CartItemSamples({Key? key, required this.onTotalPriceChanged}) : super(key: key);

  @override
  _CartItemSamplesState createState() => _CartItemSamplesState();
}

class _CartItemSamplesState extends State<CartItemSamples> {
  Cart? cart;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadCart();
  }

  Future<void> loadCart() async {
    DataService dataService = DataService();
    Cart? loadedCart = await dataService.loadCart();
    setState(() {
      cart = loadedCart;
      isLoading = false;
    });
    _updateTotalPrice();
  }

  void _updateTotalPrice() {
    double totalPrice = calculateTotalPrice();
    widget.onTotalPriceChanged(totalPrice);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (cart == null || cart!.items == null || cart!.items!.isEmpty) {
      return Center(child: Text("Your cart is empty"));
    }

    return Column(
      children: cart!.items!.map((item) => buildCartItem(item)).toList(),
    );
  }

  Widget buildCartItem(CartItem item) {
    return Container(
      height: 110,
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Radio(
            value: "",
            groupValue: "",      
            activeColor: Color(0xFF2B2321),
            onChanged: (index) {},
          ),
          Container(
            height: 70,
            width: 70,
            margin: EdgeInsets.only(right: 15),
            child: Image.network(item.product?.images?.first ?? "assets/images/placeholder.png"),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item.name ?? "Unknown Product",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2B2321),      
                  ),
                ),
                Text(
                  "\$${item.price?.toStringAsFixed(2) ?? '0.00'}",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2B2321),                              
                  ),
                ),
              ],
            ),
          ),
          Spacer(),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 9),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      cart!.items!.remove(item);
                    });
                  },
                  child: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          item.quantity = (item.quantity ?? 0) + 1;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Icon(
                          CupertinoIcons.plus,
                          size: 15,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        "${item.quantity ?? 0}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2B2321),                              
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          if ((item.quantity ?? 0) > 1) {
                            item.quantity = (item.quantity ?? 0) - 1;
                          }
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Icon(
                          CupertinoIcons.minus,
                          size: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  double calculateTotalPrice() {
    if (cart == null || cart!.items == null) return 0.0;
    return cart!.items!.fold(0.0, (sum, item) => sum + (item.price ?? 0) * (item.quantity ?? 0));
  }
}
