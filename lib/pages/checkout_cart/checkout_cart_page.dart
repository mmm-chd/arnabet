import 'package:arena/components/custom_button.dart';
import 'package:arena/components/icon_button/custom_icon_button_circle.dart';
import 'package:arena/components/custom_spacing.dart';
import 'package:arena/config/theme/app_colors.dart';
import 'package:arena/pages/cart/bloc/cart_bloc.dart';
import 'package:arena/pages/cart/bloc/cart_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:arena/components/custom_text.dart';
import 'package:arena/config/routes/app_routes.dart';
import 'widgets/checkout_cart_form.dart';

class CheckoutCartPage extends StatefulWidget {
  const CheckoutCartPage({super.key});

  @override
  State<CheckoutCartPage> createState() => _CheckoutCartPageState();
}

class _CheckoutCartPageState extends State<CheckoutCartPage> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _hpController = TextEditingController();
  final TextEditingController _kendaraanController = TextEditingController();
  final TextEditingController _platController = TextEditingController();

  String? namaError;
  String? hpError;
  String? kendaraanError;
  String? platError;

  @override
  void dispose() {
    _namaController.dispose();
    _hpController.dispose();
    _kendaraanController.dispose();
    _platController.dispose();
    super.dispose();
  }

  void _submitForm() {
    setState(() {
      namaError = _namaController.text.trim().isEmpty
          ? 'Nama customer wajib diisi'
          : null;
      hpError = _hpController.text.trim().isEmpty ? 'No HP wajib diisi' : null;
      kendaraanError = _kendaraanController.text.trim().isEmpty
          ? 'Kendaraan wajib diisi'
          : null;
      platError = _platController.text.trim().isEmpty
          ? 'Plat nomor wajib diisi'
          : null;
    });

    if (namaError != null ||
        hpError != null ||
        kendaraanError != null ||
        platError != null) {
      return;
    }

    context.push(
      AppRoutes.checkoutPreview,
      extra: {
        "nama": _namaController.text.trim(),
        "hp": _hpController.text.trim(),
        "kendaraan": _kendaraanController.text.trim(),
        "plat": _platController.text.trim(),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
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
        titleSpacing: 16,
        title: const CustomText(
          text: 'Tambah Order',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: CheckoutCartForm(
                        namaController: _namaController,
                        hpController: _hpController,
                        kendaraanController: _kendaraanController,
                        platController: _platController,
                        namaError: namaError,
                        hpError: hpError,
                        kendaraanError: kendaraanError,
                        platError: platError,
                      ),
                    ),
                  ),
                  const CustomSpacing(height: 12),
                  CustomButton(
                    text: state.isCheckoutSubmitting
                        ? "Memuat..."
                        : "Tambahkan",
                    onPressed: _submitForm,
                    backgroundColor: AppColors.primary,
                    foregroundColor: SupportAppColors.white,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
