import 'package:arena/components/build/build_dropdown.dart';
import 'package:arena/components/custom_spacing.dart';
import 'package:arena/components/custom_text.dart';
import 'package:arena/components/text_field/custom_text_field.dart';
import 'package:arena/config/routes/app_routes.dart';
import 'package:arena/config/theme/app_colors.dart';
import 'package:arena/helper/currency_local_formatter.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/dot_model.dart';
import '../../models/metadata/dropdown_item_model.dart';
import '../../components/custom_card_box.dart';
import 'components/dot_form_item.dart';

class EditStockPage extends StatefulWidget {
  final List<DotModel> dots;

  const EditStockPage({super.key, required this.dots});

  @override
  State<EditStockPage> createState() => _EditStockPageState();
}

class _EditStockPageState extends State<EditStockPage> {
  late List<DotModel> dots;

  final List<DropdownItemModel> namaBan = [
    DropdownItemModel(id: 1, name: "Turanza T005A"),
    DropdownItemModel(id: 2, name: "Potenza"),
    DropdownItemModel(id: 3, name: "Dueler"),
  ];
  final List<DropdownItemModel> ukuranBan = [
    DropdownItemModel(id: 1, name: "195/65"),
    DropdownItemModel(id: 2, name: "205/55"),
    DropdownItemModel(id: 3, name: "215/60"),
  ];
  final List<DropdownItemModel> ringBan = [
    DropdownItemModel(id: 1, name: "R14"),
    DropdownItemModel(id: 2, name: "R15"),
    DropdownItemModel(id: 3, name: "R16"),
  ];

  DropdownItemModel? selectedNama;
  DropdownItemModel? selectedUkuran;
  DropdownItemModel? selectedRing;

  final TextEditingController catatanController = TextEditingController();

  @override
  void initState() {
    super.initState();
    dots = List.from(widget.dots);
    selectedNama = namaBan.first;
    selectedUkuran = ukuranBan.first;
    selectedRing = ringBan.first;
  }

  int get totalPcs => dots.fold(0, (sum, d) => sum + d.jumlah);
  int get totalHarga =>
      dots.fold(0, (sum, d) => sum + (d.jumlah * (d.hargaBeli ?? 0)));

  /// DOT ITEM (FIX BUTTON)
  Widget dotItem(DotModel dotModel) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.black),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              text: dotModel.kode,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),

            /// QTY FIX
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    final index = dots.indexOf(dotModel);

                    if (dotModel.jumlah > 0) {
                      setState(() {
                        dots[index] = dotModel.copyWith(
                          jumlah: dotModel.jumlah - 1,
                        );
                      });
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.remove, size: 16),
                  ),
                ),
                const CustomSpacing(width: 10),
                CustomText(text: dotModel.jumlah.toString()),
                const CustomSpacing(width: 10),
                GestureDetector(
                  onTap: () {
                    final index = dots.indexOf(dotModel);

                    setState(() {
                      dots[index] = dotModel.copyWith(
                        jumlah: dotModel.jumlah + 1,
                      );
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.add, size: 16),
                  ),
                ),
              ],
            ),

            CustomText(
              text: dotModel.hargaBeli?.toLocaleCurrency() ?? '-',
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> tambahDot() async {
    final result = await context.push(AppRoutes.addDot);

    if (result is DotModel) {
      setState(() {
        dots.add(result);
      });
    }
  }

  Widget cardBox({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const CustomText(
          text: "Edit Stok",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            /// INFORMASI BAN (FIX)
            CustomCardBox(
              child: Column(
                children: [
                  BuildDropdown(
                    hint: "Nama",
                    value: selectedNama,
                    items: namaBan,
                    onChanged: (val) {
                      setState(() => selectedNama = val);
                    },
                  ),
                  const CustomSpacing(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: BuildDropdown(
                          hint: "Ukuran",
                          value: selectedUkuran,
                          items: ukuranBan,
                          onChanged: (val) {
                            setState(() => selectedUkuran = val);
                          },
                        ),
                      ),
                      const CustomSpacing(width: 12),
                      Expanded(
                        child: BuildDropdown(
                          hint: "Ring",
                          value: selectedRing,
                          items: ringBan,
                          onChanged: (val) {
                            setState(() => selectedRing = val);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const CustomSpacing(height: 16),

            /// DOT
            CustomCardBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const CustomText(
                        text: "Kode DOT",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      CustomText(text: "$totalPcs pcs"),
                    ],
                  ),
                  const CustomSpacing(height: 10),

                  Column(
                    children: dots.map((d) {
                      return DotFormItem(
                        dot: d,

                        onIncrement: () {
                          final index = dots.indexOf(d);

                          setState(() {
                            dots[index] = d.copyWith(jumlah: d.jumlah + 1);
                          });
                        },

                        onDecrement: () {
                          final index = dots.indexOf(d);

                          if (d.jumlah > 0) {
                            setState(() {
                              dots[index] = d.copyWith(jumlah: d.jumlah - 1);
                            });
                          }
                        },
                      );
                    }).toList(),
                  ),

                  const CustomSpacing(height: 10),

                  CustomSpacing(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: tambahDot,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const CustomText(text: "Tambah"),
                    ),
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
                  const CustomText(text: "Catatan"),
                  const CustomSpacing(height: 10),
                  CustomTextField(
                    controller: catatanController,
                    hint: "Tambahkan catatan...",
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ],
              ),
            ),

            const CustomSpacing(height: 16),

            /// TOTAL
            CustomCardBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CustomText(
                    text: "Total HPP",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  CustomText(
                    text: totalHarga.toLocaleCurrency(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
