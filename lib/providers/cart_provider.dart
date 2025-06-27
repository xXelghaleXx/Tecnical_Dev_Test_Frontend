import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';
import '../models/product.dart';
import '../services/cart_service.dart';

class CartProvider with ChangeNotifier {
  List<CartItem> _items = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<CartItem> get items => _items;
  List<CartItem> get cartItems => _items; // Alias for compatibility
  bool get isLoading => _isLoading;
  bool get isEmpty => _items.isEmpty;
  String? get errorMessage => _errorMessage;
  int get itemCount => CartService.getTotalItems(_items);
  double get total => CartService.getTotal(_items);
  double get subtotal => CartService.getTotal(_items);
  double get tax => subtotal * 0.1; // 10% tax
  double get shipping => _items.isNotEmpty ? 5.99 : 0.0; // Flat shipping rate
  double get finalTotal => subtotal + tax + shipping;

  Future<void> loadCart() async {
    _isLoading = true;
    notifyListeners();

    try {
      _items = await CartService.getCartItems();
    } catch (e) {
      print('Error cargando carrito: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> addToCart(Product product, {int quantity = 1}) async {
    try {
      // Add multiple quantities by calling addToCart multiple times
      for (int i = 0; i < quantity; i++) {
        await CartService.addToCart(product);
      }
      await loadCart();
      return true;
    } catch (e) {
      print('Error adding to cart: $e');
      return false;
    }
  }

  Future<bool> updateQuantity(int productId, int cantidad) async {
    try {
      await CartService.updateQuantity(productId, cantidad);
      await loadCart();
      return true;
    } catch (e) {
      print('Error updating quantity: $e');
      return false;
    }
  }

  Future<bool> removeItem(int productId) async {
    try {
      await CartService.removeFromCart(productId);
      await loadCart();
      return true;
    } catch (e) {
      print('Error removing item: $e');
      return false;
    }
  }

  Future<bool> clearCart() async {
    try {
      await CartService.clearCart();
      _items.clear();
      notifyListeners();
      return true;
    } catch (e) {
      print('Error clearing cart: $e');
      return false;
    }
  }

  Future<bool> saveOrder() async {
    try {
      // Simulate saving order (this would typically call an API)
      await Future.delayed(Duration(seconds: 1));
      await clearCart();
      return true;
    } catch (e) {
      print('Error saving order: $e');
      return false;
    }
  }

  Future<void> loadCartItems() async {
    await loadCart();
  }

  Future<void> incrementQuantity(int productId) async {
    final existingItem = _items.firstWhere(
      (item) => item.product.id == productId,
      orElse: () => throw Exception('Item not found'),
    );
    await updateQuantity(productId, existingItem.cantidad + 1);
  }

  Future<void> decrementQuantity(int productId) async {
    final existingItem = _items.firstWhere(
      (item) => item.product.id == productId,
      orElse: () => throw Exception('Item not found'),
    );
    if (existingItem.cantidad > 1) {
      await updateQuantity(productId, existingItem.cantidad - 1);
    } else {
      await removeFromCart(productId);
    }
  }

  Future<void> removeFromCart(int productId) async {
    await removeItem(productId);
  }

  String getFormattedPrice(double price) {
    return price.toStringAsFixed(2);
  }

  Future<bool> checkout() async {
    return await saveOrder();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }
}
