class ApiConfig {
  static const String baseUrl = 'http://3.145.56.6:3000/api/v1';
  
  // Product Endpoints
  static const String products = '/products';
  static const String productSearch = '/products/search';
  static const String productById = '/products'; // Will append /{id}
  static const String productStock = '/products'; // Will append /{id}/stock
  
  // Cart Endpoints
  static const String cartActive = '/cart/active';
  static const String cartAddProduct = '/cart/add-product';
  static const String cartUpdateProduct = '/cart'; // Will append /{carritoId}/products/{productoId}
  static const String cartRemoveProduct = '/cart'; // Will append /{carritoId}/products/{productoId}
  static const String cartClear = '/cart'; // Will append /{carritoId}/clear
  static const String cartCheckout = '/cart'; // Will append /{carritoId}/checkout
  static const String cartHistory = '/cart/history';
  static const String cartPurchaseDetails = '/cart/purchase'; // Will append /{carritoId}
  
  // Headers
  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}
