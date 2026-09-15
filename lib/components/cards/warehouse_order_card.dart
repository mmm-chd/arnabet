import 'package:arena/components/custom_button.dart';
import 'package:arena/components/custom_spacing.dart';
import 'package:arena/components/custom_text.dart';
import 'package:arena/config/design/status_color_config.dart';
import 'package:arena/config/theme/app_colors.dart';
import 'package:arena/helper/time_helper.dart';
import 'package:arena/models/enums/enums.dart';
import 'package:arena/models/order/order_list_model.dart';
import 'package:flutter/material.dart';

class WarehouseOrderCard extends StatelessWidget {
  final String invoiceNumber;
  final OrderStatus status;
  final DateTime? createdAt;
  final List<OrderListItem> items;
  final bool isPickedUp;
  final bool isLoading;

  final bool firstItem;
  final bool lastItem;

  final VoidCallback? onTap;
  final VoidCallback? onConfirmPickup;

  const WarehouseOrderCard({
    super.key,
    required this.invoiceNumber,
    required this.status,
    required this.createdAt,
    required this.items,
    required this.isPickedUp,
    this.isLoading = false,
    this.firstItem = true,
    this.lastItem = true,
    this.onTap,
    this.onConfirmPickup,
  });

  @override
  Widget build(BuildContext context) {
    final style = OrderConfig.getStyle(status);
    final isDone = status == OrderStatus.COMPLETED;

    final radius = BorderRadius.only(
      topLeft: Radius.circular(firstItem ? 16 : 0),
      topRight: Radius.circular(firstItem ? 16 : 0),
      bottomLeft: Radius.circular(lastItem ? 16 : 0),
      bottomRight: Radius.circular(lastItem ? 16 : 0),
    );

    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: InkWell(
        borderRadius: radius,
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.only(bottom: lastItem ? 14 : 0),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: Colors.white, borderRadius: radius),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: invoiceNumber,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: style.background,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          margin: const EdgeInsets.only(right: 6),
                          decoration: BoxDecoration(
                            color: style.foreground,
                            shape: BoxShape.circle,
                          ),
                        ),
                        CustomText(
                          text: status.toIndonesian(),
                          style: TextStyle(
                            color: style.foreground,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const CustomSpacing(height: 4),

              CustomText(
                text: formatTime(createdAt),
                style: TextStyle(fontSize: 11, color: Colors.grey[500]),
              ),

              const CustomSpacing(height: 10),

              ...List.generate(items.length > 2 ? 2 : items.length, (index) {
                final item = items[index];
                final name = item.displayName;
                final qty = item.quantity ?? 0;

                final parts = name.split(" ");
                final title = parts.take(2).join(" ");
                final subtitle = parts.length > 2
                    ? parts.skip(2).join(" ")
                    : "";

                return Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      Container(
                        width: 5,
                        height: 5,
                        margin: const EdgeInsets.only(right: 6),
                        decoration: BoxDecoration(
                          color: isDone
                              ? SupportAppColors.normalGreen
                              : SupportAppColors.greyColor,
                          shape: BoxShape.circle,
                        ),
                      ),

                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: title,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: SupportAppColors.greyDarkerColor,
                                ),
                              ),
                              if (subtitle.isNotEmpty)
                                TextSpan(
                                  text: " $subtitle",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: SupportAppColors.greyDarkerColor,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),

                      CustomText(
                        text: "$qty pcs",
                        style: TextStyle(
                          fontSize: 12,
                          color: isDone
                              ? SupportAppColors.normalGreen
                              : SupportAppColors.greyDarkerColor,
                        ),
                      ),
                    ],
                  ),
                );
              }),

              if (items.length > 2)
                CustomText(
                  text: "+${items.length - 2} item lainnya",
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[500],
                    fontStyle: FontStyle.italic,
                  ),
                ),

              const CustomSpacing(height: 12),

              Container(height: 1, color: SupportAppColors.greyMidColor),

              const CustomSpacing(height: 12),

              CustomButton(
                height: 4,
                text: isLoading
                    ? 'Mengambil...'
                    : isPickedUp
                    ? "Sudah Diambil"
                    : "Konfirmasi Pengambilan",
                backgroundColor: isLoading
                    ? SupportAppColors.greyMidColor
                    : isPickedUp
                    ? SupportAppColors.lightGreen
                    : AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: isPickedUp
                        ? SupportAppColors.normalGreen
                        : Colors.transparent,
                  ),
                ),
                foregroundColor: isPickedUp
                    ? SupportAppColors.normalGreen
                    : SupportAppColors.white,
                onPressed: isPickedUp ? () {} : onConfirmPickup,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
