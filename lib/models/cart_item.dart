import 'product.dart';

class CartItem {
  final Product product;
  int cantidad;

  CartItem({
    required this.product,
    required this.cantidad,
  });

  double get subtotal => product.precio * cantidad;

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      product: Product.fromJson(json['product']),
      cantidad: json['cantidad'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'cantidad': cantidad,
    };
  }
}
