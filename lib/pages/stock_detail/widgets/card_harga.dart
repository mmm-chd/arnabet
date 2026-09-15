import 'package:arena/components/custom_spacing.dart';
import 'package:arena/components/custom_text.dart';
import 'package:arena/config/theme/app_colors.dart';
import 'package:arena/helper/currency_local_formatter.dart';
import 'package:flutter/material.dart';

class CardHarga extends StatelessWidget {
  final String hargaBeli;
  final String hargaJual;
  final bool isOwner;

  const CardHarga({
    super.key,
    required this.hargaBeli,
    required this.hargaJual,
    this.isOwner = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _decoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomText(
            text: "Harga",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),

          const CustomSpacing(height: 12),

          _row("Harga Jual Bawaan Produk", hargaJual),
          if (isOwner) _row("Harga Beli Terakhir", hargaBeli),
        ],
      ),
    );
  }

  Widget _row(String title, String price) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: CustomText(
              text: title,
              style: TextStyle(color: SupportAppColors.greyColor),
            ),
          ),
          Expanded(
            child: CustomText(
              text: (int.tryParse(price) ?? 0).toLocaleCurrency(),
              style: const TextStyle(fontWeight: FontWeight.w500),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _decoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
    );
  }
}
