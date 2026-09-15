import 'package:arena/components/custom_spacing.dart';
import 'package:arena/config/design/custom_icons.dart';
import 'package:arena/components/custom_text.dart';
import 'package:arena/components/order_status_badge.dart';
import 'package:arena/config/theme/app_colors.dart';
import 'package:arena/helper/time_helper.dart';
import 'package:arena/models/enums/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:arena/models/order/order_list_model.dart';

class CashierOrderCard extends StatelessWidget {
  final OrderListDatum order;
  final VoidCallback? onTap;
  final VoidCallback? onCancel;
  final VoidCallback? onConfirmPayment;

  const CashierOrderCard({
    super.key,
    required this.order,
    this.onTap,
    this.onCancel,
    this.onConfirmPayment,
  });

  @override
  Widget build(BuildContext context) {
    final allItems = order.items ?? [];

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
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Ink(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                OrderStatusBadge(paymentStatus: order.paymentStatus),
                OrderStatusBadge(
                  orderStatus: order.orderStatus ?? OrderStatus.NEED_PICKUP,
                ),
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
              text: order.displayCustomerName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
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
          text: order.displayVehiclePlate,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  ],
),

const CustomSpacing(height: 8),


CustomText(
  text: order.displayInvoiceNumber,
  maxLines: 1,
  overflow: TextOverflow.ellipsis,
  style: const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
  ),
),

const CustomSpacing(height: 4),


CustomText(
  text: formatTime(order.createdAt),
  style: const TextStyle(
    fontSize: 11,
    color: SupportAppColors.greyColor,
  ),
),

const CustomSpacing(height: 10),

            ...displayedProduct.map(
              (e) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: const BoxDecoration(
                            color: Colors.black87,
                            shape: BoxShape.circle,
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.black87,
                            ),
                            children: [
                              TextSpan(
                                text: '${e.displayName} ',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    CustomText(
                      text: '${e.quantity ?? 0} pcs',
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),

            if (hiddenProductCount > 0)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: CustomText(
                  text: '+$hiddenProductCount product lainnya',
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ),

            const CustomSpacing(height: 6),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: summaryText,
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
                CustomText(
                  text: order.displayFinalAmount,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const CustomSpacing(height: 12),

            _buildActionArea(),
          ],
        ),
      ),
    );
  }

  Widget _buildActionArea() {
    final status = order.orderStatus ?? OrderStatus.NEED_PICKUP;
    final isCash = order.paymentMethod == PaymentMethod.CASH;
    final isPaid = order.paymentStatus == PaymentStatus.PAID;
    final needsPaymentConfirmation = isCash && !isPaid;
    final canProgress =
        status == OrderStatus.NEED_PICKUP || status == OrderStatus.PROCESSING;
    final canCancel = !isPaid && canProgress;

    if (status == OrderStatus.COMPLETED) {
      return _outlineGreen();
    }
    if (status == OrderStatus.CANCELLED) {
      return _outlineRed();
    }
    if (isCash && canProgress) {
      if (needsPaymentConfirmation) {
        return Row(
          children: [
            if (canCancel) ...[
              _cancelButton(onCancel),
              const CustomSpacing(width: 10),
            ],
            Expanded(child: _confirmButton(onConfirmPayment)),
          ],
        );
      }
      if (status == OrderStatus.NEED_PICKUP) {
        return const SizedBox.shrink();
      }
      return _outlineGreen();
    }
    if (canCancel) {
      return _cancelWideButton(onCancel);
    }
    return const SizedBox.shrink();
  }

  Widget _confirmButton(VoidCallback? onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: SupportAppColors.normalGreen,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.payments, color: SupportAppColors.white, size: 16),
            const CustomSpacing(width: 6),
            const CustomText(
              text: 'Konfirmasi Pembayaran',
              style: TextStyle(
                color: SupportAppColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _outlineGreen() {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        border: Border.all(color: SupportAppColors.normalGreen),
        color: SupportAppColors.lightGreen.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Center(
        child: CustomText(
          text: 'Selesai',
          style: TextStyle(
            color: SupportAppColors.normalGreen,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _outlineRed() {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        border: Border.all(color: SupportAppColors.normalRed),
        color: SupportAppColors.lightRed,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Center(
        child: CustomText(
          text: 'Dibatalkan',
          style: TextStyle(
            color: SupportAppColors.normalRed,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _cancelWideButton(VoidCallback? onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: SupportAppColors.lightRed,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              CustomIcons.x,
              width: 16,
              height: 16,
              colorFilter: const ColorFilter.mode(
                SupportAppColors.normalRed,
                BlendMode.srcIn,
              ),
            ),
            const CustomSpacing(width: 8),
            const CustomText(
              text: 'Batalkan Pesanan',
              style: TextStyle(
                color: SupportAppColors.normalRed,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cancelButton(VoidCallback? onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: SupportAppColors.lightRed,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: SvgPicture.asset(
            CustomIcons.x,
            width: 16,
            height: 16,
            colorFilter: const ColorFilter.mode(
              SupportAppColors.normalRed,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}
