import 'package:dashboard/components/custom_dialoge.dart';
import 'package:dashboard/helper/app_colors.dart';
import 'package:dashboard/helper/app_fonts.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double? borderRadius;
  final double? elevation;
  final EdgeInsetsGeometry? padding;
  final double? fontSize;
  final Color? borderColor;
  final double? width;
  final double? height;
  final bool isBlock;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.borderRadius,
    this.elevation,
    this.padding,
    this.fontSize,
    this.borderColor,
    this.width,
    this.height,
    this.isBlock = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isBlock ? AppColors.light : backgroundColor ?? AppColors.primary,
          foregroundColor: textColor ?? Colors.white,
          elevation: elevation ?? 4.0,
          padding: padding ??
              const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 8.0),
            side: borderColor != null
                ? BorderSide(color: borderColor!)
                : BorderSide.none,
          ),
        ),
        onPressed: isBlock
            ? () => CustomDialog(
                    title: "Button Blocked",
                    content: "Enter the required fields",
                    icon: Icons.block)
                .open(context)
            : onPressed,
        child: icon == null
            ? Flexible(
                child: Text(
                  text,
                  style: TextStyle(fontSize: fontSize ?? 16),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 20),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      text,
                      style: AppTextStyles.poppinsRegularStyle.copyWith(
                        fontSize: fontSize ?? 16,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
