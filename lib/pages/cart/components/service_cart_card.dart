import 'package:arena/components/custom_spacing.dart';
import 'package:arena/components/custom_text.dart';
import 'package:arena/config/design/custom_icons.dart';
import 'package:arena/config/theme/app_colors.dart';
import 'package:arena/helper/currency_local_formatter.dart';
import 'package:arena/models/cart/cart_list_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ServiceCartCard extends StatelessWidget {
  final Item item;
  final VoidCallback onDelete;
  final bool isSyncing;

  const ServiceCartCard({
    super.key,
    required this.item,
    required this.onDelete,
    this.isSyncing = false,
  });

  @override
  Widget build(BuildContext context) {
    final subtotal =
        item.subtotal ?? ((item.unitPrice ?? 0) * (item.quantity ?? 0));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: SupportAppColors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: SupportAppColors.lightOrange,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.build_outlined,
                size: 20,
                color: SupportAppColors.normalOrange,
              ),
            ),
            const CustomSpacing(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: item.displayServiceName,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const CustomSpacing(height: 4),
                  CustomText(
                    text: subtotal.toLocaleCurrency(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: SupportAppColors.greyColor,
                    ),
                  ),
                ],
              ),
            ),
            if (isSyncing)
              const Padding(
                padding: EdgeInsets.only(right: 12),
                child: SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 1.5),
                ),
              ),
            GestureDetector(
              onTap: onDelete,
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: SupportAppColors.lightRed,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(9),
                child: SvgPicture.asset(
                  CustomIcons.x,
                  color: SupportAppColors.normalRed,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
