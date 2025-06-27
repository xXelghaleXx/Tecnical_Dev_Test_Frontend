import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

class CartService {
  static const String _cartKey = 'cart_items';
  
  static Future<List<CartItem>> getCartItems() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartString = prefs.getString(_cartKey);
      
      if (cartString == null) {
        return [];
      }
      
      final List<dynamic> cartJson = json.decode(cartString);
      return cartJson.map((item) => CartItem.fromJson(item)).toList();
    } catch (e) {
      print('Error loading cart items: $e');
      return [];
    }
  }
  
  static Future<void> saveCartItems(List<CartItem> items) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartString = json.encode(items.map((item) => item.toJson()).toList());
      await prefs.setString(_cartKey, cartString);
    } catch (e) {
      print('Error saving cart items: $e');
    }
  }
  
  static Future<void> addToCart(Product product) async {
    try {
      final items = await getCartItems();
      final existingIndex = items.indexWhere((item) => item.product.id == product.id);
      
      if (existingIndex != -1) {
        items[existingIndex].cantidad++;
      } else {
        items.add(CartItem(
          product: product,
          cantidad: 1,
        ));
      }
      
      await saveCartItems(items);
    } catch (e) {
      print('Error adding to cart: $e');
    }
  }
  
  static Future<void> removeFromCart(int productId) async {
    try {
      final items = await getCartItems();
      items.removeWhere((item) => item.product.id == productId);
      await saveCartItems(items);
    } catch (e) {
      print('Error removing from cart: $e');
    }
  }
  
  static Future<void> updateQuantity(int productId, int quantity) async {
    try {
      final items = await getCartItems();
      final index = items.indexWhere((item) => item.product.id == productId);
      
      if (index != -1) {
        if (quantity <= 0) {
          items.removeAt(index);
        } else {
          items[index].cantidad = quantity;
        }
        await saveCartItems(items);
      }
    } catch (e) {
      print('Error updating quantity: $e');
    }
  }
  
  static Future<void> clearCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_cartKey);
    } catch (e) {
      print('Error clearing cart: $e');
    }
  }
  
  static double getTotal(List<CartItem> items) {
    return items.fold(0.0, (total, item) => total + item.subtotal);
  }
  
  static int getTotalItems(List<CartItem> items) {
    return items.fold(0, (total, item) => total + item.cantidad);
  }
}
