import 'package:flutter/material.dart';
import 'package:furnitureapp/pages/CartPage.dart';
import 'package:furnitureapp/pages/FavoritePage.dart';
import 'package:furnitureapp/pages/UserProfilePage.dart';
import 'package:furnitureapp/widgets/CategoriesWidget.dart';
import 'package:furnitureapp/widgets/HomeAppBar.dart';
import 'package:furnitureapp/widgets/HomeItemsWidget.dart';
import 'package:furnitureapp/widgets/HomeNavigationBar.dart';
import 'package:furnitureapp/translate/localization.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  String _selectedCategory = 'All Product'; // Giữ nguyên giá trị mặc định

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
              onCategorySelected: _onCategorySelected,
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
  final Function(String) onCategorySelected;

  const HomeContent({Key? key, required this.selectedCategory, required this.onCategorySelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                HomeAppBar(),
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
                                    hintText: l10n.searchHint,
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
                          l10n.categories,
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
                        onCategorySelected: onCategorySelected,
                      ),
                      SizedBox(height: 20),
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
