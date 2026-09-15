import 'dart:async';

import 'package:arena/components/custom_button.dart';
import 'package:arena/components/custom_spacing.dart';
import 'package:arena/components/custom_text.dart';
import 'package:arena/components/icon_button/custom_icon_button_circle.dart';
import 'package:arena/config/routes/app_routes.dart';
import 'package:arena/config/theme/app_colors.dart';
import 'package:arena/helper/currency_local_formatter.dart';
import 'package:arena/models/enums/enums.dart';
import 'package:arena/models/payments/pay_order_model.dart';
import 'package:arena/pages/payment/bloc/payment_bloc.dart';
import 'package:arena/pages/payment/bloc/payment_event.dart';
import 'package:arena/pages/payment/bloc/payment_state.dart';
import 'package:arena/pages/payment/bloc/payment_timer_bloc.dart';
import 'package:arena/pages/payment/bloc/payment_timer_event.dart';
import 'package:arena/pages/payment/bloc/payment_timer_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';

class PaymentOnlinePage extends StatefulWidget {
  final String orderId;
  final PaymentMethod paymentType;
  final String invoiceId;
  final num totalAmount;
  final String? customerName;
  final String? vehicleModel;
  final String? vehiclePlate;
  final String? paidAt;
  final String? bankCode;
  final bool hideDoneButton;
  final bool hideName;

  const PaymentOnlinePage({
    super.key,
    required this.orderId,
    required this.paymentType,
    required this.invoiceId,
    required this.totalAmount,
    this.customerName,
    this.vehicleModel,
    this.vehiclePlate,
    this.bankCode,
    this.paidAt,
    this.hideDoneButton = true,
    this.hideName = false,
  });

  @override
  State<PaymentOnlinePage> createState() => _PaymentOnlinePageState();
}

class _PaymentOnlinePageState extends State<PaymentOnlinePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  Timer? _pollTimer;
  bool _paid = false;
  bool _redirected = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<PaymentTimerBloc>().add(const StartTimer());
        context.read<PaymentBloc>().add(
          PaymentSubmitted(
            orderId: widget.orderId,
            method: widget.paymentType,
            bankCode: _isQris ? null : widget.bankCode,
            notes: _isQris ? 'Bayar pakai QRIS' : 'Transfer via m-banking',
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _pollTimer?.cancel();
    super.dispose();
  }

  bool get _isQris => widget.paymentType == PaymentMethod.QRIS;

  void _goToReceipt(PayOrderData? payment) {
    if (_redirected) return;
    _redirected = true;
    _pollTimer?.cancel();
    if (!mounted) return;
    context.pushReplacement(
      AppRoutes.paymentReceipt,
      extra: {
        'orderId': widget.orderId,
        'invoiceId': widget.invoiceId,
        'totalAmount': widget.totalAmount,
        'customerName': widget.customerName,
        'vehicleModel': widget.vehicleModel,
        'vehiclePlate': widget.vehiclePlate,
        'paymentMethod':
            payment?.method?.toIndonesian() ??
            widget.paymentType.toIndonesian(),
        'transactionTime': widget.paidAt,
        'hideDoneButton': widget.hideDoneButton,
        'hideName': widget.hideName,
        'isSuccess': true,
      },
    );
  }

  void _goToFailedReceipt(String reason, {required bool retryable}) {
    if (_redirected) return;
    _redirected = true;
    _pollTimer?.cancel();
    if (!mounted) return;
    context.pushReplacement(
      AppRoutes.paymentReceipt,
      extra: {
        'orderId': widget.orderId,
        'invoiceId': widget.invoiceId,
        'totalAmount': widget.totalAmount,
        'customerName': widget.customerName,
        'vehicleModel': widget.vehicleModel,
        'vehiclePlate': widget.vehiclePlate,
        'paymentMethod': widget.paymentType.toIndonesian(),
        'transactionTime': widget.paidAt,
        'hideName': widget.hideName,
        'isSuccess': false,
        'failureReason': reason,
        'retryable': retryable,
        if (retryable) 'retryPaymentType': widget.paymentType,
        if (retryable) 'retryBankCode': widget.bankCode,
      },
    );
  }

  bool _isRetryable(String? message) {
    if (message == null) return false;
    return message.contains('koneksi') ||
        message.contains('internet') ||
        message.contains('server') ||
        message.contains('jangkau') ||
        message.contains('timeout') ||
        message.contains('Status: 5');
  }

  void _startPolling() {
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (mounted) {
        context.read<PaymentBloc>().add(
          PaymentStatusCheckRequested(
            orderId: widget.orderId,
            method: widget.paymentType,
            silent: true,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PaymentBloc, PaymentState>(
      listener: (context, state) {
        if (state.isAwaitingOnlinePayment) {
          _startPolling();
        }
        if (state.isPaid) {
          _paid = true;
          _pollTimer?.cancel();
        }
        if (state.isFailure && !_paid && !_redirected) {
          _goToFailedReceipt(
            state.errorMessage ?? 'Pembayaran gagal',
            retryable: _isRetryable(state.errorMessage),
          );
        }
      },
      builder: (context, state) {
        return BlocListener<PaymentTimerBloc, PaymentTimerState>(
          listener: (context, timerState) {
            if (timerState.isExpired && !_paid) {
              _goToFailedReceipt('Waktu pembayaran habis', retryable: false);
            }
          },
          child: Scaffold(
            backgroundColor: AppColors.bgColor,
            appBar: _buildAppBar(),
            body: SafeArea(
              child: state.isSubmitting
                  ? const Center(child: CircularProgressIndicator())
                  : state.isPaid
                  ? _buildSuccessView(state)
                  : Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              children: [
                                const CustomSpacing(height: 24),
                                _buildHeader(),
                                const CustomSpacing(height: 20),
                                _buildPaymentCard(state),
                                const CustomSpacing(height: 20),
                              ],
                            ),
                          ),
                        ),
                        _buildStatusFooter(state),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
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
          onPressed: () => context.pop(),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        const CustomText(
          text: 'Total Tagihan',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: SupportAppColors.greyDarkColor,
          ),
        ),
        const CustomSpacing(height: 4),
        CustomText(
          text: widget.totalAmount.toLocaleCurrency(decimalDigits: 0),
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w800,
            color: AppColors.primary,
          ),
        ),
        const CustomSpacing(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: SupportAppColors.lightRed,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.receipt_long,
                size: 14,
                color: AppColors.primary,
              ),
              const CustomSpacing(width: 6),
              CustomText(
                text: widget.invoiceId,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentCard(PaymentState state) {
    final payment = state.payment;
    final qrImageUrl = payment?.qrImageUrl;
    final qrString = payment?.qrString;
    final vaNumber = payment?.vaNumber;
    final qrData = _isQris ? qrString : (vaNumber ?? qrString);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: SupportAppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const CustomText(
            text: 'Scan untuk Bayar',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: SupportAppColors.greyDarkerColor,
            ),
          ),
          if (!_isQris) ...[
            const CustomSpacing(height: 4),
            const CustomText(
              text: 'Gunakan aplikasi m-banking',
              style: TextStyle(fontSize: 12, color: SupportAppColors.greyColor),
            ),
          ],
          const CustomSpacing(height: 16),
          _buildQrContainer(qrImageUrl, qrData),
          const CustomSpacing(height: 16),
          _buildCodeDisplay(vaNumber, qrString),
          const CustomSpacing(height: 16),
          _buildTimerBar(),
        ],
      ),
    );
  }

  Widget _buildQrContainer(String? qrImageUrl, String? qrString) {
    return Container(
      width: 220,
      height: 220,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1D1F),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: _isQris && qrImageUrl != null
            ? Image.network(
                qrImageUrl,
                width: 188,
                height: 188,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => _buildQrPlaceholder(qrString),
              )
            : _buildQrPlaceholder(qrString),
      ),
    );
  }

  Widget _buildQrPlaceholder(String? qrString) {
    if (qrString != null) {
      return QrImageView(
        data: qrString,
        version: QrVersions.auto,
        size: 188,
        backgroundColor: Colors.white,
      );
    }
    return const Center(
      child: Icon(Icons.qr_code_2, size: 64, color: Colors.white54),
    );
  }

  Widget _buildCodeDisplay(String? vaNumber, String? qrString) {
    final displayText = _isQris ? qrString : vaNumber;
    if (displayText == null) return const SizedBox.shrink();
    return GestureDetector(
      onTap: () {
        Clipboard.setData(ClipboardData(text: displayText));
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: CustomText(text: 'Disalin')));
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.bgColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: CustomText(
          text: displayText,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: SupportAppColors.greyDarkerColor,
            fontFamily: 'JetBrainsMono',
            letterSpacing: 1.2,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildTimerBar() {
    return BlocBuilder<PaymentTimerBloc, PaymentTimerState>(
      builder: (context, state) {
        final minutes = state.remaining.inMinutes
            .remainder(60)
            .toString()
            .padLeft(2, '0');
        final seconds = state.remaining.inSeconds
            .remainder(60)
            .toString()
            .padLeft(2, '0');
        return Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: state.progress,
                backgroundColor: SupportAppColors.lightRed,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.primary,
                ),
                minHeight: 6,
              ),
            ),
            const CustomSpacing(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.timer, size: 16, color: AppColors.primary),
                const CustomSpacing(width: 6),
                CustomText(
                  text: '$minutes:$seconds',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatusFooter(PaymentState state) {
    final isAwaiting = state.isAwaitingOnlinePayment || state.isCheckingStatus;
    final hasFailed = state.isFailure;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: SupportAppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildPulseDot(),
          const CustomSpacing(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: hasFailed
                      ? (state.errorMessage ?? 'Pembayaran gagal')
                      : 'Menunggu pembayaran',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: SupportAppColors.greyDarkerColor,
                  ),
                ),
                const CustomSpacing(height: 2),
                const CustomText(
                  text: 'Sistem akan otomatis mendeteksi',
                  style: TextStyle(
                    fontSize: 11,
                    color: SupportAppColors.greyColor,
                  ),
                ),
              ],
            ),
          ),
          if (isAwaiting) ...[
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(24),
                onTap: () {
                  context.read<PaymentBloc>().add(
                    PaymentStatusCheckRequested(
                      orderId: widget.orderId,
                      method: widget.paymentType,
                    ),
                  );
                },
                child: Ink(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: SupportAppColors.lightRed,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.refresh,
                    size: 20,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          ] else if (state.isLoading) ...[
            CircularProgressIndicator(),
          ],
        ],
      ),
    );
  }

  Widget _buildPulseDot() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Container(
          width: 12 + _pulseController.value * 4,
          height: 12 + _pulseController.value * 4,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(
              alpha: 1 - _pulseController.value * 0.4,
            ),
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }

  Widget _buildSuccessView(PaymentState state) {
    final change = state.payment?.change ?? 0;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 80),
            const CustomSpacing(height: 16),
            const CustomText(
              text: 'Pembayaran Berhasil',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
            ),
            if (change > 0) ...[
              const CustomSpacing(height: 8),
              CustomText(
                text: 'Kembalian: ${change.toLocaleCurrency()}',
                style: const TextStyle(color: SupportAppColors.greyColor),
              ),
            ],
            const CustomSpacing(height: 62),
            CustomButton(
              text: 'Lihat Struk Pembayaran',
              backgroundColor: AppColors.primary,
              foregroundColor: SupportAppColors.white,
              onPressed: () => _goToReceipt(state.payment),
            ),
          ],
        ),
      ),
    );
  }
}
