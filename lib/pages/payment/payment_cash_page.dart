import 'package:arena/components/custom_button.dart';
import 'package:arena/components/icon_button/custom_icon_button_circle.dart';
import 'package:arena/components/custom_spacing.dart';
import 'package:arena/components/custom_text.dart';
import 'package:arena/config/design/app_snack_bar.dart';
import 'package:arena/config/routes/app_routes.dart';
import 'package:arena/config/theme/app_colors.dart';
import 'package:arena/helper/currency_local_formatter.dart';
import 'package:arena/models/enums/enums.dart';
import 'package:arena/pages/payment/bloc/payment_bloc.dart';
import 'package:arena/pages/payment/bloc/payment_event.dart';
import 'package:arena/pages/payment/bloc/payment_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class PaymentCashPage extends StatefulWidget {
  final String orderId;
  final int totalInvoice;
  final String invoiceId;

  const PaymentCashPage({
    super.key,
    required this.orderId,
    required this.totalInvoice,
    required this.invoiceId,
  });

  @override
  State<PaymentCashPage> createState() => _PaymentCashPageState();
}

class _PaymentCashPageState extends State<PaymentCashPage> {
  String _rawInput = '';

  int get _cashReceived => int.tryParse(_rawInput) ?? 0;
  bool get _isValid => _cashReceived >= widget.totalInvoice;

  String get _displayInput {
    if (_rawInput.isEmpty) return '0';
    return (int.tryParse(_rawInput) ?? 0).toLocaleCurrency(
      symbol: null,
      showSymbol: false,
      decimalDigits: 0,
    );
  }

  void _onKey(String key) {
    setState(() {
      if (key == '⌫') {
        if (_rawInput.isNotEmpty) {
          _rawInput = _rawInput.substring(0, _rawInput.length - 1);
        }
      } else {
        final appended = key == '000' ? '000' : key;
        if (_rawInput.isEmpty && appended == '000') return;
        final next = _rawInput + appended;
        if ((int.tryParse(next) ?? 0) <= 999999999) _rawInput = next;
      }
    });
  }

  void _submitPayment() {
    context.read<PaymentBloc>().add(
      PaymentSubmitted(
        orderId: widget.orderId,
        method: PaymentMethod.CASH,
        amount: _cashReceived,
        notes: 'Lunas tunai',
      ),
    );
  }

  void _handleExitAttempt() {
    if (context.read<PaymentBloc>().state.isSubmitting) return;
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
                  text: 'Keluar dari Pembayaran?',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: SupportAppColors.greyDarkerColor,
                  ),
                ),
                const CustomSpacing(height: 12),
                const CustomText(
                  text:
                      'Apakah Anda yakin ingin keluar dan tidak melanjutkan '
                      'pembayaran? Nominal yang sudah diketik akan hilang.',
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
                        text: 'Batal',
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
                        text: 'Ya, Keluar',
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

  Widget _numpadButton(String label) {
    final isBackspace = label == '⌫';
    return GestureDetector(
      onTap: () => _onKey(label),
      onLongPress: isBackspace ? () => setState(() => _rawInput = '') : null,
      child: Container(
        decoration: BoxDecoration(
          color: SupportAppColors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: SupportAppColors.greyDarkerColor.withValues(alpha: 0.06),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: isBackspace
            ? const Icon(
                Icons.backspace_outlined,
                size: 22,
                color: SupportAppColors.greyDarkerColor,
              )
            : CustomText(
                text: label,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: SupportAppColors.greyDarkerColor,
                ),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final keys = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0', '000', '⌫'];

    return BlocListener<PaymentBloc, PaymentState>(
      listener: (context, state) {
        if (state.isPaid) {
          final change =
              state.payment?.change ?? (_cashReceived - widget.totalInvoice);
          context.push(
            AppRoutes.paymentCashChange,
            extra: {
              'orderId': widget.orderId,
              'totalInvoice': widget.totalInvoice,
              'cashReceived': _cashReceived,
              'change': change.toDouble(),
              'invoiceId': widget.invoiceId,
            },
          );
        }
        if (state.isFailure && state.errorMessage != null) {
          AppSnackBar.error(context: context, message: state.errorMessage!);
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
              text: 'Konfirmasi Pembayaran',
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
                        text: 'Total Tagihan',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: SupportAppColors.greyColor,
                        ),
                      ),
                      const CustomSpacing(height: 4),
                      CustomText(
                        text: widget.totalInvoice.toLocaleCurrency(
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
                  text: 'Uang Diterima',
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
                    color: SupportAppColors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: SupportAppColors.greyDarkerColor.withValues(
                          alpha: 0.07,
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
                          color: SupportAppColors.greyColor,
                          fontFamily: 'JetBrainsMono',
                        ),
                      ),
                      const CustomSpacing(width: 8),
                      Expanded(
                        child: CustomText(
                          text: _displayInput,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: SupportAppColors.greyDarkerColor,
                            fontFamily: 'JetBrainsMono',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const CustomSpacing(height: 16),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 3,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 2.4,
                    children: keys.map(_numpadButton).toList(),
                  ),
                ),
                const CustomSpacing(height: 12),
                BlocBuilder<PaymentBloc, PaymentState>(
                  builder: (context, state) {
                    final isSubmitting = state.isSubmitting;
                    return CustomButton(
                      text: isSubmitting
                          ? 'Memproses...'
                          : 'Konfirmasi Pembayaran',
                      backgroundColor: _isValid && !isSubmitting
                          ? AppColors.primary
                          : SupportAppColors.greyMidColor,
                      foregroundColor: SupportAppColors.white,
                      borderRadius: 16,
                      onPressed: _isValid && !isSubmitting
                          ? _submitPayment
                          : null,
                    );
                  },
                ),
                const CustomSpacing(height: 60),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
