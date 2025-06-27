class ApiConfig {
  static const String baseUrl = 'http://3.145.56.6:3000';
  
  // Endpoints
  static const String products = '/products';
  static const String cart = '/cart';
  static const String orders = '/orders';
  
  // Headers
  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}
