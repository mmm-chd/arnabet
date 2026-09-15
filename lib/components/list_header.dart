import 'package:arena/components/custom_spacing.dart';
import 'package:arena/components/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:arena/config/theme/app_colors.dart';

class ListHeader extends StatelessWidget {
  final String title, description;
  final bool isArrow;
  final VoidCallback? onTap;

  const ListHeader({
    super.key,
    required this.title,
    required this.description,
    this.onTap,
    this.isArrow = true,
  });

  @override
  Widget build(BuildContext context) {

    return InkWell(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
      ),
      onTap: onTap,
      child: Material(
        color: SupportAppColors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: SupportAppColors.greyDarkerColor,
                    ),
                  ),
                  const CustomSpacing(height: 4),
                  CustomText(
                    text: description,
                    style: TextStyle(fontSize: 13, color: SupportAppColors.greyColor),
                  ),
                ],
              ),
            ),
            isArrow
                ? Icon(
                    Icons.arrow_forward_ios,
                    size: 18,
                    color: SupportAppColors.greyColor,
                  )
                : SizedBox.shrink(),
          ],
          ),
        ),
      ),
    );
  }
}
