import 'package:arena/config/design/status_color_config.dart';
import 'package:arena/config/theme/app_colors.dart';
import 'package:arena/models/enums/enums.dart';
import 'package:arena/models/order/order_list_model.dart';
import 'package:arena/helper/time_helper.dart';
import 'package:flutter/material.dart';
import 'package:arena/components/custom_spacing.dart';
import 'package:arena/components/custom_text.dart';
import 'dart:async';
import 'package:arena/components/order_status_badge.dart';
import '../../bloc/order_state.dart';

class CsOrderCard extends StatefulWidget {
  final OrderListDatum order;
  final OrderState state;
  final VoidCallback? onTap;

  const CsOrderCard({
    super.key,
    required this.order,
    required this.state,
    this.onTap,
  });

  @override
  State<CsOrderCard> createState() => _CsOrderCardState();
}

class _CsOrderCardState extends State<CsOrderCard> {
  late final Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = OrderConfig.getStyle(
      widget.order.orderStatus ?? OrderStatus.NEED_PICKUP,
    );

    final allItems = widget.order.items ?? [];

    final serviceItems = allItems
        .where((item) => item.type == ItemType.SERVICE)
        .toList();
    final productItems = allItems
        .where((item) => item.type != ItemType.SERVICE)
        .toList();

    final displayedProduct = productItems.take(2).toList();

    final hiddenProductCount = productItems.length - displayedProduct.length;

    final summaryParts = <String>[
      if (productItems.isNotEmpty) "${productItems.length} item",
      if (serviceItems.isNotEmpty) "${serviceItems.length} service",
    ];
    final summaryText = summaryParts.isNotEmpty
        ? summaryParts.join(" & ")
        : "0 item";
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: widget.onTap,
      child: Ink(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: SupportAppColors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                OrderStatusBadge(paymentStatus: widget.order.paymentStatus),
                OrderStatusBadge(orderStatus: widget.order.orderStatus),
              ],
            ),

            const CustomSpacing(height: 12),

            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Icon(
                        Icons.person_outline,
                        size: 17,
                        color: SupportAppColors.greyColor,
                      ),
                      const CustomSpacing(width: 6),
                      Expanded(
                        child: CustomText(
                          text: widget.order.displayCustomerName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const CustomSpacing(width: 12),
                Row(
                  children: [
                    const Icon(
                      Icons.directions_car_outlined,
                      size: 17,
                      color: SupportAppColors.greyColor,
                    ),
                    const CustomSpacing(width: 6),
                    CustomText(
                      text: widget.order.displayVehiclePlate,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const Divider(height: 10),

            const CustomSpacing(height: 8),

            CustomText(
              text: widget.order.displayInvoiceNumber,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),

            const CustomSpacing(height: 4),

            CustomText(
              text: formatTime(widget.order.createdAt ?? DateTime.now()),
              style: const TextStyle(
                fontSize: 11,
                color: SupportAppColors.greyColor,
              ),
            ),

            const CustomSpacing(height: 12),
            ...displayedProduct.map((item) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    Icon(Icons.circle, size: 6, color: style.foreground),
                    const CustomSpacing(width: 8),
                    Expanded(
                      child: CustomText(
                        text: item.displayName,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    CustomText(
                      text: "${item.displayQuantity} pcs",
                      style: TextStyle(
                        fontSize: 12,
                        color: style.foreground,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            }),
            if (hiddenProductCount > 0)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: CustomText(
                  text: "+$hiddenProductCount product lainnya",
                  style: const TextStyle(
                    fontSize: 11,
                    color: SupportAppColors.greyColor,
                  ),
                ),
              ),
            const CustomSpacing(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: summaryText,
                  style: const TextStyle(
                    fontSize: 11,
                    color: SupportAppColors.greyColor,
                  ),
                ),
                CustomText(
                  text: widget.order.displayFinalAmount,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
