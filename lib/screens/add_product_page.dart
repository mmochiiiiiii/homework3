import 'package:flutter/material.dart';

class AddProductPage extends StatefulWidget {
  final Map<String, dynamic>? product; // ส่งข้อมูลสินค้า (ถ้ามี)

  const AddProductPage({super.key, this.product});

  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _nameController.text = widget.product!['name'];
      _descriptionController.text = widget.product!['description'];
      _priceController.text = widget.product!['price'].toString();
    }
  }

  void _submitProduct() {
    if (_formKey.currentState!.validate()) {
      final updatedProduct = {
        'name': _nameController.text,
        'description': _descriptionController.text,
        'price': double.parse(_priceController.text),
      };
      Navigator.pop(context, updatedProduct);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product == null ? 'Add Product' : 'Edit Product'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Product Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the product name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter a description'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'Price',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitProduct,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  widget.product == null ? 'Add Product' : 'Save Changes',
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}