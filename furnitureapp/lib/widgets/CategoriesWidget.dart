import 'package:flutter/material.dart';

class CategoriesWidget extends StatelessWidget {
  final String selectedCategory;
  final Function(String) onCategorySelected;

  CategoriesWidget({super.key, required this.selectedCategory, required this.onCategorySelected});

  final List<String> categoryNames = ["All Product", "Table", "Chair", "Sofa", "Bed", "Desk", "Cabinet"];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (String category in categoryNames)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: InkWell(
                onTap: () => onCategorySelected(category),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: BoxDecoration(
                    color: selectedCategory == category ? const Color(0xFF2B2321) : Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Conditionally show image only if category is not "All"
                      if (category != "All Product") 
                        Image.asset(
                          "assets/images/${categoryNames.indexOf(category)}.png",
                          width: 40,
                          height: 40,
                        ),
                      if (category != "All Product") SizedBox(width: 10), // Add spacing only if there's an image
                      Text(
                        category,
                        style: TextStyle(
                          fontWeight: selectedCategory == category ? FontWeight.bold : FontWeight.normal,
                          fontSize: 20,
                          color: selectedCategory == category ? Colors.white : Color(0xFF2B2321),
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
