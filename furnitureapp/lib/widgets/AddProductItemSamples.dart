import 'package:flutter/material.dart';

class AddProductItemSamples extends StatefulWidget {
  final Function(bool) onValidationChanged;
  
  const AddProductItemSamples({
    Key? key, 
    required this.onValidationChanged,
  }) : super(key: key);

  @override
  State<AddProductItemSamples> createState() => _AddProductItemSamplesState();
}

class _AddProductItemSamplesState extends State<AddProductItemSamples> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _moneyController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    // Add listeners to all controllers
    _nameController.addListener(_validateForm);
    _descriptionController.addListener(_validateForm);
    _moneyController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _moneyController.dispose();
    super.dispose();
  }

  void _validateForm() {
    bool isValid = _nameController.text.isNotEmpty && 
                   _descriptionController.text.isNotEmpty && 
                   _moneyController.text.isNotEmpty;
    widget.onValidationChanged(isValid);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildImageContainer(),
                _buildImageContainer(),
              ],
            ),
            
            Container(
              margin: const EdgeInsets.symmetric(vertical: 16),
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Implement photo upload
                },
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

            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'Name product...',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            TextFormField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Description...',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            TextFormField(
              controller: _moneyController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Money',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageContainer() {
    return Container(
      width: 150,
      height: 180,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: const Center(
        child: Icon(
          Icons.add_photo_alternate_outlined,
          size: 40,
          color: Colors.grey,
        ),
      ),
    );
  }
}