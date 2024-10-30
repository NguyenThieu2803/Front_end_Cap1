import 'package:flutter/material.dart';
import 'package:furnitureapp/model/Categories.dart';
import 'package:furnitureapp/services/data_service.dart';

class CategoriesWidget extends StatefulWidget {
  final String selectedCategory;
  final Function(String) onCategorySelected;

  CategoriesWidget({Key? key, required this.selectedCategory, required this.onCategorySelected}) : super(key: key);

  @override
  _CategoriesWidgetState createState() => _CategoriesWidgetState();
}

class _CategoriesWidgetState extends State<CategoriesWidget> {
  final DataService _dataService = DataService();
  List<Categories> _categories = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      final categories = await _dataService.loadCategories();
      setState(() {
        _categories = categories;
      });
    } catch (e) {
      print('Error loading categories: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          // Nút All Product không có icon
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: InkWell(
              onTap: () => widget.onCategorySelected("All Product"),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15), // Tăng padding để khớp với Categories
                decoration: BoxDecoration(
                  color: widget.selectedCategory == "All Product" 
                      ? const Color(0xFF2B2321) 
                      : Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  "All Product",
                  style: TextStyle(
                    fontWeight: widget.selectedCategory == "All Product"
                        ? FontWeight.bold
                        : FontWeight.normal,
                    fontSize: 20,
                    color: widget.selectedCategory == "All Product"
                        ? Colors.white
                        : Color(0xFF2B2321),
                  ),
                ),
              ),
            ),
          ),
          // Danh sách categories hiện có
          for (Categories category in _categories)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: InkWell(
                onTap: () => widget.onCategorySelected(category.name ?? ""),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15), // Tăng padding để khớp với Categories
                  decoration: BoxDecoration(
                    color: widget.selectedCategory == category.name ? const Color(0xFF2B2321) : Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (category.images != null && category.images!.isNotEmpty)
                        Image.network(
                          category.images![0],
                          width: 40,
                          height: 40,
                          errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
                        ),
                      SizedBox(width: 10),
                      Text(
                        category.name ?? "",
                        style: TextStyle(
                          fontWeight: widget.selectedCategory == category.name ? FontWeight.bold : FontWeight.normal,
                          fontSize: 20,
                          color: widget.selectedCategory == category.name ? Colors.white : Color(0xFF2B2321),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
