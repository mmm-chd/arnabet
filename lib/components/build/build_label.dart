import 'package:arena/config/theme/app_colors.dart';
import 'package:flutter/material.dart';

class BuildLabel extends StatelessWidget {
  final String text;
  final bool isRequired, isReadOnly, isOptional;
  final String? helperText;

  const BuildLabel({
    super.key,
    required this.text,
    this.isRequired = false,
    this.isReadOnly = false,
    this.isOptional = false,
    this.helperText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: RichText(
        text: TextSpan(
          text: text,
          style: const TextStyle(
            color: SupportAppColors.greyDarkerColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          children: [
            if (helperText != null) ...[
              TextSpan(
                text: " ",
                style: TextStyle(
                  color: SupportAppColors.greyColor,
                  fontSize: 12,
                ),
              ),
              TextSpan(
                text: helperText,
                style: TextStyle(
                  color: SupportAppColors.greyColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],

            if (isReadOnly)
              const TextSpan(
                text: " (Read Only)",
                style: TextStyle(
                  color: SupportAppColors.greyColor,
                  fontSize: 12,
                ),
              ),
            if (isOptional)
              const TextSpan(
                text: " (Opsional)",
                style: TextStyle(
                  color: SupportAppColors.greyColor,
                  fontSize: 12,
                ),
              ),

            if (isRequired)
              const TextSpan(
                text: " *",
                style: TextStyle(color: AppColors.primary),
              ),
          ],
        ),
      ),
    );
  }
}
