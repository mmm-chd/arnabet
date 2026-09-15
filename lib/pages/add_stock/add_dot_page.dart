import 'package:arena/components/build/build_label.dart';
import 'package:arena/components/icon_button/custom_icon_button_circle.dart';
import 'package:arena/components/custom_button.dart';
import 'package:arena/components/custom_spacing.dart';
import 'package:arena/components/custom_text.dart';
import 'package:arena/components/text_field/custom_text_field.dart';
import 'package:arena/config/theme/app_colors.dart';
import 'package:arena/helper/currency_input_formatter.dart';
import 'package:arena/helper/dot_input_formatter.dart';
import 'package:arena/helper/string_extension_helper.dart';
import 'package:arena/models/enums/role.dart';
import 'package:arena/utils/app_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/dot_model.dart';

class AddDotPage extends StatefulWidget {
  const AddDotPage({super.key});

  @override
  State<AddDotPage> createState() => _AddDotPageState();
}

class _AddDotPageState extends State<AddDotPage> {
  final kode = TextEditingController();
  final hargaBeli = TextEditingController();
  final hargaJual = TextEditingController();
  final jumlah = TextEditingController();
  final catatan = TextEditingController();

  String? _kodeError;
  Role _userRole = Role.unknown;

  bool get _isOwner => _userRole == Role.owner;

  bool get _isValid =>
      kode.text.trim().isNotEmpty &&
      (!_isOwner || hargaBeli.text.trim().isNotEmpty) &&
      jumlah.text.trim().isNotEmpty &&
      _kodeError == null;

  Future<void> _loadRole() async {
    final raw = await AppSecureStorage.read(key: "user_role");
    final role = Role.fromString(raw);
    if (mounted) {
      setState(() {
        _userRole = role;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadRole();
    kode.addListener(_onFieldChanged);
    hargaBeli.addListener(_onFieldChanged);
    jumlah.addListener(_onFieldChanged);
  }

  void _onFieldChanged() {
    setState(() {
      _kodeError = getDotCodeError(kode.text.trim());
    });
  }

  @override
  void dispose() {
    kode.removeListener(_onFieldChanged);
    hargaBeli.removeListener(_onFieldChanged);
    jumlah.removeListener(_onFieldChanged);
    kode.dispose();
    hargaBeli.dispose();
    hargaJual.dispose();
    jumlah.dispose();
    catatan.dispose();
    super.dispose();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: CustomText(text: message)));
  }

  void _submit() {
    final dot = DotModel(
      kode: kode.text.trim(),
      jumlah: int.tryParse(jumlah.text) ?? 1,
      hargaBeli: hargaBeli.text.fromCurrencyToInt(),
      hargaJual: hargaJual.text.fromCurrencyToInt(),
    );

    context.pop(dot);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.bgColor,
        surfaceTintColor: AppColors.bgColor,
        automaticallyImplyLeading: false,
        leadingWidth: 72,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: CustomIconbuttonCircle(
            prefixIcon: Icons.arrow_back,
            backgroundColor: SupportAppColors.white,
            iconColor: Colors.black,
            iconSize: 24,
            width: 40,
            height: 40,
            onPressed: () {
              context.pop();
            },
          ),
        ),
        titleSpacing: 16,
        title: const CustomText(
          text: "Tambah DOT",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            cardBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BuildLabel(text: "Kode DOT", isRequired: true),
                  const CustomSpacing(height: 8),
                  CustomTextField(
                    controller: kode,
                    label: "Masukkan Kode DOT",
                    hint: "0425",
                    initialValue: '',
                    isNumber: true,
                    filled: true,
                    fillColor: SupportAppColors.white,
                    inputFormatters: [DotCodeInputFormatter()],
                    errorText: _kodeError,
                    onChanged: (value) {
                      setState(() {
                        _kodeError = getDotCodeError(value);
                      });
                    },
                  ),
                ],
              ),
            ),

            /// HARGA (hanya untuk owner, bersifat rahasia)
            if (_isOwner) ...[
              const CustomSpacing(height: 16),
              cardBox(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BuildLabel(text: "Harga Beli", isRequired: true),
                    const CustomSpacing(height: 8),
                    CustomTextField(
                      controller: hargaBeli,
                      label: "Masukkan Harga Beli",
                      hint: "000.000",
                      prefixText: "Rp ",
                      isNumber: true,
                      filled: true,
                      inputFormatters: [CurrencyInputFormatter()],
                    ),
                    const CustomSpacing(height: 16),
                    BuildLabel(text: "Harga Jual", isRequired: true),
                    const CustomSpacing(height: 8),
                    CustomTextField(
                      controller: hargaJual,
                      label: "Masukkan Harga Jual",
                      hint: "000.000",
                      prefixText: "Rp ",
                      isNumber: true,
                      filled: true,
                      inputFormatters: [CurrencyInputFormatter()],
                    ),
                  ],
                ),
              ),
            ],

            const CustomSpacing(height: 16),

            cardBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BuildLabel(text: "Jumlah", isRequired: true),
                  const CustomSpacing(height: 8),
                  CustomTextField(
                    controller: jumlah,
                    label: "Masukkan Jumlah...",
                    hint: "Masukkan Jumlah...",
                    initialValue: '',
                    isNumber: true,
                    filled: true,
                    suffixText: "pcs",
                  ),
                ],
              ),
            ),

            const CustomSpacing(height: 16),

            cardBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BuildLabel(text: "Catatan", isOptional: true),
                  const CustomSpacing(height: 8),
                  CustomTextField(
                    controller: catatan,
                    label: "Masukkan Catatan...",
                    hint: "Masukkan catatan...",
                    filled: true,
                    alignLabelWithHint: true,
                    maxLines: 5,
                  ),
                ],
              ),
            ),

            const CustomSpacing(height: 40),

            CustomButton(
              text: "Tambah",
              backgroundColor: AppColors.primary,
              foregroundColor: SupportAppColors.white,
              onPressed: _isValid ? _submit : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget cardBox({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: SupportAppColors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: child,
    );
  }
}
