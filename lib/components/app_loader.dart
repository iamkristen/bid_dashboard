import 'package:dashboard/helper/app_colors.dart';
import 'package:dashboard/helper/app_fonts.dart';
import 'package:flutter/material.dart';

class AppLoader extends StatelessWidget {
  const AppLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.5), // semi-transparent overlay
      alignment: Alignment.center,
      child: Container(
        width: 200,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.primary,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              spreadRadius: 2,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset("logo.png", height: 80),
            const SizedBox(height: 16),
            const CircularProgressIndicator(color: AppColors.primary),
            const SizedBox(height: 12),
            Text(
              "Please wait...",
              style: AppTextStyles.icebergStyle.copyWith(
                fontSize: 14,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
