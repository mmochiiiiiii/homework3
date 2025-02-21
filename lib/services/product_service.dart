import 'dart:convert';
import 'dart:io';

class ProductService {
  late String _filePath;

  Future<void> _initFilePath() async {
    _filePath = 'assets/products.json';
  }

  Future<File> _ensureFileExists() async {
    await _initFilePath(); // กำหนด path ของไฟล์
    final file = File(_filePath);

    if (!await file.exists()) {
      // สร้างไฟล์ใหม่ถ้ายังไม่มี
      await file.writeAsString(jsonEncode([]));
    }

    return file;
  }

  Future<List<Map<String, dynamic>>> fetchProducts() async {
    try {
      final file = await _ensureFileExists();
      final contents = await file.readAsString();
      final List<dynamic> jsonData = jsonDecode(contents);
      return List<Map<String, dynamic>>.from(jsonData);
    } catch (e) {
      print('Error reading file: $e');
      return [];
    }
  }

  Future<void> saveProducts(List<Map<String, dynamic>> products) async {
    final file = await _ensureFileExists();
    final contents = jsonEncode(products);
    await file.writeAsString(contents);
  }

  Future<void> addProduct(Map<String, dynamic> product) async {
    final products = await fetchProducts();
    int nextId = products.isEmpty ? 1 : (products.last['id'] as int) + 1;
    product['id'] = nextId;
    products.add(product);

    await saveProducts(products);
  }
}