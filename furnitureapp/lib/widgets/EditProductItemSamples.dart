import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditProductItemSamples extends StatefulWidget {
  final String productName;
  final String productDescription;
  final String price;
  final String image1;
  final String image2;
  final ValueChanged<bool> onFieldChanged;

  const EditProductItemSamples({
    Key? key,
    required this.onFieldChanged,
    this.productName = 'Ghế Công Thái Học',
    this.productDescription =
        'Vật liệu: Lưng da pu + nệm, chân thép mạ crom, ngả lưng duỗi chân\nMàu sắc: Đen, xám, trắng\nXuất xứ: Nhập khẩu',
    this.price = '\$100',
    this.image1 = 'assets/images/1.png',
    this.image2 = 'assets/images/2.png',
  }) : super(key: key);

  @override
  _EditProductItemSamplesState createState() => _EditProductItemSamplesState();
}

class _EditProductItemSamplesState extends State<EditProductItemSamples> {
  late String productName;
  late String productDescription;
  late String price;
  File? selectedImage1;
  File? selectedImage2;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    productName = widget.productName;
    productDescription = widget.productDescription;
    price = widget.price;
  }

  Future<void> _uploadPhoto(int imageNumber) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        if (imageNumber == 1) {
          selectedImage1 = File(pickedFile.path);
        } else {
          selectedImage2 = File(pickedFile.path);
        }
      });
      _notifyChange();
    }
  }

  void _notifyChange() {
    final hasChanged = productName != widget.productName ||
        productDescription != widget.productDescription ||
        price != widget.price ||
        selectedImage1 != null ||
        selectedImage2 != null;
    widget.onFieldChanged(hasChanged);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () => _uploadPhoto(1),
                child: selectedImage1 != null
                    ? Image.file(
                        selectedImage1!,
                        width: 150,
                        height: 150,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        widget.image1,
                        width: 150,
                        height: 150,
                      ),
              ),
              GestureDetector(
                onTap: () => _uploadPhoto(2),
                child: selectedImage2 != null
                    ? Image.file(
                        selectedImage2!,
                        width: 150,
                        height: 150,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        widget.image2,
                        width: 150,
                        height: 150,
                      ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Center(
            child: ElevatedButton(
              onPressed: () => _uploadPhoto(1),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'Upload photo',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            initialValue: productName,
            decoration: const InputDecoration(
              labelText: 'Product Name',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              productName = value;
              _notifyChange();
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            maxLines: 4,
            initialValue: productDescription,
            decoration: const InputDecoration(
              labelText: 'Product Description',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              productDescription = value;
              _notifyChange();
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            initialValue: price,
            decoration: const InputDecoration(
              labelText: 'Price',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              price = value;
              _notifyChange();
            },
          ),
        ],
      ),
    );
  }
}
