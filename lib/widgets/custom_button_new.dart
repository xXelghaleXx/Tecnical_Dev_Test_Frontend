import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final bool isOutlined;
  final Widget? icon;

  const CustomButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.isOutlined = false,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 48,
      child: isOutlined
          ? OutlinedButton.icon(
              onPressed: isLoading ? null : onPressed,
              icon: icon ?? SizedBox.shrink(),
              label: _buildButtonContent(),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: backgroundColor ?? AppColors.primary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                ),
              ),
            )
          : ElevatedButton.icon(
              onPressed: isLoading ? null : onPressed,
              icon: icon ?? SizedBox.shrink(),
              label: _buildButtonContent(),
              style: ElevatedButton.styleFrom(
                backgroundColor: backgroundColor ?? AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                ),
                elevation: 2,
              ),
            ),
    );
  }

  Widget _buildButtonContent() {
    return isLoading
        ? SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                isOutlined ? (backgroundColor ?? AppColors.primary) : (textColor ?? Colors.white),
              ),
            ),
          )
        : Text(
            text,
            style: TextStyle(
              color: isOutlined ? (backgroundColor ?? AppColors.primary) : (textColor ?? Colors.white),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          );
  }
}
