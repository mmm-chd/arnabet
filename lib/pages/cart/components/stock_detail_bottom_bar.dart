import 'package:arena/components/custom_spacing.dart';
import 'package:arena/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:arena/components/custom_text.dart';

class StockDetailBottomBar extends StatelessWidget {
  final VoidCallback? onTap;
  final String text;

  const StockDetailBottomBar({
    required this.onTap,
    super.key,
    this.text = 'Tambahkan barang ke keranjang',
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        color: Colors.white,
        child: Row(
          children: [
            Expanded(
              child: CustomText(
                text: text,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                ),
              ),
            ),
            CustomSpacing(
              height: 48,
              child: ElevatedButton(
                onPressed: onTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: SupportAppColors.normalRed,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const CustomText(
                  text: 'Beli',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
