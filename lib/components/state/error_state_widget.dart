import 'package:arena/components/custom_button.dart';
import 'package:arena/components/custom_spacing.dart';
import 'package:arena/components/custom_text.dart';
import 'package:arena/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ErrorStateWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ErrorStateWidget({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 80, color: AppColors.error),

            const CustomSpacing(height: 16),

            const CustomText(
              text: "Oops!",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const CustomSpacing(height: 8),

            CustomText(
              text: message,
              style: TextStyle(color: Colors.grey.shade600),
            ),

            const CustomSpacing(height: 24),

            // CustomIconbuttonCircle(
            //   prefixIcon: Icons.refresh,
            //   onPressed: onRetry,
            //   backgroundColor: AppColors.error,
            //   iconColor: Colors.white,
            // ),
            // const CustomSpacing(height: 32),
            CustomButton(
              text: "Kembali",
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              onPressed: () => context.pop(),
            ),
          ],
        ),
      ),
    );
  }
}
