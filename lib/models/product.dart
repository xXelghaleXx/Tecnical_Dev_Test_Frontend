class Product {
  final int id;
  final String nombre;
  final double precio;
  final int stock;
  final String descripcion;
  final String? imagen;

  Product({
    required this.id,
    required this.nombre,
    required this.precio,
    required this.stock,
    required this.descripcion,
    this.imagen,
  });

  // Compatibility getters for different naming conventions
  String get title => nombre;
  String get image => imagen ?? '';
  double get price => precio;
  String get description => descripcion;
  String get category => 'General'; // Default category
  double get rating => 4.5; // Default rating

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      nombre: json['nombre'] ?? '',
      precio: (json['precio'] ?? 0).toDouble(),
      stock: json['stock'] ?? 0,
      descripcion: json['descripcion'] ?? '',
      imagen: json['imagen'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'precio': precio,
      'stock': stock,
      'descripcion': descripcion,
      'imagen': imagen,
    };
  }
}
