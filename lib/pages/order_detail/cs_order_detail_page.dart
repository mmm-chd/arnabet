import 'dart:async';

import 'package:arena/components/bottom_sheet/custom_bottom_sheet.dart';
import 'package:arena/components/custom_spacing.dart';
import 'package:arena/components/custom_switch.dart';
import 'package:arena/components/custom_text.dart';
import 'package:arena/components/custom_button.dart';
import 'package:arena/components/icon_button/custom_iconButton.dart';
import 'package:arena/components/order_status_badge.dart';
import 'package:arena/components/state/error_state_widget.dart';
import 'package:arena/config/design/app_snack_bar.dart';
import 'package:arena/config/design/custom_icons.dart';
import 'package:arena/config/theme/app_colors.dart';
import 'package:arena/models/enums/enums.dart';
import 'package:arena/models/order/order_detail_model.dart';
import 'package:arena/pages/order_detail/bloc/order_detail_bloc.dart';
import 'package:arena/pages/order_detail/bloc/order_detail_event.dart';
import 'package:arena/pages/order_detail/bloc/order_detail_state.dart';
import 'package:arena/pages/order_detail/components/order_detail_app_bar.dart';
import 'package:arena/pages/order_detail/components/order_item_sections.dart';
import 'package:arena/pages/order_detail/components/payment_radio_tile.dart';
import 'package:arena/config/routes/app_routes.dart';
import 'package:arena/models/order/add_order_model.dart' as add_order;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

class CsOrderDetailPage extends StatelessWidget {
  final String orderId;

  const CsOrderDetailPage({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          OrderDetailBloc()..add(OrderDetailFetched(orderId: orderId)),
      child: _CsOrderDetailView(orderId: orderId),
    );
  }
}

class _CsOrderDetailView extends StatefulWidget {
  final String orderId;
  const _CsOrderDetailView({required this.orderId});

  @override
  State<_CsOrderDetailView> createState() => _CsOrderDetailViewState();
}

class _CsOrderDetailViewState extends State<_CsOrderDetailView>
    with WidgetsBindingObserver {
  String _selectedPayment = "VIRTUAL_ACCOUNT";
  String _selectedBank = "BCA";
  bool _vaExpanded = false;
  bool _hideName = false;

  static const List<Map<String, String>> _banks = [
    {"code": "BCA", "name": "Bank Central Asia"},
  ];

  Timer? _refreshTimer;
  static const _refreshInterval = Duration(seconds: 10);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _startAutoRefresh();
  }

  @override
  void dispose() {
    _stopAutoRefresh();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _startAutoRefresh();
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _stopAutoRefresh();
    }
  }

  void _startAutoRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(_refreshInterval, (_) => _onRefreshTick());
  }

  void _stopAutoRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = null;
  }

  void _onRefreshTick() {
    if (!mounted) return;
    if (ModalRoute.of(context)?.isCurrent != true) return;
    final bloc = context.read<OrderDetailBloc>();
    if (bloc.state.order?.paymentStatus == PaymentStatus.PAID) {
      _stopAutoRefresh();
      return;
    }
    bloc.add(OrderDetailRefreshRequested(orderId: widget.orderId));
  }

  Widget _buildPaidPaymentRow(OrderDetailData order) {
    final method = order.paymentMethod;
    final icon = switch (method) {
      PaymentMethod.CASH => CustomIcons.cash,
      PaymentMethod.QRIS => CustomIcons.qris,
      PaymentMethod.VIRTUAL_ACCOUNT || null => CustomIcons.profileCard,
    };
    return Row(
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: SupportAppColors.lightRed,
            borderRadius: BorderRadius.circular(14),
          ),
          child: SvgPicture.asset(
            icon,
            width: 4,
            height: 4,
            colorFilter: ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
            fit: BoxFit.scaleDown,
          ),
        ),
        const CustomSpacing(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: method?.toIndonesian() ?? "Tidak diketahui",
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              const CustomSpacing(height: 2),
              const CustomText(
                text: "Sudah dibayar",
                style: TextStyle(
                  color: SupportAppColors.greyColor,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        const Icon(
          Icons.check_circle,
          color: SupportAppColors.normalGreen,
          size: 22,
        ),
      ],
    );
  }

  Widget _buildPendingPaymentRow(OrderDetailData order) {
    final method = order.paymentMethod;
    final icon = switch (method) {
      PaymentMethod.CASH => CustomIcons.cash,
      PaymentMethod.QRIS => CustomIcons.qris,
      PaymentMethod.VIRTUAL_ACCOUNT || null => CustomIcons.profileCard,
    };
    return Row(
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: SupportAppColors.lightRed,
            borderRadius: BorderRadius.circular(14),
          ),
          child: SvgPicture.asset(
            icon,
            width: 4,
            height: 4,
            colorFilter: ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
            fit: BoxFit.scaleDown,
          ),
        ),
        const CustomSpacing(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: method?.toIndonesian() ?? "Tidak diketahui",
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              const CustomSpacing(height: 2),
              const CustomText(
                text: "Menunggu konfirmasi",
                style: TextStyle(
                  color: SupportAppColors.greyColor,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: SupportAppColors.normalOrange,
          ),
        ),
      ],
    );
  }

  Widget _buildBankSelector() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: SupportAppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: SupportAppColors.greyMidColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: "Pilih Bank • $_selectedBank",
            style: const TextStyle(
              color: SupportAppColors.greyColor,
              fontSize: 13,
            ),
          ),
          const CustomSpacing(height: 12),
          ..._banks.map(_buildBankOption),
        ],
      ),
    );
  }

  Widget _buildBankOption(Map<String, String> bank) {
    final selected = bank["code"] == _selectedBank;
    return InkWell(
      onTap: () => setState(() => _selectedBank = bank["code"]!),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: SupportAppColors.lightRed,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: CustomText(
                    text: bank["code"]!,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 11,
                    ),
                  ),
                ),
              ),
            ),
            const CustomSpacing(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: bank["name"]!,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  CustomText(
                    text: bank["code"]!,
                    style: const TextStyle(
                      fontSize: 11,
                      color: SupportAppColors.greyColor,
                    ),
                  ),
                ],
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected
                      ? AppColors.primary
                      : SupportAppColors.greyColor,
                  width: 2,
                ),
              ),
              child: Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: selected ? AppColors.primary : Colors.transparent,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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

  Widget _buildCancelButton(BuildContext context) {
    return CustomIconbutton(
      text: "Batalkan Pesanan",
      foregroundColor: SupportAppColors.normalRed,
      backgroundColor: SupportAppColors.lightRed,
      isCustom: true,
      assetPath: CustomIcons.x,
      iconWidth: 18,
      iconHeight: 18,
      useDInfin: true,
      onTap: () => _confirmCancel(context, context.read<OrderDetailBloc>()),
    );
  }

  void _confirmCancel(BuildContext context, OrderDetailBloc bloc) {
    final orderId = bloc.state.order?.id;
    if (orderId == null) return;
    CustomBottomsheet.show(
      context,
      title: 'Batalkan Pesanan',
      initialChildSize: 0.4,
      onDismissed: () {},
      secondaryButtonText: 'Batal',
      primaryButtonText: 'Batalkan',
      pBackgroundColor: AppColors.primary,
      sBackgroundColor: SupportAppColors.white,
      onReset: () {},
      onPressed: () {
        bloc.add(OrderDetailCancelled(orderId: orderId));
        return true;
      },
      children: [
        CustomText(
          text: 'Apakah anda yakin ingin membatalkan pesanan ini?',
          style: const TextStyle(fontSize: 16),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  void _confirmCashPayment(
    BuildContext context,
    OrderDetailData currentOrder,
  ) {
    final orderId = currentOrder.id;
    if (orderId == null) return;
    CustomBottomsheet.show(
      context,
      title: 'Konfirmasi Pembayaran',
      initialChildSize: 0.4,
      onDismissed: () {},
      secondaryButtonText: 'Batal',
      primaryButtonText: 'Konfirmasi',
      pBackgroundColor: AppColors.primary,
      sBackgroundColor: SupportAppColors.white,
      onReset: () {},
      onPressed: () {
        context.read<OrderDetailBloc>().add(
          OrderDetailPaymentConfirmed(
            orderId: orderId,
            notes: 'Uang tunai diterima CS',
          ),
        );
        return true;
      },
      children: [
        CustomText(
          text:
              'Apakah anda yakin telah menerima uang tunai dari pelanggan? '
              'Pembayaran pesanan ini akan ditandai LUNAS.',
          style: const TextStyle(fontSize: 16),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SupportAppColors.white,
      body: BlocConsumer<OrderDetailBloc, OrderDetailState>(
        listener: (context, state) {
          if (state.isFailure && state.errorMessage != null) {
            AppSnackBar.error(context: context, message: state.errorMessage!);
          }
          if (state.isCancelSuccess) {
            AppSnackBar.success(
              context: context,
              message: "Pesanan berhasil dibatalkan",
            );
            context.go(AppRoutes.orderListCs);
          }
          final order = state.order;
          if (order != null && order.paymentMethod != null) {
            final committed = order.paymentMethod!.name;
            if (_selectedPayment != committed) {
              setState(() => _selectedPayment = committed);
            }
          }
        },
        builder: (context, state) {
          if (state.isInitial || state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.isFailure && state.order == null) {
            return Center(
              child: ErrorStateWidget(
                message: state.errorMessage ?? "Gagal memuat detail order",
                onRetry: () {
                  context.read<OrderDetailBloc>().add(
                    OrderDetailFetched(orderId: widget.orderId),
                  );
                },
              ),
            );
          }

          if (state.order == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final currentOrder = state.order!;
          final items = currentOrder.items ?? [];
          final isPaid = currentOrder.paymentStatus == PaymentStatus.PAID;
          final isCancelled = currentOrder.orderStatus == OrderStatus.CANCELLED;
          final isPaymentInProgress =
              currentOrder.paymentMethod != null && !isPaid;
          final orderStatus =
              currentOrder.orderStatus ?? OrderStatus.NEED_PICKUP;
          final canCancel =
              !isPaid &&
              (orderStatus == OrderStatus.NEED_PICKUP ||
                  orderStatus == OrderStatus.PROCESSING);

          return Stack(
            children: [
              RefreshIndicator(
                onRefresh: () async {
                  context.read<OrderDetailBloc>().add(
                    OrderDetailFetched(orderId: widget.orderId),
                  );
                },
                child: CustomScrollView(
                  slivers: [
                    const OrderDetailSliverAppBar(),
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            color: AppColors.bgColor,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ...OrderItemSections.build(items: items),
                                const CustomSpacing(height: 24),
                              ],
                            ),
                          ),

                          Container(
                            color: SupportAppColors.white,
                            padding: EdgeInsets.fromLTRB(
                              16,
                              16,
                              16,
                              isCancelled ? 24 : 280,
                            ),
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
                                    OrderStatusBadge(
                                      orderStatus:
                                          currentOrder.orderStatus ??
                                          OrderStatus.NEED_PICKUP,
                                    ),
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
                                  thickness: 1,
                                  color: SupportAppColors.greyMidColor,
                                ),

                                /// CUSTOMER
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
                                            customerName: currentOrder
                                                .displayCustomerName,
                                            customerPhone: currentOrder
                                                .displayCustomerPhone,
                                            vehicleModel: currentOrder
                                                .displayVehicleModel,
                                            vehiclePlate: currentOrder
                                                .displayVehiclePlate,
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
                                                    fontWeight: FontWeight.w600,
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

                                if (!isCancelled) ...[
                                  const Divider(
                                    height: 32,
                                    color: SupportAppColors.greyMidColor,
                                  ),
                                  if (isPaid || _selectedPayment != "CASH") ...[
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 6,
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: CustomText(
                                              text:
                                                  "Sembunyikan nama pelanggan saat cetak invoice",
                                              style: const TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                                color: SupportAppColors
                                                    .greyDarkerColor,
                                              ),
                                            ),
                                          ),
                                          CustomSwitch(
                                            value: _hideName,
                                            inactiveTrackColor: SupportAppColors
                                                .greyMidColor
                                                .withValues(alpha: 0.5),
                                            trackOutlineWidth: 1.5,
                                            inactiveThumbColor:
                                                SupportAppColors.greyColor,
                                            activeTrackColor: AppColors.primary,
                                            activeThumbColor:
                                                SupportAppColors.white,
                                            onChanged: (value) {
                                              setState(() => _hideName = value);
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Divider(
                                      height: 32,
                                      color: SupportAppColors.greyMidColor,
                                    ),
                                  ],

                                  /// PAYMENT METHOD
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const CustomText(
                                        text: "Metode Pembayaran",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),

                                  const CustomSpacing(height: 16),

                                  if (isPaid)
                                    _buildPaidPaymentRow(currentOrder)
                                  else if (isPaymentInProgress)
                                    _buildPendingPaymentRow(currentOrder)
                                  else
                                    Column(
                                      children: [
                                        PaymentRadioTile(
                                          title: "Virtual Account",
                                          icon: CustomIcons.profileCard,
                                          value: "VIRTUAL_ACCOUNT",
                                          selectedValue: _selectedPayment,
                                          showArrow: true,
                                          isExpanded: _vaExpanded,
                                          onTap: (value) {
                                            setState(() {
                                              _selectedPayment = value;
                                              _vaExpanded = !_vaExpanded;
                                            });
                                          },
                                        ),
                                        const CustomSpacing(height: 16),

                                        AnimatedSize(
                                          duration: const Duration(
                                            milliseconds: 250,
                                          ),
                                          curve: Curves.easeInOut,
                                          child:
                                              _selectedPayment ==
                                                      "VIRTUAL_ACCOUNT" &&
                                                  _vaExpanded
                                              ? _buildBankSelector()
                                              : const SizedBox.shrink(),
                                        ),

                                        const CustomSpacing(height: 16),

                                        PaymentRadioTile(
                                          title: "Cash",
                                          icon: CustomIcons.cash,
                                          value: "CASH",
                                          selectedValue: _selectedPayment,
                                          onTap: (value) {
                                            setState(() {
                                              _selectedPayment = value;
                                              _vaExpanded = false;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (!isCancelled)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: SupportAppColors.white,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
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
                                  if ((currentOrder.discountAmount ?? 0) >
                                      0) ...[
                                    CustomText(
                                      text: currentOrder.displayTotalAmount,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: SupportAppColors.greyColor,
                                        decoration: TextDecoration.lineThrough,
                                        decorationColor:
                                            SupportAppColors.greyColor,
                                      ),
                                    ),
                                  ],
                                  CustomText(
                                    text: currentOrder.displayFinalAmount,
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

                          const CustomSpacing(height: 20),

                          if (isPaid)
                            CustomButton(
                              text: "Lihat Struk Pembayaran",
                              backgroundColor: SupportAppColors.normalGreen,
                              foregroundColor: SupportAppColors.white,
                              onPressed: () {
                                context.push(
                                  AppRoutes.paymentReceipt,
                                  extra: {
                                    'orderId': currentOrder.id,
                                    'hideName': _hideName,
                                    'invoiceId':
                                        currentOrder.displayInvoiceNumber,
                                    'totalAmount':
                                        currentOrder.finalAmount ??
                                        currentOrder.totalAmount,
                                    'customerName':
                                        currentOrder.displayCustomerName,
                                    'vehicleModel':
                                        currentOrder.displayVehicleModel,
                                    'vehiclePlate':
                                        currentOrder.displayVehiclePlate,
                                    'paymentMethod': currentOrder.paymentMethod
                                        ?.toIndonesian(),
                                    'transactionTime':
                                        currentOrder.displayPaidAt.isEmpty
                                        ? null
                                        : currentOrder.displayPaidAt,
                                    'hideDoneButton': true,
                                  },
                                );
                              },
                            )
                          else if (isPaymentInProgress &&
                              currentOrder.paymentMethod == PaymentMethod.CASH)
                            CustomButton(
                              text: "Konfirmasi Pembayaran",
                              backgroundColor: SupportAppColors.normalGreen,
                              foregroundColor: SupportAppColors.white,
                              onPressed: () =>
                                  _confirmCashPayment(context, currentOrder),
                            )
                          else if (isPaymentInProgress)
                            CustomButton(
                              text: "Menunggu Konfirmasi",
                              backgroundColor: SupportAppColors.greyMidColor,
                              foregroundColor: SupportAppColors.white,
                              onPressed: null,
                            )
                          else
                            CustomButton(
                              text: "Proses Pembayaran",
                              backgroundColor: AppColors.primary,
                              foregroundColor: SupportAppColors.white,
                              onPressed: () async {
                                final orderId = currentOrder.id;
                                if (orderId == null) return;
                                final route = switch (_selectedPayment) {
                                  "CASH" => AppRoutes.paymentCash,
                                  "QRIS" => AppRoutes.paymentOnline,
                                  _ => AppRoutes.paymentOnline,
                                };
                                final paymentType = switch (_selectedPayment) {
                                  "CASH" => PaymentMethod.CASH,
                                  "QRIS" => PaymentMethod.QRIS,
                                  _ => PaymentMethod.VIRTUAL_ACCOUNT,
                                };
                                await context.push(
                                  route,
                                  extra: {
                                    'orderId': orderId,
                                    'totalAmount':
                                        currentOrder.finalAmount ??
                                        currentOrder.totalAmount,
                                    'totalInvoice': currentOrder.finalAmount,
                                    'invoiceId':
                                        currentOrder.displayInvoiceNumber,
                                    'customerName':
                                        currentOrder.displayCustomerName,
                                    'vehicleModel':
                                        currentOrder.displayVehicleModel,
                                    'vehiclePlate':
                                        currentOrder.displayVehiclePlate,
                                    'paidAt': currentOrder.displayPaidAt.isEmpty
                                        ? null
                                        : currentOrder.displayPaidAt,
                                    'hideName': _hideName,
                                    'hideDoneButton': false,
                                    if (paymentType != PaymentMethod.CASH)
                                      'paymentType': paymentType,
                                    if (paymentType ==
                                        PaymentMethod.VIRTUAL_ACCOUNT)
                                      'bankCode': _selectedBank,
                                  },
                                );
                                if (context.mounted) {
                                  context.read<OrderDetailBloc>().add(
                                    OrderDetailFetched(orderId: orderId),
                                  );
                                }
                              },
                            ),
                          if (canCancel) ...[
                            const CustomSpacing(height: 12),
                            _buildCancelButton(context),
                          ],
                        ],
                      ),
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
