import 'package:arena/components/bottom_sheet/custom_bottom_sheet_fix.dart';
import 'package:arena/components/custom_button.dart';
import 'package:arena/components/icon_button/custom_icon_button_circle.dart';
import 'package:arena/components/custom_spacing.dart';
import 'package:arena/components/custom_text.dart';
import 'package:arena/components/dialog/custom_dialog.dart';
import 'package:arena/config/design/app_snack_bar.dart';
import 'package:arena/config/routes/app_routes.dart';
import 'package:arena/config/theme/app_colors.dart';
import 'package:arena/helper/currency_local_formatter.dart';
import 'package:arena/models/widgets/stock_item_model.dart';
import 'package:arena/pages/add_stock/bloc/add_stock_bloc.dart';
import 'package:arena/pages/add_stock/bloc/add_stock_event.dart';
import 'package:arena/pages/add_stock/bloc/add_stock_state.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:arena/config/routes/nav_routes.dart';
import 'package:arena/models/enums/role.dart';
import 'package:arena/utils/app_secure_storage.dart';
import 'components/add_dot_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../stock_list/bloc/stock_bloc.dart';
import '../stock_list/bloc/stock_event.dart';
import '../../models/dot_model.dart';
import '../../models/tire_model.dart';

class AddStockPage extends StatefulWidget {
  final TireModel tire;

  const AddStockPage({super.key, required this.tire});

  @override
  State<AddStockPage> createState() => _AddStockPageState();
}

class _AddStockPageState extends State<AddStockPage> {
  final Set<String> expandedIds = {};

  bool isSelectionMode = false;
  final Set<String> selectedIds = {};

  Role _userRole = Role.unknown;

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
    context.read<AddStockBloc>().add(InitializeAddStock(tire: widget.tire));
  }

  void _toggleExpand(String id) {
    setState(() {
      if (expandedIds.contains(id)) {
        expandedIds.remove(id);
      } else {
        expandedIds.add(id);
      }
    });
  }

  void _enterSelectionMode(String id) {
    setState(() {
      isSelectionMode = true;
      expandedIds.clear();
      selectedIds.add(id);
    });
  }

  void _toggleSelection(String id) {
    setState(() {
      if (selectedIds.contains(id)) {
        selectedIds.remove(id);
      } else {
        selectedIds.add(id);
      }
      if (selectedIds.isEmpty) isSelectionMode = false;
    });
  }

  void _exitSelectionMode() {
    setState(() {
      isSelectionMode = false;
      selectedIds.clear();
    });
  }

  void _toggleSelectAll(List<String> allIds) {
    setState(() {
      if (selectedIds.length == allIds.length) {
        selectedIds.clear();
      } else {
        selectedIds
          ..clear()
          ..addAll(allIds);
      }
    });
  }

  void _deleteSelected() {
    context.read<AddStockBloc>().add(RemoveStockItems(selectedIds.toList()));
    _exitSelectionMode();
  }

  void _editSelected() {
    final id = selectedIds.first;
    context.read<AddStockBloc>().add(EditStockItem(id));
    _exitSelectionMode();
    context.push(
      AppRoutes.addStockForm,
      extra: {'tire': widget.tire, 'bloc': context.read<AddStockBloc>()},
    );
  }

  void _showExitConfirmationDialog() {
    CustomBottomsheetfix.show(
      context,
      hideHeader: true,
      initialChildSize: 0.35,
      onDismissed: () {},
      onPressed: () {
        context.read<AddStockBloc>().add(DiscardCurrentItem());
        context.pop();
        return true;
      },
      onReset: () => context.pop(),
      primaryButtonText: 'Ya, Keluar',
      secondaryButtonText: 'Batal',
      pBackgroundColor: AppColors.primary,
      sBorderColor: Colors.grey.shade300,
      sForegroundColor: Colors.grey.shade600,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CustomText(
              text: "Batalkan Pengisian?",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            const CustomSpacing(height: 12),
            CustomText(
              text:
                  "Data yang telah Anda isi akan hilang dan tidak dapat dikembalikan.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
            const CustomSpacing(height: 16),
          ],
        ),
      ],
    );
  }

  Future<void> _addStock() async {
    context.read<AddStockBloc>().add(DiscardCurrentItem());
    context.push(AppRoutes.addStockForm, extra: widget.tire);
  }

  void _confirmSubmit() async {
    final confirm = await CustomDialog.show(
      context,
      title: "Konfirmasi",
      message: "Apakah Anda yakin ingin menambahkan stok ini?",
      primaryButtonText: "Ya",
      secondaryButtonText: "Tidak",
      onPressed: () => true,
    );

    if (confirm == true && mounted) {
      context.read<AddStockBloc>().add(SubmitPressed());
    }
  }

  Widget _buildDotItem(DotModel dot) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: SupportAppColors.greyMidColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: "DOT ${dot.kode}",
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              if (_userRole == Role.owner) ...[
                const CustomSpacing(height: 4),
                CustomText(
                  text: "${dot.jumlah} pcs",
                  style: const TextStyle(color: SupportAppColors.greyColor),
                ),
              ],
            ],
          ),
          if (_userRole == Role.warehouseStaff)
            CustomText(
              text: "${dot.jumlah} pcs",
              style: const TextStyle(color: SupportAppColors.greyColor),
            ),
          if (_userRole == Role.owner)
            CustomText(
              text: dot.hargaBeli?.toLocaleCurrency() ?? '-',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
        ],
      ),
    );
  }

  Widget _buildStockItemCard(StockItemModel item) {
    final isSelected = selectedIds.contains(item.id);
    final isExpanded = expandedIds.contains(item.id);

    return GestureDetector(
      onLongPress: () => _enterSelectionMode(item.id),
      onTap: isSelectionMode ? () => _toggleSelection(item.id) : null,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
        decoration: BoxDecoration(
          color: AppColors.bgColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            if (isSelectionMode)
              Checkbox(
                value: isSelected,
                onChanged: (_) => _toggleSelection(item.id),
              ),
            Expanded(
              child: Container(
                padding: EdgeInsets.fromLTRB(16, 16, 16, isExpanded ? 0 : 16),
                decoration: BoxDecoration(
                  color: SupportAppColors.white,
                  border: isSelected
                      ? Border.all(color: AppColors.primary)
                      : null,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text: item.productName,
                                maxLines: 1,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const CustomSpacing(height: 4),
                              CustomText(
                                text: item.note.isEmpty ? "-" : item.note,
                                style: const TextStyle(
                                  color: SupportAppColors.greyColor,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Flexible(
                          child: CustomText(
                            text: "${item.size} / ${item.ring}",
                            style: const TextStyle(
                              color: SupportAppColors.greyColor,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const CustomSpacing(height: 14),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const CustomText(
                              text: "DOT",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                              ),
                            ),
                            const CustomSpacing(height: 4),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: item.dots.length.toString(),
                                    style: const TextStyle(
                                      color: SupportAppColors.greyDarkerColor,
                                      fontSize: 32,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const TextSpan(
                                    text: " batch",
                                    style: TextStyle(
                                      color: SupportAppColors.greyColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const CustomText(
                              text: "Jumlah Stok",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                              ),
                            ),
                            const CustomSpacing(height: 4),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: item.totalPcs.toString(),
                                    style: const TextStyle(
                                      color: SupportAppColors.greyDarkerColor,
                                      fontSize: 32,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const TextSpan(
                                    text: " pcs",
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const CustomSpacing(height: 10),

                    InkWell(
                      onTap: () => _toggleExpand(item.id),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomText(
                            text: "Lihat Selengkapnya",
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 13,
                            ),
                          ),
                          const CustomSpacing(width: 4),
                          Icon(
                            isExpanded
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            size: 18,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),

                    if (isExpanded) ...[
                      const CustomSpacing(height: 16),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: item.dots.length,
                        itemBuilder: (context, index) =>
                            _buildDotItem(item.dots[index]),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddStockBloc, AddStockState>(
      listener: (context, state) {
        if (state.status == AddStockStatus.success) {
          context.read<StockBloc>().add(LoadStock());

          AppSnackBar.success(
            message: "Stok berhasil ditambahkan",
            context: context,
          );
          if (context.canPop()) {
            context.pop();
          } else {
            context.go(NavRoutes.getStockListRoute(_userRole));
          }
        } else if (state.status == AddStockStatus.failure) {
          AppSnackBar.error(
            message: state.errorMessage ?? "",
            context: context,
          );
        }
      },
      builder: (context, state) {
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
                iconColor: SupportAppColors.greyDarkerColor,
                iconSize: 24,
                width: 40,
                height: 40,
                onPressed: () {
                  if (isSelectionMode) {
                    _exitSelectionMode();
                  } else {
                    if (state.hasStockItems) {
                      _showExitConfirmationDialog();
                    } else {
                      context.read<AddStockBloc>().add(ResetAddStock());
                      context.pop();
                    }
                  }
                },
              ),
            ),
            titleSpacing: 16,
            title: const CustomText(
              text: "Tambah Stok",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),
          ),
          body: Column(
            children: [
              if (!state.hasStockItems)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 20,
                  ),
                  child: AddStockItemButton(onTap: _addStock),
                )
              else
                Expanded(
                  child: Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.stockItems.length,
                        itemBuilder: (context, index) {
                          final item = state.stockItems[index];
                          return _buildStockItemCard(item);
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: AddStockItemButton(onTap: _addStock),
                      ),
                    ],
                  ),
                ),

              if (!state.hasStockItems) const Spacer(),

              if (isSelectionMode && state.hasStockItems) ...[
                Container(
                  padding: EdgeInsets.only(
                    bottom: 24,
                    top: 12,
                    left: 16,
                    right: 16,
                  ),
                  decoration: BoxDecoration(color: SupportAppColors.white),
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: _exitSelectionMode,
                            ),
                            CustomText(text: "${selectedIds.length} dipilih"),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // Checkbox(
                            //   value:
                            //       state.stockItems.isNotEmpty &&
                            //       selectedIds.length == state.stockItems.length,
                            //   onChanged: (_) => _toggleSelectAll(
                            //     state.stockItems.map((e) => e.id).toList(),
                            //   ),
                            // ),
                            if (selectedIds.length == 1)
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: _editSelected,
                              ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: _deleteSelected,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    bottom: 32,
                  ),
                  child: CustomButton(
                    text: "Tambahkan",
                    backgroundColor: state.hasStockItems
                        ? AppColors.primary
                        : SupportAppColors.greyColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    onPressed: state.hasStockItems ? _confirmSubmit : null,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
