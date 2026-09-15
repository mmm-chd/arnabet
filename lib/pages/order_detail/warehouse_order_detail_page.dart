import 'package:arena/components/custom_button.dart';
import 'package:arena/components/custom_spacing.dart';
import 'package:arena/components/custom_text.dart';
import 'package:arena/components/order_status_badge.dart';
import 'package:arena/config/design/app_snack_bar.dart';
import 'package:arena/config/theme/app_colors.dart';
import 'package:arena/models/enums/enums.dart';
import 'package:arena/pages/order_detail/bloc/order_detail_bloc.dart';
import 'package:arena/pages/order_detail/bloc/order_detail_event.dart';
import 'package:arena/pages/order_detail/bloc/order_detail_state.dart';
import 'package:arena/pages/order_detail/components/order_detail_app_bar.dart';
import 'package:arena/pages/order_detail/components/order_item_sections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WarehouseOrderDetailPage extends StatelessWidget {
  final String orderId;
  final String invoiceNumber;

  const WarehouseOrderDetailPage({
    super.key,
    required this.orderId,
    required this.invoiceNumber,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          OrderDetailBloc()..add(OrderDetailFetched(orderId: orderId)),
      child: _WarehouseOrderDetailView(
        orderId: orderId,
        invoiceNumber: invoiceNumber,
      ),
    );
  }
}

class _WarehouseOrderDetailView extends StatelessWidget {
  final String orderId;
  final String invoiceNumber;

  const _WarehouseOrderDetailView({
    required this.orderId,
    required this.invoiceNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: BlocConsumer<OrderDetailBloc, OrderDetailState>(
        listener: (context, state) {
          if (state.isFailure && state.errorMessage != null) {
            AppSnackBar.error(context: context, message: state.errorMessage!);
          }
        },
        builder: (context, state) {
          if (state.isInitial || state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.isFailure && !state.hasOrders) {
            return Center(
              child: CustomText(
                text: state.errorMessage ?? "Gagal memuat detail order",
              ),
            );
          }

          if (state.order == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final status = state.order!.orderStatus ?? OrderStatus.NEED_PICKUP;
          final isPickedUp =
              status == OrderStatus.PROCESSING ||
              status == OrderStatus.COMPLETED ||
              status == OrderStatus.CANCELLED;

          return Stack(
            children: [
              CustomScrollView(
                slivers: [
                  OrderDetailSliverAppBar(fallbackTitle: invoiceNumber),
                  SliverToBoxAdapter(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...OrderItemSections.build(
                          items: state.orders,
                          showPrice: false,
                        ),
                        const CustomSpacing(height: 160),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                  decoration: const BoxDecoration(
                    color: SupportAppColors.white,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const CustomText(
                            text: "Status Pesanan",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                          OrderStatusBadge(orderStatus: status),
                        ],
                      ),
                      const CustomSpacing(height: 24),
                      CustomButton(
                        text: state.isSubmitting
                            ? "Mengambil..."
                            : isPickedUp
                            ? "Sudah Diambil"
                            : "Konfirmasi Pengambilan",
                        backgroundColor: state.isSubmitting
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
                        onPressed: (isPickedUp || state.isSubmitting)
                            ? () {}
                            : () {
                                context.read<OrderDetailBloc>().add(
                                  OrderDetailMarkedAsPickedUp(orderId: orderId),
                                );
                              },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
