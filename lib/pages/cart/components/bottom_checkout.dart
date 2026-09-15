import 'package:arena/config/theme/app_colors.dart';
import 'package:arena/helper/currency_local_formatter.dart';
import 'package:flutter/material.dart';
import 'package:arena/components/custom_spacing.dart';
import 'package:arena/components/custom_text.dart';
import 'package:go_router/go_router.dart';
import 'package:arena/config/routes/app_routes.dart';

class BottomCheckout extends StatelessWidget {
  final int total;

  const BottomCheckout({super.key, required this.total});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        12,
        16,
        16 + MediaQuery.of(context).padding.bottom,
      ),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomText(
                  text: total.toLocaleCurrency(),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                CustomSpacing(height: 2),
                CustomSpacing(height: 2),
                Row(
                  children: [
                    CustomText(
                      text: 'Rp 300.000',
                      style: TextStyle(
                        decoration: TextDecoration.lineThrough,
                        color: Colors.black45,
                        fontSize: 12,
                      ),
                    ),
                    CustomSpacing(width: 6),
                    CustomText(
                      text: '3%',
                      style: TextStyle(
                        color: SupportAppColors.normalRed,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          CustomSpacing(
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                context.push(AppRoutes.checkoutCart);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: SupportAppColors.normalRed,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 32),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const CustomText(
                text: 'Beli',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
