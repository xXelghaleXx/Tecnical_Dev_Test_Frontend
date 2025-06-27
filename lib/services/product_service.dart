import '../models/product.dart';
import '../config/api_config.dart';
import 'api_service.dart';

class ProductService {
  static Future<List<Product>> getAllProducts() async {
    try {
      final response = await ApiService.get(ApiConfig.products);
      return response.map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      print('Error in ProductService.getAllProducts: $e');
      throw Exception('Failed to load products: $e');
    }
  }
  
  static Future<Product> getProductById(int id) async {
    try {
      final response = await ApiService.get('${ApiConfig.products}/$id');
      if (response.isNotEmpty) {
        return Product.fromJson(response.first);
      } else {
        throw Exception('Product not found');
      }
    } catch (e) {
      print('Error in ProductService.getProductById: $e');
      throw Exception('Failed to load product: $e');
    }
  }
}
