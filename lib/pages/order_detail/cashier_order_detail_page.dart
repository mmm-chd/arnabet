import 'dart:async';

import 'package:arena/components/bottom_sheet/custom_bottom_sheet.dart';
import 'package:arena/components/custom_spacing.dart';
import 'package:arena/components/custom_text.dart';
import 'package:arena/components/icon_button/custom_iconButton.dart';
import 'package:arena/config/design/app_snack_bar.dart';
import 'package:arena/config/routes/app_routes.dart';
import 'package:arena/config/theme/app_colors.dart';
import 'package:arena/models/enums/enums.dart';
import 'package:arena/models/order/order_detail_model.dart';
import 'package:arena/models/order/add_order_model.dart' as add_order;
import 'package:arena/pages/order_detail/bloc/order_detail_bloc.dart';
import 'package:arena/pages/order_detail/bloc/order_detail_event.dart';
import 'package:arena/pages/order_detail/bloc/order_detail_state.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:arena/config/design/custom_icons.dart';
import 'package:arena/pages/order_detail/components/order_detail_app_bar.dart';
import 'package:arena/pages/order_detail/components/order_item_sections.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:arena/components/order_status_badge.dart';
import 'package:flutter/material.dart';

class CashierOrderDetailPage extends StatelessWidget {
  final String orderId;

  const CashierOrderDetailPage({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          OrderDetailBloc()..add(OrderDetailFetched(orderId: orderId)),
      child: const _CashierOrderDetailView(),
    );
  }
}

class _CashierOrderDetailView extends StatelessWidget {
  const _CashierOrderDetailView();

  String _paymentMethodIcon(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.CASH:
        return CustomIcons.cash;
      case PaymentMethod.VIRTUAL_ACCOUNT:
        return CustomIcons.profileCard;
      case PaymentMethod.QRIS:
        return CustomIcons.qris;
    }
  }

  Widget _summaryRow(String title, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            text: title,
            style: const TextStyle(color: SupportAppColors.greyColor),
          ),
          CustomText(
            text: value,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: valueColor ?? SupportAppColors.greyDarkerColor,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: BlocConsumer<OrderDetailBloc, OrderDetailState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.isFailure && state.errorMessage != null) {
            AppSnackBar.error(context: context, message: state.errorMessage!);
          }
          if (state.isSuccess) {
            AppSnackBar.success(
              context: context,
              message: "Status order berhasil diperbarui",
            );
          }
          if (state.isCancelSuccess) {
            AppSnackBar.success(
              context: context,
              message: "Pesanan berhasil dibatalkan",
            );
            context.go(AppRoutes.orderListCashier);
          }
        },
        builder: (context, state) {
          if (state.isInitial || state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.order == null) {
            return Center(
              child: CustomText(
                text: state.errorMessage ?? "Gagal memuat detail order",
              ),
            );
          }

          final currentOrder = state.order!;
          final items = currentOrder.items ?? [];
          final status = currentOrder.orderStatus ?? OrderStatus.NEED_PICKUP;

          return Stack(
            children: [
              CustomScrollView(
                slivers: [
                  const OrderDetailSliverAppBar(),
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...OrderItemSections.build(items: items),
                        const CustomSpacing(height: 24),
                        Container(
                          color: SupportAppColors.white,
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 280),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const CustomText(
                                    text: "Order Summary",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  OrderStatusBadge(orderStatus: status),
                                ],
                              ),

                              const CustomSpacing(height: 18),

                              _summaryRow(
                                "Product Total",
                                currentOrder.displayProductTotal,
                              ),
                              _summaryRow(
                                "Add-On",
                                currentOrder.displayAddonTotal,
                              ),
                              _summaryRow(
                                "Sub-Total",
                                currentOrder.displayTotalAmount,
                              ),
                              const Divider(
                                thickness: 1,
                                color: SupportAppColors.greyMidColor,
                              ),
                              _summaryRow(
                                "Diskon",
                                valueColor: SupportAppColors.normalRed,
                                currentOrder.displayDiscountAmount,
                              ),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const CustomText(
                                    text: "Dibuat pada",
                                    style: TextStyle(
                                      color: SupportAppColors.greyDarkerColor,
                                    ),
                                  ),
                                  CustomText(
                                    text: currentOrder.displayCreatedAt,
                                    style: const TextStyle(
                                      color: SupportAppColors.greyDarkerColor,
                                    ),
                                  ),
                                ],
                              ),

                              const Divider(
                                height: 32,
                                color: SupportAppColors.greyMidColor,
                              ),

                              const CustomText(
                                text: "Pelanggan",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                ),
                              ),

                              const CustomSpacing(height: 16),

                              Material(
                                type: MaterialType.transparency,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(16),
                                  onTap: () {
                                    context.push(
                                      AppRoutes.customerDetail,
                                      extra: add_order.AddOrderModel(
                                        data: add_order.Data(
                                          customerName:
                                              currentOrder.displayCustomerName,
                                          customerPhone:
                                              currentOrder.displayCustomerPhone,
                                          vehicleModel:
                                              currentOrder.displayVehicleModel,
                                          vehiclePlate:
                                              currentOrder.displayVehiclePlate,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 24,
                                          backgroundColor:
                                              SupportAppColors.lightRed,
                                          child: const Icon(
                                            Icons.person,
                                            color: AppColors.primary,
                                          ),
                                        ),

                                        const CustomSpacing(width: 14),

                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              CustomText(
                                                text: currentOrder
                                                    .displayCustomerName,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),

                                              const CustomSpacing(height: 2),

                                              CustomText(
                                                text:
                                                    "${currentOrder.displayVehicleModel} • ${currentOrder.displayVehiclePlate}",
                                                style: const TextStyle(
                                                  color: SupportAppColors
                                                      .greyColor,
                                                  fontSize: 13,
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
                              ),

                              const Divider(
                                height: 32,
                                color: SupportAppColors.greyMidColor,
                              ),

                              const CustomText(
                                text: "Metode Pembayaran",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                ),
                              ),

                              const CustomSpacing(height: 16),

                              Row(
                                children: [
                                  if (currentOrder.paymentMethod != null) ...[
                                    Container(
                                      width: 46,
                                      height: 46,
                                      decoration: BoxDecoration(
                                        color: SupportAppColors.lightRed,
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      child: SvgPicture.asset(
                                        _paymentMethodIcon(
                                          currentOrder.paymentMethod!,
                                        ),
                                        width: 24,
                                        height: 24,
                                        colorFilter: ColorFilter.mode(
                                          AppColors.primary,
                                          BlendMode.srcIn,
                                        ),
                                        fit: BoxFit.scaleDown,
                                      ),
                                    ),

                                    const CustomSpacing(width: 14),
                                  ],
                                  Expanded(
                                    child: CustomText(
                                      text:
                                          currentOrder.displayPaymentMethod ==
                                              "-"
                                          ? "Metode pembayaran belum dipilih"
                                          : currentOrder.displayPaymentMethod,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: SupportAppColors.greyColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: BlocBuilder<OrderDetailBloc, OrderDetailState>(
                  builder: (context, state) {
                    if (state.order == null) return const SizedBox.shrink();
                    return _BottomBar(
                      order: state.order!,
                      isSubmitting: state.isSubmitting,
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  final OrderDetailData order;
  final bool isSubmitting;

  const _BottomBar({required this.order, required this.isSubmitting});

  void _showConfirmSheet(
    BuildContext context, {
    required String title,
    required String message,
    required String confirmText,
    required FutureOr<bool?> Function()? onConfirm,
  }) {
    CustomBottomsheet.show(
      context,
      title: title,
      initialChildSize: 0.4,
      onDismissed: () {},
      secondaryButtonText: 'Batal',
      primaryButtonText: confirmText,
      pBackgroundColor: AppColors.primary,
      sBackgroundColor: SupportAppColors.white,
      onReset: () {},
      onPressed: onConfirm,
      children: [
        CustomText(
          text: message,
          style: const TextStyle(fontSize: 16),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<OrderDetailBloc>();
    final status = order.orderStatus ?? OrderStatus.NEED_PICKUP;
    final isCash = order.paymentMethod == PaymentMethod.CASH;
    final isPaid = order.paymentStatus == PaymentStatus.PAID;
    final needsPaymentConfirmation = isCash && !isPaid;
    final canProgress =
        status == OrderStatus.NEED_PICKUP || status == OrderStatus.PROCESSING;
    final canCancel = !isPaid && canProgress;

    return Container(
      decoration: BoxDecoration(
        color: SupportAppColors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const CustomText(
                  text: "Total Harga",
                  style: TextStyle(
                    fontSize: 18,
                    color: SupportAppColors.greyColor,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if ((order.discountAmount ?? 0) > 0) ...[
                      CustomText(
                        text: order.displayTotalAmount,
                        style: const TextStyle(
                          fontSize: 14,
                          color: SupportAppColors.greyColor,
                          decoration: TextDecoration.lineThrough,
                          decorationColor: SupportAppColors.greyColor,
                        ),
                      ),
                    ],
                    CustomText(
                      text: order.displayFinalAmount,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 24,
                        color: isPaid
                            ? SupportAppColors.normalGreen
                            : AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            if (needsPaymentConfirmation || canCancel) ...[
              const CustomSpacing(height: 20),

              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (needsPaymentConfirmation && canCancel) ...[
                      _cancelSquare(context, bloc),
                      const CustomSpacing(width: 12),
                    ],
                    Expanded(
                      child: needsPaymentConfirmation
                          ? _paymentConfirmButton(context, bloc)
                          : CustomIconbutton(
                              text: "Batalkan Pesanan",
                              foregroundColor: SupportAppColors.normalRed,
                              backgroundColor: SupportAppColors.lightRed,
                              isCustom: true,
                              assetPath: CustomIcons.x,
                              iconWidth: 18,
                              iconHeight: 18,
                              onTap: isSubmitting
                                  ? null
                                  : () => _confirmCancel(context, bloc),
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _cancelSquare(BuildContext context, OrderDetailBloc bloc) {
    return InkWell(
      onTap: isSubmitting ? null : () => _confirmCancel(context, bloc),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 56,
        decoration: BoxDecoration(
          color: SupportAppColors.lightRed,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: SvgPicture.asset(
            CustomIcons.x,
            width: 20,
            height: 20,
            colorFilter: const ColorFilter.mode(
              AppColors.primary,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }

  Widget _paymentConfirmButton(BuildContext context, OrderDetailBloc bloc) {
    return CustomIconbutton(
      text: 'Konfirmasi Pembayaran',
      foregroundColor: SupportAppColors.lightGreen,
      backgroundColor: SupportAppColors.normalGreen,
      icon: Icons.check,
      iconColor: SupportAppColors.lightGreen,
      iconSize: 18,
      useDInfin: true,
      isLoading: isSubmitting,
      onTap: isSubmitting ? null : () => _confirmPayment(context, bloc),
    );
  }

  void _confirmPayment(BuildContext context, OrderDetailBloc bloc) {
    _showConfirmSheet(
      context,
      title: 'Konfirmasi Pembayaran',
      message:
          'Apakah anda yakin telah menerima uang tunai dari CS? Pembayaran pesanan ini akan ditandai LUNAS.',
      confirmText: 'Konfirmasi',
      onConfirm: () {
        bloc.add(
          OrderDetailPaymentConfirmed(
            orderId: order.id!,
            notes: 'Uang tunai diterima kasir',
          ),
        );
        return true;
      },
    );
  }

  void _confirmCancel(BuildContext context, OrderDetailBloc bloc) {
    _showConfirmSheet(
      context,
      title: 'Batalkan Pesanan',
      message: 'Apakah anda yakin ingin membatalkan pesanan ini?',
      confirmText: 'Batalkan',
      onConfirm: () {
        bloc.add(OrderDetailCancelled(orderId: order.id!));
        return true;
      },
    );
  }
}
