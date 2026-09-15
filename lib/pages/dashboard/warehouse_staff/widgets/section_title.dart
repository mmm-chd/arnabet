import 'package:flutter/material.dart';
import 'package:arena/components/custom_spacing.dart';
import 'package:arena/components/custom_text.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;

  const SectionTitle({
    super.key,
    required this.title,
    this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // 🔥 penting
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// TEXT
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(text: title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600, // 🔥 lebih soft dari bold
                ),
              ),
              if (subtitle != null) ...[
                const CustomSpacing(height: 2),
                CustomText(text: subtitle!,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xff9E9E9E), // 🔥 abu design
                  ),
                ),
              ]
            ],
          ),

          /// ARROW
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(20),
            child: const Padding(
              padding: EdgeInsets.all(4),
              child: Icon(
                Icons.chevron_right,
                size: 18, // 🔥 lebih kecil
                color: Color(0xffBDBDBD), // 🔥 lebih soft
              ),
            ),
          )
        ],
      ),
    );
  }
}