import 'package:arena/components/current_user_avatar.dart';
import 'package:flutter/material.dart';
import 'package:arena/components/custom_spacing.dart';
import 'package:arena/components/custom_text.dart';

class GreetingHeader extends StatelessWidget {
  const GreetingHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(text: "Dashboard", style: TextStyle(fontSize: 18)),
            CustomSpacing(height: 4),
            CustomText(text: "Selamat Pagi Arif Gudang!",
                style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        CurrentUserAvatar(),
      ],
    );
  }
}