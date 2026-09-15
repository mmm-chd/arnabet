import 'package:arena/components/custom_spacing.dart';
import 'package:arena/components/custom_text.dart';
import 'package:arena/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PaymentRadioTile extends StatelessWidget {
  final String title;
  final String icon;
  final String value;
  final String selectedValue;
  final double? size;
  final Function(String) onTap;
  final bool showArrow;
  final bool isExpanded;

  const PaymentRadioTile({
    super.key,
    required this.title,
    required this.icon,
    required this.value,
    required this.selectedValue,
    required this.onTap,
    this.size = 4,
    this.showArrow = false,
    this.isExpanded = false,
  });

  @override
  Widget build(BuildContext context) {
    final selected = value == selectedValue;

    return InkWell(
      onTap: () {
        onTap(value);
      },
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: SupportAppColors.lightRed,
              borderRadius: BorderRadius.circular(14),
            ),
            child: SvgPicture.asset(
              icon,
              width: size,
              height: size,
              colorFilter: ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
              fit: BoxFit.scaleDown,
            ),
          ),

          const CustomSpacing(width: 14),

          Expanded(
            child: CustomText(
              text: title,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),

          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: selected
                    ? AppColors.primary
                    : SupportAppColors.greyColor,
                width: 2,
              ),
            ),
            child: Center(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selected ? AppColors.primary : Colors.transparent,
                ),
              ),
            ),
          ),

          if (showArrow) ...[
            const CustomSpacing(width: 12),
            AnimatedRotation(
              turns: isExpanded ? 0.5 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: const Icon(
                Icons.keyboard_arrow_down,
                color: SupportAppColors.greyDarkColor,
                size: 22,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
