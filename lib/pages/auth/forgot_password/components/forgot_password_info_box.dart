import 'package:arena/components/custom_spacing.dart';
import 'package:arena/components/custom_text.dart';
import 'package:arena/config/design/custom_icons.dart';
import 'package:flutter/material.dart';
import 'package:arena/config/theme/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ForgotPasswordInfoBox extends StatelessWidget {
  final IconData icon;
  final String text;
  const ForgotPasswordInfoBox({
    super.key,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: SupportAppColors.lightRed,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: SupportAppColors.normalRed.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: SupportAppColors.normalRed,
              borderRadius: BorderRadius.circular(12),
            ),
            child: SvgPicture.asset(
              CustomIcons.mail,
              width: 24,
              height: 24,
            ),
          ),
          const CustomSpacing(width: 16),
          Expanded(
            child: CustomText(
              text: text,
              style: TextStyle(
                color: SupportAppColors.normalRed,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
