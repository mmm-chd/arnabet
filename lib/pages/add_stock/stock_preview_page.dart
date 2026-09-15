import 'package:arena/components/icon_button/custom_icon_button_circle.dart';
import 'package:arena/components/custom_button.dart';
import 'package:arena/components/custom_spacing.dart';
import 'package:arena/components/custom_text.dart';
import 'package:arena/config/routes/app_routes.dart';
import 'package:arena/config/theme/app_colors.dart';
import 'package:arena/helper/currency_local_formatter.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../components/custom_card_box.dart';
import '../../models/dot_model.dart';

class StockPreviewPage extends StatefulWidget {
  final List<DotModel> dots;
  final String nama;
  final String ukuran;
  final String ring;
  final String? catatan;

  const StockPreviewPage({
    super.key,
    required this.dots,
    required this.nama,
    required this.ukuran,
    required this.ring,
    required this.catatan,
  });

  @override
  State<StockPreviewPage> createState() => _StockPreviewPageState();
}

class _StockPreviewPageState extends State<StockPreviewPage> {
  late List<DotModel> dots;

  @override
  void initState() {
    dots = List.from(widget.dots);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int totalStock = 0;
    int totalHarga = 0;
    for (var d in dots) {
      totalStock += d.jumlah;
      totalHarga += d.jumlah * d.hargaBeli!;
    }

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        backgroundColor: AppColors.bgColor,
        surfaceTintColor: AppColors.bgColor,
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
            onPressed: () {
              context.pop();
            },
          ),
        ),
        titleSpacing: 16,
        title: const CustomText(
          text: "Review",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CustomCardBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: "Informasi Ban",
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  CustomSpacing(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(text: "Nama"),
                      CustomText(text: widget.nama),
                    ],
                  ),
                  CustomSpacing(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(text: "Ukuran"),
                      CustomText(text: widget.ukuran),
                    ],
                  ),
                  CustomSpacing(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(text: "Ring"),
                      CustomText(text: widget.ring),
                    ],
                  ),
                ],
              ),
            ),
            const CustomSpacing(height: 16),

            CustomCardBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomText(
                    text: "Kode DOT",
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const CustomSpacing(height: 10),
                  Column(
                    children: dots.map((d) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(
                              text: d.kode,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Row(
                              children: [
                                CustomText(text: "${d.jumlah} pcs"),
                                const CustomSpacing(width: 20),
                                CustomText(
                                  text: d.hargaBeli!.toLocaleCurrency(),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const CustomText(
                        text: "Total Stok",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          CustomText(
                            text: "$totalStock pcs",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const CustomSpacing(width: 20),
                          CustomText(
                            text: "Rp $totalHarga",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const CustomSpacing(height: 16),

            /// CATATAN
            CustomCardBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: "Catatan",
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  CustomSpacing(height: 8),
                  CustomText(
                    text: widget.catatan?.isEmpty ?? true
                        ? ""
                        : widget.catatan!,
                  ),
                ],
              ),
            ),
            const Spacer(),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () async {
                      final result = await context.push<List<DotModel>>(
                        AppRoutes.editStock,
                        extra: dots,
                      );
                      if (result != null) {
                        setState(() {
                          dots = result;
                        });
                      }
                    },
                    child: const CustomText(
                      text: "Ubah",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                const CustomSpacing(width: 12),
                Expanded(
                  child: CustomButton(
                    text: "Konfirmasi",
                    backgroundColor: const Color(0xffDC2626),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    onPressed: () {
                      context.pop({
                        "dots": dots,
                        "nama": widget.nama,
                        "ukuran": widget.ukuran,
                        "ring": widget.ring,
                        "catatan": widget.catatan,
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
