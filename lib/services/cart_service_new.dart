import '../models/cart_item.dart';
import '../models/product.dart';
import '../config/api_config.dart';
import 'api_service.dart';

class CartService {
  static int? _activeCartId;

  // Get active cart
  static Future<List<CartItem>> getCartItems() async {
    try {
      final response = await ApiService.get(ApiConfig.cartActive);
      if (response.isNotEmpty) {
        final cartData = response.first;
        _activeCartId = cartData['id'];
        
        // Extract cart items from the response
        final items = cartData['items'] ?? cartData['productos'] ?? [];
        return items.map<CartItem>((item) => CartItem.fromJson(item)).toList();
      }
      return [];
    } catch (e) {
      print('Error in CartService.getCartItems: $e');
      throw Exception('Failed to load cart items: $e');
    }
  }

  // Add product to cart
  static Future<bool> addToCart(Product product) async {
    try {
      final body = {
        'productoId': product.id,
        'cantidad': 1,
      };
      
      final response = await ApiService.post(ApiConfig.cartAddProduct, body);
      return response.isNotEmpty;
    } catch (e) {
      print('Error in CartService.addToCart: $e');
      throw Exception('Failed to add product to cart: $e');
    }
  }

  // Update product quantity in cart
  static Future<bool> updateQuantity(int productId, int cantidad) async {
    try {
      if (_activeCartId == null) {
        await getCartItems(); // Get active cart first
      }
      
      final endpoint = '${ApiConfig.cartUpdateProduct}/$_activeCartId/products/$productId';
      final body = {
        'cantidad': cantidad,
      };
      
      final response = await ApiService.put(endpoint, body);
      return response.isNotEmpty;
    } catch (e) {
      print('Error in CartService.updateQuantity: $e');
      throw Exception('Failed to update quantity: $e');
    }
  }

  // Remove product from cart
  static Future<bool> removeFromCart(int productId) async {
    try {
      if (_activeCartId == null) {
        await getCartItems(); // Get active cart first
      }
      
      final endpoint = '${ApiConfig.cartRemoveProduct}/$_activeCartId/products/$productId';
      return await ApiService.delete(endpoint);
    } catch (e) {
      print('Error in CartService.removeFromCart: $e');
      throw Exception('Failed to remove product from cart: $e');
    }
  }

  // Clear entire cart
  static Future<bool> clearCart() async {
    try {
      if (_activeCartId == null) {
        await getCartItems(); // Get active cart first
      }
      
      final endpoint = '${ApiConfig.cartClear}/$_activeCartId/clear';
      return await ApiService.delete(endpoint);
    } catch (e) {
      print('Error in CartService.clearCart: $e');
      throw Exception('Failed to clear cart: $e');
    }
  }

  // Checkout cart
  static Future<bool> checkout() async {
    try {
      if (_activeCartId == null) {
        await getCartItems(); // Get active cart first
      }
      
      final endpoint = '${ApiConfig.cartCheckout}/$_activeCartId/checkout';
      final response = await ApiService.post(endpoint, {});
      return response.isNotEmpty;
    } catch (e) {
      print('Error in CartService.checkout: $e');
      throw Exception('Failed to checkout: $e');
    }
  }

  // Get purchase history
  static Future<List<dynamic>> getPurchaseHistory() async {
    try {
      return await ApiService.get(ApiConfig.cartHistory);
    } catch (e) {
      print('Error in CartService.getPurchaseHistory: $e');
      throw Exception('Failed to get purchase history: $e');
    }
  }

  // Get purchase details
  static Future<Map<String, dynamic>> getPurchaseDetails(int carritoId) async {
    try {
      final response = await ApiService.get('${ApiConfig.cartPurchaseDetails}/$carritoId');
      return response.isNotEmpty ? response.first : {};
    } catch (e) {
      print('Error in CartService.getPurchaseDetails: $e');
      throw Exception('Failed to get purchase details: $e');
    }
  }

  // Helper methods
  static int getTotalItems(List<CartItem> items) {
    return items.fold(0, (sum, item) => sum + item.cantidad);
  }

  static double getTotal(List<CartItem> items) {
    return items.fold(0.0, (sum, item) => sum + item.subtotal);
  }
}
