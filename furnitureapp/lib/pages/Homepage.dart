import 'package:flutter/material.dart';
import 'package:furnitureapp/pages/CartPage.dart';
import 'package:furnitureapp/pages/FavoritePage.dart';
import 'package:furnitureapp/pages/UserProfilePage.dart';
import 'package:furnitureapp/widgets/CategoriesWidget.dart';
import 'package:furnitureapp/widgets/HomeAppBar.dart';
import 'package:furnitureapp/widgets/HomeItemsWidget.dart';
import 'package:furnitureapp/widgets/HomeNavigationBar.dart';
import 'package:furnitureapp/model/Categories.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  String _selectedCategory = 'All Product';
  double? _minPrice;
  double? _maxPrice;

  // Không nên bao gồm HomePage trong danh sách các trang
  final List<Widget> _pages = [
    CartPage(),
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

  void _onFiltersApplied(String? category, double? minPrice, double? maxPrice) {
    setState(() {
      if (category != null) _selectedCategory = category;
      _minPrice = minPrice;
      _maxPrice = maxPrice;
    });
  }

  @override
  void initState() {
    super.initState();
    // Đảm bảo load tất cả sản phẩm khi khởi động
    _onCategorySelected('All Product');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _selectedIndex == 0
          ? HomeContent(
              selectedCategory: _selectedCategory,
              minPrice: _minPrice,
              maxPrice: _maxPrice,
              onFiltersApplied: _onFiltersApplied,
            )
          : _pages[_selectedIndex - 1], // Giảm chỉ số để truy cập đúng trang
      bottomNavigationBar: HomeNavigationBar(
        selectedIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  final String selectedCategory;
  final double? minPrice;
  final double? maxPrice;
  final Function(String?, double?, double?) onFiltersApplied;

  const HomeContent({Key? key, required this.selectedCategory, this.minPrice, this.maxPrice, required this.onFiltersApplied}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                HomeAppBar(
                  onFiltersApplied: onFiltersApplied,
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
                      // Search bar
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
                      // Categories title
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
                      // Categories widget
                      CategoriesWidget(
                        selectedCategory: selectedCategory,
                        onCategorySelected: (category) => onFiltersApplied(category, null, null),
                      ),
                      SizedBox(height: 20),
                      HomeItemsWidget(selectedCategory: selectedCategory, minPrice: minPrice, maxPrice: maxPrice),
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
