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
      final response = await ApiService.get('${ApiConfig.productById}/$id');
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

  static Future<List<Product>> searchProducts(String query) async {
    try {
      final response = await ApiService.get('${ApiConfig.productSearch}?q=$query');
      return response.map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      print('Error in ProductService.searchProducts: $e');
      throw Exception('Failed to search products: $e');
    }
  }

  static Future<int> getProductStock(int id) async {
    try {
      final response = await ApiService.get('${ApiConfig.productStock}/$id/stock');
      if (response.isNotEmpty) {
        return response.first['stock'] ?? 0;
      }
      return 0;
    } catch (e) {
      print('Error in ProductService.getProductStock: $e');
      throw Exception('Failed to get product stock: $e');
    }
  }
}
