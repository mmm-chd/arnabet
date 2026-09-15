import 'dart:async';

import 'package:arena/components/custom_button.dart';
import 'package:arena/components/custom_spacing.dart';
import 'package:arena/components/custom_text.dart';
import 'package:arena/components/icon_button/custom_icon_button_circle.dart';
import 'package:arena/config/routes/app_routes.dart';
import 'package:arena/config/theme/app_colors.dart';
import 'package:arena/helper/currency_local_formatter.dart';
import 'package:arena/models/enums/enums.dart';
import 'package:arena/models/order/order_detail_model.dart';
import 'package:arena/pages/order_detail/bloc/order_detail_bloc.dart';
import 'package:arena/pages/order_detail/bloc/order_detail_event.dart';
import 'package:arena/pages/order_detail/bloc/order_detail_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class PaymentCashChangePage extends StatefulWidget {
  final String orderId;
  final int totalInvoice;
  final double cashReceived;
  final double change;
  final String invoiceId;

  const PaymentCashChangePage({
    super.key,
    required this.orderId,
    required this.totalInvoice,
    required this.cashReceived,
    required this.change,
    required this.invoiceId,
  });

  @override
  State<PaymentCashChangePage> createState() => _PaymentCashChangePageState();
}

class _PaymentCashChangePageState extends State<PaymentCashChangePage> {
  Timer? _pollTimer;
  bool _shouldRedirect = false;

  static const _pollInterval = Duration(seconds: 5);

  @override
  void initState() {
    super.initState();
    _pollTimer = Timer.periodic(_pollInterval, (_) => _checkPaymentStatus());
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }

  bool _isReady(OrderDetailData order) {
    return order.paymentStatus == PaymentStatus.PAID;
  }

  void _checkPaymentStatus() {
    if (!mounted || _shouldRedirect) return;
    final order = context.read<OrderDetailBloc>().state.order;
    if (order != null && _isReady(order)) {
      _scheduleRedirect(order);
      return;
    }
    context.read<OrderDetailBloc>().add(
      OrderDetailRefreshRequested(orderId: widget.orderId),
    );
  }

  void _scheduleRedirect(OrderDetailData order) {
    _pollTimer?.cancel();
    setState(() => _shouldRedirect = true);
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      final router = GoRouter.of(context);
      final navigator = Navigator.of(context, rootNavigator: true);
      navigator.pop();
      navigator.pop();
      router.push(
        AppRoutes.paymentReceipt,
        extra: {
          'orderId': widget.orderId,
          'hideName': false,
          'invoiceId': order.displayInvoiceNumber,
          'totalAmount': order.finalAmount,
          'customerName': order.displayCustomerName,
          'vehicleModel': order.displayVehicleModel,
          'vehiclePlate': order.displayVehiclePlate,
          'paymentMethod': PaymentMethod.CASH.toIndonesian(),
          'transactionTime': order.displayPaidAt.isEmpty
              ? null
              : order.displayPaidAt,
          'hideDoneButton': false,
          'isSuccess': true,
        },
      );
    });
  }

  void _handleExitAttempt() {
    if (context.read<OrderDetailBloc>().state.isSubmitting) return;
    if (_shouldRedirect) return;
    _confirmExit();
  }

  Future<void> _confirmExit() async {
    final shouldExit = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: SupportAppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomText(
                  text: 'Kembali untuk mengubah nominal?',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: SupportAppColors.greyDarkerColor,
                  ),
                ),
                const CustomSpacing(height: 12),
                const CustomText(
                  text:
                      'Pembayaran belum ditandai LUNAS sampai dikonfirmasi. '
                      'Anda dapat kembali untuk mengubah nominal uang tunai '
                      'atau mengonfirmasi pembayaran dari halaman detail pesanan.',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.4,
                    color: SupportAppColors.greyDarkColor,
                  ),
                ),
                const CustomSpacing(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        text: 'Tetap di Sini',
                        backgroundColor: SupportAppColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                          side: const BorderSide(color: AppColors.primary),
                        ),
                        foregroundColor: AppColors.primary,
                        onPressed: () => Navigator.pop(context, false),
                      ),
                    ),
                    const CustomSpacing(width: 16),
                    Expanded(
                      child: CustomButton(
                        text: 'Ya, Kembali',
                        backgroundColor: AppColors.primary,
                        foregroundColor: SupportAppColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                        onPressed: () => Navigator.pop(context, true),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    if (shouldExit == true && mounted) {
      context.pop();
    }
  }

  Widget _buildStatusBanner({required bool confirmed}) {
    final background = confirmed
        ? SupportAppColors.lightGreen
        : SupportAppColors.lightOrange;
    final border = confirmed
        ? SupportAppColors.normalGreen
        : SupportAppColors.normalOrange;
    final icon = confirmed ? Icons.check_circle : Icons.payments_outlined;
    final message = confirmed
        ? "Pembayaran telah dikonfirmasi. Anda akan dialihkan ke struk "
              "pembayaran."
        : "Uang tunai telah diterima. Tekan tombol Konfirmasi Pembayaran "
              "untuk menandai pesanan sebagai LUNAS.";

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: border),
          const CustomSpacing(width: 10),
          Expanded(
            child: CustomText(
              text: message,
              style: const TextStyle(
                fontSize: 13,
                height: 1.4,
                color: SupportAppColors.greyDarkerColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmFooter({required bool isSubmitting}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomButton(
          text: isSubmitting ? 'Memproses...' : 'Konfirmasi Pembayaran',
          backgroundColor: isSubmitting
              ? SupportAppColors.greyMidColor
              : SupportAppColors.normalGreen,
          foregroundColor: SupportAppColors.white,
          onPressed: isSubmitting
              ? null
              : () {
                  context.read<OrderDetailBloc>().add(
                    OrderDetailPaymentConfirmed(
                      orderId: widget.orderId,
                      notes: 'Uang tunai diterima CS',
                    ),
                  );
                },
        ),
        const CustomSpacing(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isSubmitting)
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            if (isSubmitting) const CustomSpacing(width: 10),
            Flexible(
              child: CustomText(
                text: _shouldRedirect
                    ? 'Mengalihkan ke struk pembayaran…'
                    : isSubmitting
                    ? 'Mengkonfirmasi pembayaran…'
                    : 'Pastikan uang tunai sudah diterima sebelum konfirmasi.',
                maxLines: 3,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  color: SupportAppColors.greyDarkColor,
                ),
              ),
            ),
          ],
        ),
        const CustomSpacing(height: 12),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrderDetailBloc, OrderDetailState>(
      listenWhen: (previous, current) =>
          previous.order?.paymentStatus != current.order?.paymentStatus ||
          previous.order?.orderStatus != current.order?.orderStatus,
      listener: (context, state) {
        final order = state.order;
        if (!_shouldRedirect && order != null && _isReady(order)) {
          _scheduleRedirect(order);
        }
      },
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop) _handleExitAttempt();
        },
        child: Scaffold(
          backgroundColor: AppColors.bgColor,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: AppColors.bgColor,
            surfaceTintColor: AppColors.bgColor,
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
                onPressed: _handleExitAttempt,
              ),
            ),
            title: const CustomText(
              text: 'Kembalian',
              style: TextStyle(
                color: SupportAppColors.greyDarkerColor,
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomSpacing(height: 24),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CustomText(
                        text: 'Terbayar',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: SupportAppColors.greyColor,
                        ),
                      ),
                      const CustomSpacing(height: 4),
                      CustomText(
                        text: widget.cashReceived.toLocaleCurrency(
                          decimalDigits: 0,
                        ),
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                      const CustomSpacing(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: SupportAppColors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.receipt_long,
                              size: 14,
                              color: SupportAppColors.greyDarkColor,
                            ),
                            const CustomSpacing(width: 6),
                            CustomText(
                              text: widget.invoiceId,
                              style: const TextStyle(
                                fontSize: 12,
                                color: SupportAppColors.greyDarkColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const CustomSpacing(height: 24),
                const CustomText(
                  text: 'Kembalian',
                  style: TextStyle(
                    fontSize: 14,
                    color: SupportAppColors.greyColor,
                  ),
                ),
                const CustomSpacing(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: SupportAppColors.lightGreen,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: SupportAppColors.normalGreen,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: SupportAppColors.greyDarkerColor.withValues(
                          alpha: 0.06,
                        ),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const CustomText(
                        text: 'Rp',
                        style: TextStyle(
                          fontSize: 18,
                          color: SupportAppColors.normalGreen,
                          fontFamily: 'JetBrainsMono',
                        ),
                      ),
                      const CustomSpacing(width: 8),
                      Expanded(
                        child: CustomText(
                          text: widget.change.toLocaleCurrency(
                            symbol: null,
                            showSymbol: false,
                            decimalDigits: 0,
                          ),
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: SupportAppColors.normalGreen,
                            fontFamily: 'JetBrainsMono',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const CustomSpacing(height: 16),
                _buildStatusBanner(confirmed: _shouldRedirect),
                const Spacer(),
                BlocBuilder<OrderDetailBloc, OrderDetailState>(
                  builder: (context, state) {
                    return _buildConfirmFooter(
                      isSubmitting: state.isSubmitting || _shouldRedirect,
                    );
                  },
                ),
                const CustomSpacing(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
