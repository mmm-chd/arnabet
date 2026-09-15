import 'package:arena/components/build/build_label.dart';
import 'package:arena/components/text_field/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:arena/config/theme/app_colors.dart';
import 'package:arena/components/custom_spacing.dart';
import 'package:arena/components/custom_text.dart';

class CheckoutCartForm extends StatelessWidget {
  final TextEditingController namaController;
  final TextEditingController hpController;
  final TextEditingController kendaraanController;
  final TextEditingController platController;

  final String? namaError;
  final String? hpError;
  final String? kendaraanError;
  final String? platError;

  const CheckoutCartForm({
    super.key,
    required this.namaController,
    required this.hpController,
    required this.kendaraanController,
    required this.platController,
    this.namaError,
    this.hpError,
    this.kendaraanError,
    this.platError,
  });

  Widget buildField({
    required String title,
    required String hint,
    required String label,
    required TextEditingController controller,
    String? errorText,
    bool isNumber = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BuildLabel(text: title, isRequired: true),

        const CustomSpacing(height: 8),

        CustomTextField(
          hint: hint,
          label: label,
          controller: controller,
          initialValue: '',
          isNumber: isNumber,
          filled: true,
          fillColor: SupportAppColors.white,
          borderColor: errorText != null
              ? AppColors.error
              : SupportAppColors.greyColor,
        ),

        /// ERROR TEXT
        if (errorText != null) ...[
          const CustomSpacing(height: 6),
          CustomText(
            text: errorText,
            style: const TextStyle(color: AppColors.error, fontSize: 12),
          ),
        ],

        const CustomSpacing(height: 16),
      ],
    );
  }

  Widget buildSection({required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: SupportAppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(children: children),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildSection(
          children: [
            buildField(
              title: "Nama Customer",
              label: "Masukkan nama customer",
              hint: "Cahyana",
              controller: namaController,
              errorText: namaError,
            ),
            buildField(
              title: "No Hp",
              hint: "+62",
              label: "Masukkan nomor hp",
              controller: hpController,
              isNumber: true,
              errorText: hpError,
            ),
          ],
        ),

        /// CARD 2
        buildSection(
          children: [
            buildField(
              title: "Kendaraan",
              hint: "Toyota Inova",
              label: "Masukkan kendaraan",
              controller: kendaraanController,
              errorText: kendaraanError,
            ),
            buildField(
              title: "Plat Nomor",
              hint: "K 1456 RB",
              label: "Masukkan nomor kendaraan",
              controller: platController,
              errorText: platError,
            ),
          ],
        ),
      ],
    );
  }
}
