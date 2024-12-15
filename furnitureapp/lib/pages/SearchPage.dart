import 'dart:async';
import 'package:flutter/material.dart';
import 'package:furnitureapp/model/Review.dart';
import 'package:furnitureapp/model/product.dart';
import 'package:furnitureapp/services/data_service.dart';
import 'package:furnitureapp/pages/ProductPage.dart';  

// ... rest of existing imports ...

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Product> _searchResults = [];
  final TextEditingController _searchController = TextEditingController();
  final DataService _dataService = DataService();
  Timer? _debounce;

  void _performSearch(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      try {
        final results = await _dataService.searchProducts(query);
        
        results.forEach((product) {
          print('Search result - Product ${product.name}:');
          print('- model3d: ${product.model3d}');
          print('- All data: $product');
        });

        setState(() {
          _searchResults = results;
        });
      } catch (e) {
        print('Error searching products: $e');
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildSearchResults() {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final product = _searchResults[index];
        return InkWell(
          onTap: () {
            try {
              print('Tapping product: ${product.name}');
              print('Original model3d URL: ${product.model3d}');
              
              final productForDetail = Product(
                id: product.id ?? '',
                name: product.name ?? 'No Name',
                description: product.description ?? '',
                price: product.price ?? 0.0,
                images: product.images ?? [],
                category: product.category ?? '',
                rating: product.rating ?? 0.0,
                stockQuantity: product.stockQuantity ?? 0,
                material: product.material ?? '',
                brand: product.brand ?? '',
                style: product.style ?? '',
                assemblyRequired: product.assemblyRequired ?? false,
                weight: product.weight ?? 0,
                sold: product.sold ?? 0,
                model3d: product.model3d,
              );
              
              print('ProductForDetail model3d URL: ${productForDetail.model3d}');

              final review = Review(
                id: product.id ?? '',
                rating: (product.rating ?? 0).toInt(),
                comment: '',
                reviewDate: DateTime.now().toString(),
                images: [],
                userName: '',
                userEmail: '',
              );

              print('ProductForDetail model3d: ${productForDetail.model3d}');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductPage(
                    product: productForDetail,
                    review: review,
                  ),
                ),
              );
            } catch (e) {
              print('Error navigating: $e');
            }
          },
          child: Card(
            elevation: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(4),
                      ),
                    ),
                    child: _buildProductImage(product),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name ?? 'No Name',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '\$${(product.price ?? 0).toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          if (product.rating != null)
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  size: 16,
                                  color: Colors.amber,
                                ),
                                Text(
                                  product.rating!.toStringAsFixed(1),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProductImage(Product product) {
    if (product.images == null || product.images!.isEmpty) {
      return const Center(
        child: Icon(
          Icons.image_not_supported,
          size: 40,
          color: Colors.grey,
        ),
      );
    }

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
      child: Image.network(
        product.images![0],
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          print('Error loading image: $error');
          return const Center(
            child: Icon(
              Icons.image_not_supported,
              size: 40,
              color: Colors.grey,
            ),
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Products'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: _performSearch,
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          Expanded(
            child: _searchResults.isEmpty
                ? Center(
                    child: Text(
                      _searchController.text.isEmpty
                          ? 'Enter a search term'
                          : 'No products found',
                      style: const TextStyle(fontSize: 16),
                    ),
                  )
                : _buildSearchResults(),
          ),
        ],
      ),
    );
  }
}