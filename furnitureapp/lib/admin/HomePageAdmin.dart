import 'package:flutter/material.dart';
import 'package:furnitureapp/admin/AdminPage.dart';
import 'package:furnitureapp/pages/CartPage.dart';
import 'package:furnitureapp/pages/FavoritePage.dart';
import 'package:furnitureapp/pages/UserProfilePage.dart';
import 'package:furnitureapp/widgets/CategoriesWidget.dart';
import 'package:furnitureapp/widgets/HomeAdminNavigationBar.dart';
import 'package:furnitureapp/widgets/HomeAppBar.dart';
import 'package:furnitureapp/widgets/HomeItemsWidget.dart';
import 'package:furnitureapp/model/Categories.dart';

class HomePageAdmin extends StatefulWidget {
  const HomePageAdmin({super.key});

  @override
  _HomePageAdminState createState() => _HomePageAdminState();
}

class _HomePageAdminState extends State<HomePageAdmin> {
  int _selectedIndex = 0;
  String _selectedCategory = 'All Product';

  // Không nên bao gồm HomePageAdmin trong danh sách các trang
  final List<Widget> _pages = [
    // Nếu cần có trang khác thì thêm vào đây
    CartPage(),
    AdminPage(),
    FavoritePage(),
    UserProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _selectedIndex == 0
          ? HomeContent(
              selectedCategory: _selectedCategory,
              onCategorySelected: _onCategorySelected,
            )
          : _pages[_selectedIndex - 1], // Giảm chỉ số đi 1 để phù hợp với danh sách trang
      bottomNavigationBar: HomeAdminNavigationBar(
        selectedIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  final String selectedCategory;
  final Function(String) onCategorySelected;

  const HomeContent({super.key, required this.selectedCategory, required this.onCategorySelected});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                HomeAppBar(
                  onFiltersApplied: (String? category, double? minPrice, double? maxPrice) {
                    if (category != null) {
                      onCategorySelected(category);
                    }
                  },
                ),
                Container(
                  padding: EdgeInsets.only(top: 15),
                  decoration: BoxDecoration(
                    color: Color(0xFFEDECF2),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(35),
                      topRight: Radius.circular(35),
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Search here...",
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.search,
                                size: 27,
                                color: Color(0xFF2B2321),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                        child: Text(
                          "Categories",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2B2321),
                          ),
                        ),
                      ),
                      CategoriesWidget(
                        selectedCategory: selectedCategory,
                        onCategorySelected: onCategorySelected,
                      ),
                      SizedBox(height: 20),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "Best Selling",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2B2321),
                          ),
                        ),
                      ),
                      HomeItemsWidget(selectedCategory: selectedCategory),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
