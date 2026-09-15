import 'package:arena/components/custom_button.dart';
import 'package:arena/config/routes/app_routes.dart';
import 'package:arena/config/theme/app_colors.dart';
import 'package:arena/models/stock/stock_detail_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:arena/pages/cart/bloc/cart_bloc.dart';
import 'package:arena/pages/cart/bloc/cart_event.dart';
import 'package:arena/pages/cart/bloc/cart_state.dart';
import 'package:go_router/go_router.dart';
import '../cart_sheet.dart';

class BottomBar extends StatelessWidget {
  final StockDetailData stock;

  const BottomBar({super.key, required this.stock});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.all(16),
        color: SupportAppColors.white,
        child: CustomButton(
          text: "Tambahkan ke keranjang",
          backgroundColor: AppColors.primary,
          foregroundColor: SupportAppColors.white,
          onPressed: () async {
            final bloc = context.read<CartBloc>();

            final result = await showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => CartSheet(stock: stock),
            );

            if (result != null) {
              bloc.add(
                AddToCart(
                  stockId: result["stock_id"],
                  quantity: result["qty"],
                ),
              );
              await bloc.stream.firstWhere(
                (s) =>
                    s.status == CartListStatus.success ||
                    s.status == CartListStatus.failure,
              );

              if (context.mounted) {
                context.push(AppRoutes.cartList);
              }
            }
          },
        ),
      ),
    );
  }
}
