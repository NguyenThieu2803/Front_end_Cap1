import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:furnitureapp/api/api.service.dart';
import 'package:furnitureapp/services/data_service.dart';
class EvaluateFeedBack extends StatefulWidget {
  final String productId;
  final String productName;
  final String? productImage;

  const EvaluateFeedBack({
    Key? key, 
    required this.productId,
    required this.productName,
    this.productImage,
  }) : super(key: key);

  @override
  State<EvaluateFeedBack> createState() => _EvaluateFeedBackState();
}

class _EvaluateFeedBackState extends State<EvaluateFeedBack> {
  final TextEditingController _commentController = TextEditingController();
  double _rating = 0;
  List<String> _selectedImages = [];
  final DataService _dataService = DataService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDECF2),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(82.0),
        child: AppBar(
          backgroundColor: Colors.white,
          leading: Padding(
            padding: const EdgeInsets.only(top: 18.0),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                size: 30,
                color: Colors.black,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          title: Container(
            margin: const EdgeInsets.only(top: 25.0),
            child: const Text(
              'Write A Review',
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          centerTitle: true,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hiển thị thông tin sản phẩm
              Card(
                child: ListTile(
                  leading: widget.productImage != null 
                    ? Image.network(widget.productImage!, width: 50, height: 50)
                    : const Icon(Icons.image_not_supported),
                  title: Text(widget.productName),
                ),
              ),
              const SizedBox(height: 16),
              
              // Rating stars
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < _rating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                    ),
                    onPressed: () {
                      setState(() {
                        _rating = index + 1;
                      });
                    },
                  );
                }),
              ),

              // Comment field
              TextField(
                controller: _commentController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Write your review here...',
                  border: OutlineInputBorder(),
                ),
              ),

              // Image picker
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _pickImages,
                child: const Text('Add Photos'),
              ),

              // Selected images preview
              if (_selectedImages.isNotEmpty)
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _selectedImages.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.file(
                          File(_selectedImages[index]),
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  ),
                ),

              // Submit button
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitReview,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Submit Review'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();
    
    if (pickedFiles != null) {
      setState(() {
        _selectedImages.addAll(pickedFiles.map((file) => file.path));
      });
    }
  }

  Future<void> _submitReview() async {
    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a rating')),
      );
      return;
    }

    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      final success = await APIService.createReview(
        widget.productId,
        _rating,
        _commentController.text,
        _selectedImages,
      );

      // Hide loading indicator
      Navigator.pop(context);

      if (success) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Review submitted successfully')),
        );
      }
    } catch (e) {
      // Hide loading indicator
      Navigator.pop(context);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting review: $e')),
      );
    }
  }
}
