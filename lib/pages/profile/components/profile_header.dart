import 'package:arena/components/custom_avatar.dart';
import 'package:arena/components/icon_button/custom_icon_button_circle.dart';
import 'package:arena/components/custom_spacing.dart';
import 'package:arena/components/custom_text.dart';
import 'package:arena/config/theme/app_colors.dart';
import 'package:arena/helper/role_formatter.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfileHeader extends StatelessWidget {
  final String email;
  final String name;
  final String role;
  final String? imageUrl;
  const ProfileHeader({
    super.key,
    required this.email,
    required this.name,
    required this.role,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              CustomIconbuttonCircle(
                prefixIcon: Icons.arrow_back,
                iconColor: Colors.black,
                backgroundColor: Colors.white,
                iconSize: 24,
                width: 52,
                height: 52,
                onPressed: () {
                  context.pop();
                },
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: CustomText(
                    text: email,
                    maxLines: 1,
                    style: const TextStyle(fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const CustomSpacing(width: 48),
            ],
          ),
        ),

        const CustomSpacing(height: 10),

        CustomAvatar(radius: 40, name: name, imageUrl: imageUrl),

        const CustomSpacing(height: 10),

        CustomText(
          text: name,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),

        CustomText(
          text: role.toRoleFormatter(),
          style: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
