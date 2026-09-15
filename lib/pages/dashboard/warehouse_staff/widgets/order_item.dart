import 'package:arena/components/custom_spacing.dart';
import 'package:arena/components/custom_text.dart';
import 'package:arena/components/custom_button_icon.dart';
import 'package:flutter/material.dart';
import 'package:arena/config/theme/app_colors.dart';

class OrderItem extends StatelessWidget {
  final String invoice;
  final String status;
  final double? topLeft, topRight, bottomLeft, bottomRight;

  const OrderItem({
    super.key,
    required this.invoice,
    required this.status,
    this.topLeft,
    this.topRight,
    this.bottomLeft,
    this.bottomRight,
  });

  Color getColor() {
    if (status == "Urgent") return SupportAppColors.normalRed;
    return SupportAppColors.normalOrange;
  }

  @override
  Widget build(BuildContext context) {
    final color = getColor();

    return Container(
      margin: const EdgeInsets.only(top: 2),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: SupportAppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(topLeft ?? 0),
          topRight: Radius.circular(topRight ?? 0),
          bottomLeft: Radius.circular(bottomLeft ?? 0),
          bottomRight: Radius.circular(bottomRight ?? 0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: invoice,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: SupportAppColors.greyDarkerColor,
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      margin: const EdgeInsets.only(right: 6),
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    CustomText(
                      text: status,
                      style: TextStyle(
                        color: color,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const CustomSpacing(height: 4),

          CustomText(
            text: "08.14 • 1j 49m lalu",
            style: TextStyle(fontSize: 12, color: SupportAppColors.greyColor),
          ),

          const CustomSpacing(height: 12),

          _rowItem("Ecopia EP150", "185 / 65 / R15", "5 pcs"),
          _rowItem("Potenza RE003", "185 / 65 / R15", "4 pcs"),

          const CustomSpacing(height: 6),

          CustomText(
            text: "+3 item lainnya",
            style: TextStyle(
              fontSize: 12,
              fontStyle: FontStyle.italic,
              color: SupportAppColors.greyColor,
            ),
          ),

          const CustomSpacing(height: 12),

          CustomButtonIcon(
            text: "Konfirmasi Pengambilan",
            icon: Icons.check,
            backgroundColor: color,
            foregroundColor: Colors.white,
            borderRadius: 12,
            height: 10,
            elevation: 0,
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _rowItem(
    String name,
    String size,
    String qty,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: "• ",
            style: TextStyle(color: SupportAppColors.greyColor),
          ),

          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(color: SupportAppColors.greyDarkerColor, fontSize: 13),
                children: [
                  TextSpan(
                    text: name,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  TextSpan(
                    text: "  $size",
                    style: TextStyle(
                      color: SupportAppColors.greyColor,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),

          CustomText(
            text: qty,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: SupportAppColors.greyDarkerColor,
            ),
          ),
        ],
      ),
    );
  }
}
