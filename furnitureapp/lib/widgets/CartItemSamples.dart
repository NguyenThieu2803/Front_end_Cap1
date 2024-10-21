import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:furnitureapp/api/api.service.dart';
import 'package:furnitureapp/model/Cart_User_Model.dart';
import 'package:furnitureapp/services/data_service.dart';

class CartItemSamples extends StatefulWidget {
  final Function(double) onTotalPriceChanged;

  const CartItemSamples({super.key, required this.onTotalPriceChanged});

  @override
  _CartItemSamplesState createState() => _CartItemSamplesState();
}

class _CartItemSamplesState extends State<CartItemSamples> {
  Cart? cart;
  bool isLoading = true;
  Set<String> selectedProductIds = {}; // To track selected checkboxes
  bool isAllSelected = false; // Track the state of the "Select All" checkbox

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
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Checkbox(
              value: isAllSelected,
              activeColor: Color(0xFF2B2321),
              onChanged: (bool? value) {
                setState(() {
                  isAllSelected = value ?? false;
                  if (isAllSelected) {
                    selectedProductIds = cart!.items!.map((item) => item.id!).toSet();
                  } else {
                    selectedProductIds.clear();
                  }
                  _updateTotalPrice();
                });
              },
            ),
            Text(
              "Select All",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2B2321),
              ),
            ),
          ],
        ),
        Column(
          children: cart!.items!.map((item) => buildCartItem(item)).toList(),
        ),
      ],
    );
  }

  Widget buildCartItem(CartItem item) {
    return LayoutBuilder(
      builder: (context, constraints) {
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
              Checkbox(
                value: selectedProductIds.contains(item.id),
                activeColor: Color(0xFF2B2321),
                onChanged: (bool? value) {
                  setState(() {
                    if (value == true) {
                      selectedProductIds.add(item.id!);
                    } else {
                      selectedProductIds.remove(item.id);
                    }
                    _updateTotalPrice();
                  });
                },
              ),
              Container(
                height: 70,
                width: 70,
                margin: EdgeInsets.only(right: 15),
                child: FadeInImage.assetNetwork(
                  placeholder: "assets/images/placeholder.png",
                  image: item.product?.images?.first ?? "",
                  imageErrorBuilder: (context, error, stackTrace) {
                    return Image.asset("assets/images/placeholder.png");
                  },
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                child: Padding(
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
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 9),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () async {
                        bool success = await APIService.deleteCartItem(item.product?.id ?? '');
                        if (success) {
                          setState(() {
                            cart!.items!.remove(item);
                          });
                          _updateTotalPrice();
                        }
                      },
                      child: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    ),
                    Row(
                      children: [
                        InkWell(
                          onTap: () async {
                            int newQuantity = (item.quantity ?? 0) + 1;
                            bool success = await APIService.updateCartItem(item.product?.id ?? '', newQuantity);
                            if (success) {
                              setState(() {
                                item.quantity = newQuantity;
                              });
                              _updateTotalPrice();
                            }
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
                          onTap: () async {
                            if ((item.quantity ?? 0) > 1) {
                              int newQuantity = (item.quantity ?? 0) - 1;
                              bool success = await APIService.updateCartItem(item.product?.id ?? '', newQuantity);
                              if (success) {
                                setState(() {
                                  item.quantity = newQuantity;
                                });
                                _updateTotalPrice();
                              }
                            }
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
      },
    );
  }

  double calculateTotalPrice() {
    if (cart == null || cart!.items == null) return 0.0;
    return cart!.items!.fold(0.0, (sum, item) {
      if (selectedProductIds.contains(item.id)) {
        return sum + (item.price ?? 0) * (item.quantity ?? 0);
      }
      return sum;
    });
  }
}
