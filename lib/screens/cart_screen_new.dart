import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/cart_provider.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/cart_item_widget.dart';
import '../widgets/custom_button.dart';
import '../widgets/loading_widget.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import 'order_history_screen.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _isProcessingOrder = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CartProvider>().loadCart();
    });
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'es_PE', symbol: 'S/');

    return Scaffold(
      appBar: CustomAppBar(title: 'Carrito de Compras', showCartIcon: false),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          if (cartProvider.isLoading) {
            return LoadingWidget(message: 'Cargando carrito...');
          }

          if (cartProvider.items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 80,
                    color: AppColors.textSecondary,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Tu carrito está vacío',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Agrega productos para continuar',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: 24),
                  CustomButton(
                    text: 'Explorar Productos',
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // Lista de productos en el carrito
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(AppConstants.padding),
                  itemCount: cartProvider.items.length,
                  itemBuilder: (context, index) {
                    return CartItemWidget(item: cartProvider.items[index]);
                  },
                ),
              ),

              // Resumen del carrito
              Container(
                padding: EdgeInsets.all(AppConstants.padding),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Resumen de totales
                    Container(
                      padding: EdgeInsets.all(AppConstants.padding),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total de productos:',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Text(
                                '${cartProvider.itemCount}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                          
                          SizedBox(height: 8),
                          
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total a pagar:',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Text(
                                currencyFormat.format(cartProvider.total),
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 16),

                    // Botones de acción
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            text: 'Vaciar Carrito',
                            backgroundColor: AppColors.error,
                            onPressed: _showClearCartDialog,
                          ),
                        ),
                        
                        SizedBox(width: 12),
                        
                        Expanded(
                          flex: 2,
                          child: CustomButton(
                            text: 'Procesar Pedido',
                            isLoading: _isProcessingOrder,
                            onPressed: _processOrder,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _processOrder() async {
    setState(() {
      _isProcessingOrder = true;
    });

    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final success = await cartProvider.saveOrder();

    setState(() {
      _isProcessingOrder = false;
    });

    if (success) {
      _showSuccessDialog();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al procesar el pedido'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _showClearCartDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Vaciar Carrito'),
          content: Text('¿Estás seguro de que quieres eliminar todos los productos del carrito?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                final cartProvider = Provider.of<CartProvider>(context, listen: false);
                await cartProvider.clearCart();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Carrito vaciado'),
                    backgroundColor: AppColors.success,
                  ),
                );
              },
              child: Text(
                'Vaciar',
                style: TextStyle(color: AppColors.error),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.check_circle, color: AppColors.success),
              SizedBox(width: 8),
              Text('¡Pedido Exitoso!'),
            ],
          ),
          content: Text('Tu pedido ha sido procesado correctamente. Puedes revisar el historial en cualquier momento.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Volver a la pantalla principal
              },
              child: Text('Continuar Comprando'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => OrderHistoryScreen()),
                );
              },
              child: Text('Ver Historial'),
            ),
          ],
        );
      },
    );
  }
}
