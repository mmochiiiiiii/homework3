import 'package:flutter/material.dart';
import 'package:homework3/screens/add_product_page.dart';
import 'package:homework3/services/product_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product List',
      debugShowCheckedModeBanner: false, // ลบ debug ออกจากมุมขวาบน
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ProductListPage(),
    );
  }
}

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  List<Map<String, dynamic>> _products = [];
  final ProductService _productService = ProductService();

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    final products = await _productService.fetchProducts();
    setState(() {
      _products = products;
    });
  }

  Future<void> _addProduct(String name, String description, double price) async {
    final newProduct = {
      'name': name,
      'description': description,
      'price': price,
    };
    await _productService.addProduct(newProduct);
    _loadProducts();
  }

  Future<void> _editProduct(int id, String name, String description, double price) async {
    final productIndex = _products.indexWhere((product) => product['id'] == id);
    if (productIndex != -1) {
      _products[productIndex] = {
        'id': id,
        'name': name,
        'description': description,
        'price': price,
      };
      await _productService.saveProducts(_products);
      setState(() {});
    }
  }

  Future<void> _showDeleteDialog(int productId) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this product?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // ยกเลิกการลบ
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                _deleteProduct(productId);
                Navigator.of(context).pop(); // ยืนยันการลบ
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteProduct(int id) async {
    _products.removeWhere((product) => product['id'] == id);
    await _productService.saveProducts(_products);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Product List',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        elevation: 4,
      ),
      body: _products.isEmpty
          ? const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 100,
              color: Colors.grey,
            ),
            SizedBox(height: 20),
            Text(
              'No products available.',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.only(bottom: 75),
        itemCount: _products.length,
        itemBuilder: (context, index) { //
          final product = _products[index];
          return Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 4,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${product['id']}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product['name'],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              product['description'],
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  Text(
                    'Price: \$${product['price'].toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () async {
                          final Map<String, dynamic>? updatedProduct =
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddProductPage(
                                product: product,
                              ),
                            ),
                          );
                          if (updatedProduct != null) {
                            await _editProduct(
                              product['id'],
                              updatedProduct['name'],
                              updatedProduct['description'],
                              updatedProduct['price'],
                            );
                          }
                        },
                        icon: const Icon(Icons.edit, color: Colors.deepPurple),
                        label: const Text('Edit'),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                        onPressed: () {
                          _showDeleteDialog(product['id']);
                        },
                        icon: const Icon(Icons.delete, color: Colors.white),
                        label: const Text('Delete'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: () async {
          final Map<String, dynamic>? newProduct = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddProductPage(),
            ),
          );
          if (newProduct != null) {
            await _addProduct(
              newProduct['name'],
              newProduct['description'],
              newProduct['price'],
            );
          }
        },
        tooltip: 'Add Product',
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}