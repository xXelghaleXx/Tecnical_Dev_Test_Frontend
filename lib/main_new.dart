import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/product_provider.dart';
import 'providers/cart_provider.dart';
import 'screens/home_screen.dart';
import 'utils/colors.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProductProvider()),
        ChangeNotifierProvider(create: (context) => CartProvider()),
      ],
      child: MaterialApp(
        title: 'Shopping Cart',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: MaterialColor(0xFF600585, {
            50: Color(0xFFF3E5F5),
            100: Color(0xFFE1BEE7),
            200: Color(0xFFCE93D8),
            300: Color(0xFFBA68C8),
            400: Color(0xFFAB47BC),
            500: Color(0xFF600585),
            600: Color(0xFF8E24AA),
            700: Color(0xFF7B1FA2),
            800: Color(0xFF6A1B9A),
            900: Color(0xFF4A148C),
          }),
          primaryColor: AppColors.primary,
          scaffoldBackgroundColor: AppColors.background,
          fontFamily: 'Roboto',
        ),
        home: HomeScreen(),
      ),
    );
  }
}
