import 'package:arena/components/bottom_sheet/custom_bottom_sheet_v2.dart';
import 'package:arena/components/custom_spacing.dart';
import 'package:arena/config/design/custom_icons.dart';
import 'package:arena/config/theme/app_colors.dart';
import 'package:arena/pages/product/components/add_size_sheet/add_size_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'product_sheet.dart';
import 'package:arena/components/custom_text.dart';

class ProductBottomSheet {
  static Widget _buildMenu({
    Widget? icon,
    required Color borderColor,
    required Color containerColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            border: Border.all(color: SupportAppColors.greyMidColor),
            borderRadius: BorderRadius.circular(16),
            color: SupportAppColors.greyMidTermColor,
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: containerColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderColor),
                ),
                child: Center(child: icon),
              ),

              const CustomSpacing(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const CustomSpacing(height: 2),

                    CustomText(
                      text: subtitle,
                      style: const TextStyle(
                        fontSize: 13,
                        color: SupportAppColors.greyColor,
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.chevron_right,
                color: SupportAppColors.greyColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void show(BuildContext context, bool isOwner) {
    CustomBottomSheetV2.show(
      context,
      title: 'Tambahkan',
      children: [
        _buildMenu(
          borderColor: SupportAppColors.normalOrange,
          icon: SvgPicture.asset(
            CustomIcons.radix,
            width: 22,
            height: 22,
            color: SupportAppColors.normalOrange,
          ),
          containerColor: SupportAppColors.lightOrange,
          title: "Ukuran",
          subtitle: "Tambah ukuran tipe sekarang",
          onTap: () {
            context.pop();
            AddSizeSheet.show(context, isOwner: isOwner);
          },
        ),

        const CustomSpacing(height: 12),

        _buildMenu(
          borderColor: SupportAppColors.normalRed,
          icon: SvgPicture.asset(
            CustomIcons.produk,
            width: 22,
            height: 22,
            color: SupportAppColors.normalRed,
          ),
          containerColor: SupportAppColors.lightRed,
          title: "Produk",
          subtitle: "Tambah produk sekarang",
          onTap: () {
            context.pop();
            ProductSheet.show(context);
          },
        ),
      ],
    );
  }
}
