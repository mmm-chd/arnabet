import 'package:arena/components/custom_button.dart';
import 'package:arena/components/icon_button/custom_icon_button_circle.dart';
import 'package:arena/components/custom_spacing.dart';
import 'package:arena/components/custom_text.dart';
import 'package:arena/config/design/app_snack_bar.dart';
import 'package:arena/config/routes/nav_routes.dart';
import 'package:arena/config/theme/app_colors.dart';
import 'package:arena/pages/cart/bloc/cart_bloc.dart';
import 'package:arena/pages/cart/bloc/cart_event.dart';
import 'package:arena/pages/cart/bloc/cart_state.dart';
import 'package:arena/pages/order_list/bloc/order_bloc.dart';
import 'package:arena/pages/order_list/bloc/order_event.dart';
import 'package:arena/services/auth/user_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CheckoutCartPreviewPage extends StatelessWidget {
  final String nama;
  final String hp;
  final String kendaraan;
  final String plat;

  const CheckoutCartPreviewPage({
    super.key,
    required this.nama,
    required this.hp,
    required this.kendaraan,
    required this.plat,
  });

  String get _orderListTarget => NavRoutes.getOrderListRoute(UserSession.role);

  Widget buildItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: CustomText(
              text: title,
              style: TextStyle(color: SupportAppColors.greyColor, fontSize: 14),
            ),
          ),
          Expanded(
            flex: 2,
            child: CustomText(
              text: value,
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: SupportAppColors.greyDarkerColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCard(String title, List<Widget> children) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: SupportAppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: SupportAppColors.greyDarkerColor,
            ),
          ),
          const CustomSpacing(height: 12),
          ...children,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CartBloc, CartState>(
      listenWhen: (previous, current) =>
          previous.checkoutStatus != current.checkoutStatus,
      listener: (context, state) {
        if (state.isCheckoutSuccess) {
          AppSnackBar.success(
            context: context,
            message: state.checkoutMessage.isNotEmpty
                ? state.checkoutMessage
                : 'Order berhasil dibuat',
          );
          context.read<OrderBloc>().add(const LoadOrders());
          context.go(_orderListTarget);
        } else if (state.isCheckoutFailure) {
          AppSnackBar.error(
            context: context,
            message: state.checkoutMessage.isNotEmpty
                ? state.checkoutMessage
                : 'Gagal checkout',
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          leadingWidth: 72,
          leading: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: CustomIconbuttonCircle(
              prefixIcon: Icons.arrow_back,
              backgroundColor: Colors.white,
              iconColor: Colors.black,
              iconSize: 24,
              width: 40,
              height: 40,
              onPressed: () => context.pop(),
            ),
          ),
          titleSpacing: 16,
          title: const CustomText(
            text: "Tambah Order",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                buildCard("Informasi Customer", [
                  buildItem("Nama", nama),
                  buildItem("No Hp", hp),
                ]),
                buildCard("Informasi Kendaraan", [
                  buildItem("Kendaraan", kendaraan),
                  buildItem("Plat Nomor", plat),
                ]),
                const Spacer(),
                BlocBuilder<CartBloc, CartState>(
                  buildWhen: (previous, current) =>
                      previous.checkoutStatus != current.checkoutStatus,
                  builder: (context, state) {
                    return CustomButton(
                      text: state.isCheckoutSubmitting
                          ? "Memuat..."
                          : "Konfirmasi",
                      backgroundColor: AppColors.primary,
                      foregroundColor: SupportAppColors.white,
                      onPressed: state.isCheckoutSubmitting
                          ? null
                          : () {
                              context.read<CartBloc>().add(
                                Checkout(
                                  customerName: nama,
                                  phone: hp,
                                  vehicle: kendaraan,
                                  plate: plat,
                                ),
                              );
                            },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
