import 'package:arena/config/design/status_color_config.dart';
import 'package:arena/models/enums/enums.dart';
import 'package:flutter/material.dart';
import 'package:arena/components/custom_spacing.dart';
import 'package:arena/components/custom_text.dart';

class OrderStatusBadge extends StatelessWidget {
  final OrderStatus? orderStatus;
  final PaymentStatus? paymentStatus;

  const OrderStatusBadge({
    super.key,
    this.orderStatus,
    this.paymentStatus,
  });

  @override
  Widget build(BuildContext context) {
    if (paymentStatus != null) {
      final style = PaymentConfig.getStyle(paymentStatus!);
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: style.background,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.circle, size: 8, color: style.foreground),
            const CustomSpacing(width: 5),
            CustomText(
              text: paymentStatus!.toIndonesian(),
              style: TextStyle(
                fontSize: 12,
                color: style.foreground,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }
    if (orderStatus != null) {
      final style = OrderConfig.getStyle(orderStatus!);
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: style.background,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.circle, size: 8, color: style.foreground),
            const CustomSpacing(width: 5),
            CustomText(
              text: orderStatus!.toIndonesian(),
              style: TextStyle(
                fontSize: 12,
                color: style.foreground,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }
    return SizedBox.shrink();
  }
}
