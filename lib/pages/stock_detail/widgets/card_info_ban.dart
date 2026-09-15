import 'package:arena/components/custom_spacing.dart';
import 'package:arena/components/custom_text.dart';
import 'package:arena/config/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CardInfoBan extends StatelessWidget {
  final String nama;
  final String size;
  final String ring;

  const CardInfoBan({
    super.key,
    required this.nama,
    required this.size,
    required this.ring,
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
            text: "Informasi Ban",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),

          const CustomSpacing(height: 12),

          _item("Nama", nama),
          _item("Ukuran", size),
          _item("Ring", ring),
        ],
      ),
    );
  }

  Widget _item(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: CustomText(
              text: title,
              style: TextStyle(color: SupportAppColors.greyColor),
            ),
          ),
          Expanded(
            flex: 3,
            child: CustomText(
              text: value,
              textAlign: TextAlign.end,
              style: const TextStyle(fontWeight: FontWeight.w500),
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
