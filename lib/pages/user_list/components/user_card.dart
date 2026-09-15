import 'package:arena/components/custom_avatar.dart';
import 'package:arena/config/theme/app_colors.dart';
import 'package:arena/helper/string_extension_helper.dart';
import 'package:flutter/material.dart';
import 'package:arena/components/custom_text.dart';
import 'package:arena/components/custom_spacing.dart';

class UserCard extends StatelessWidget {
  final String name;
  final String email;
  final String role;
  final String image;
  final VoidCallback? onTap;

  const UserCard({
    super.key,
    required this.name,
    required this.email,
    required this.role,
    required this.image,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              CustomAvatar(radius: 22, name: name, imageUrl: image),

              const CustomSpacing(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      maxLines: 1,
                      text: name.toTitleCase(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const CustomSpacing(height: 2),

                    CustomText(
                      maxLines: 1,
                      text: email,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.keyboard_arrow_right,
                color: SupportAppColors.greyDarkColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
