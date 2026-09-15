import 'package:arena/components/icon_button/custom_icon_button_circle.dart';
import 'package:arena/components/custom_text.dart';
import 'package:arena/config/theme/app_colors.dart';
import 'package:arena/pages/order_detail/bloc/order_detail_bloc.dart';
import 'package:arena/pages/order_detail/bloc/order_detail_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class OrderDetailSliverAppBar extends StatelessWidget {
  final String fallbackTitle;
  final VoidCallback? onMorePressed;

  const OrderDetailSliverAppBar({
    super.key,
    this.fallbackTitle = "-",
    this.onMorePressed,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: AppColors.bgColor,
      elevation: 0,
      floating: true,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      leadingWidth: 72,
      leading: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: CustomIconbuttonCircle(
          prefixIcon: Icons.arrow_back,
          backgroundColor: SupportAppColors.white,
          iconColor: SupportAppColors.greyDarkerColor,
          iconSize: 24,
          width: 40,
          height: 40,
          onPressed: () {
            context.pop();
          },
        ),
      ),
      titleSpacing: 16,
      title: BlocBuilder<OrderDetailBloc, OrderDetailState>(
        builder: (context, state) {
          return CustomText(
            text: state.order?.displayInvoiceNumber ?? fallbackTitle,
            style: const TextStyle(
              color: SupportAppColors.greyDarkerColor,
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          );
        },
      ),
      actionsPadding: const EdgeInsets.only(right: 16),
      actions: [],
    );
  }
}
