import 'package:flutter/material.dart';
import 'package:furnitureapp/pages/CartPage.dart';
import 'package:furnitureapp/pages/FavoritePage.dart';
import 'package:furnitureapp/pages/UserProfilePage.dart';
import 'package:furnitureapp/translate/localization.dart';
import 'package:furnitureapp/widgets/HomeAppBar.dart';
import 'package:furnitureapp/widgets/HomeItemsWidget.dart';
import 'package:furnitureapp/widgets/HomeNavigationBar.dart';
import 'package:furnitureapp/services/data_service.dart';
import 'package:furnitureapp/model/product.dart';
import 'package:furnitureapp/config/config.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  int _selectedIndex = 0;
  String _selectedCategory = 'All Product';
  List<Product> _searchResults = [];
  final DataService _dataService = DataService();
  final TextEditingController _searchController = TextEditingController();

  final List<Widget> _pages = [
    const CartPage(),
    const FavoritePage(),
    const UserProfilePage(),
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

  void _performSearch(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    try {
      final results = await _dataService.searchProducts(query);
      setState(() {
        _searchResults = results;
      });
    } catch (e) {
      print('Error searching products: $e');
      // Có thể thêm thông báo lỗi cho người dùng ở đây
    }
  }

  @override
  void initState() {
    super.initState();
    // Đảm bảo load tất cả sản phẩm khi khởi động
    _onCategorySelected('All Product');
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _selectedIndex == 0
          ? Column(
              children: [
                HomeAppBar(
                  onFiltersApplied: (category, minPrice, maxPrice) {}, // Add empty callback
                ),
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
                          child: TextField(
                            controller: _searchController,
                            onChanged: _performSearch,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Search products...',
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
                Expanded(
                  child: _searchResults.isEmpty
                      ? Center(
                          child: Text(_searchController.text.isEmpty 
                              ? 'Enter a search term' 
                              : 'No results found'),
                        )
                      : GridView.builder(
                          padding: EdgeInsets.all(10),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.68,
                          ),
                          itemCount: _searchResults.length,
                          itemBuilder: (context, index) {
                            final product = _searchResults[index];
                            return ItemCard(product: product);
                          },
                        ),
                ),
              ],
            )
          : _pages[_selectedIndex - 1],
      bottomNavigationBar: HomeNavigationBar(
        selectedIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class ItemCard extends StatelessWidget {
  final Product product;

  const ItemCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: product.images != null && product.images!.isNotEmpty
                ? Image.network(
                    product.images![0],
                    fit: BoxFit.cover,
                  )
                : Icon(Icons.image_not_supported),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name ?? 'No name',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '\$${product.price?.toString() ?? 'N/A'}',
                  style: TextStyle(color: Colors.green),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}