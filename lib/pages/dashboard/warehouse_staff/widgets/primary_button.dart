import 'package:arena/components/custom_spacing.dart';
import 'package:arena/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:arena/components/custom_text.dart';

class PrimaryButton extends StatelessWidget {
  final String text;

  const PrimaryButton({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return CustomSpacing(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: SupportAppColors.normalRed,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: () {},
        child: CustomText(text: text),
      ),
    );
  }
}