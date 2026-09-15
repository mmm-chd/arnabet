import 'package:arena/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:arena/components/custom_spacing.dart';
import 'package:arena/components/custom_text.dart';

class InfoBox extends StatelessWidget {
  const InfoBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: SupportAppColors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: SupportAppColors.lightOrange,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.mail_outline,
              color: SupportAppColors.normalOrange,
            ),
          ),

          const CustomSpacing(width: 12),

          Expanded(
            child: CustomText(
              text:
                  "User akan menerima email undangan untuk mengatur password mereka sendiri.",
              style: TextStyle(fontSize: 13, color: SupportAppColors.greyDarkColor),
            ),
          ),
        ],
      ),
    );
  }
}
