import 'package:arena/components/bottom_sheet/custom_bottom_sheet_v2.dart';
import 'package:arena/components/build/build_label.dart';
import 'package:arena/components/custom_button.dart';
import 'package:arena/components/icon_button/custom_icon_button_circle.dart';
import 'package:arena/components/text_field/custom_text_field.dart';
import 'package:arena/config/design/app_snack_bar.dart';
import 'package:arena/config/theme/app_colors.dart';
import 'package:arena/models/stock/dot_status_rule_model.dart';
import 'package:arena/models/stock/stock_status_rule_model.dart';
import 'package:arena/pages/stock_list/bloc/stock_bloc.dart';
import 'package:arena/pages/stock_list/bloc/stock_event.dart';
import 'package:arena/pages/stock_list/bloc/stock_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:arena/components/custom_spacing.dart';
import 'package:arena/components/custom_text.dart';
import 'package:go_router/go_router.dart';
import 'widgets/dot_status_rules_table.dart';
import 'widgets/stock_status_rules_table.dart';

class StockInventoryPage extends StatefulWidget {
  const StockInventoryPage({super.key});

  @override
  State<StockInventoryPage> createState() => _StockInventoryPageState();
}

class _StockInventoryPageState extends State<StockInventoryPage> {
  @override
  void initState() {
    super.initState();
    context.read<StockBloc>().add(LoadDotStatusRules());
    context.read<StockBloc>().add(LoadStockStatusRules());
  }

  void _showEditSheet(BuildContext context, Datum rule) {
    final minController = TextEditingController(
      text: rule.minMonth?.toString() ?? '',
    );
    final maxController = TextEditingController(
      text: rule.maxMonth?.toString() ?? '',
    );

    CustomBottomSheetV2.show(
      context,
      title: "Edit ${rule.displayName}",
      isScrollable: true,
      initialChildSize: 0.5,
      onSave: () async {
        final minMonth = int.tryParse(minController.text.trim());
        final maxMonth = int.tryParse(maxController.text.trim());

        if (minMonth == null && maxMonth == null) {
          AppSnackBar.warning(
            context: context,
            message: "Isi minimal salah satu kolom (Min atau Max Bulan)",
          );
          return false;
        }

        final bloc = context.read<StockBloc>();
        final previousRules = bloc.state.dotStatusRules;
        bloc.add(
          UpdateDotStatusRule(
            id: rule.id ?? '',
            minMonth: minMonth,
            maxMonth: maxMonth,
          ),
        );

        await bloc.stream.firstWhere(
          (s) => s.dotStatusRules != previousRules || s.errorMessage != null,
        );

        if (!context.mounted) return false;

        if (bloc.state.errorMessage != null) {
          AppSnackBar.error(
            context: context,
            message: bloc.state.errorMessage!,
          );
          return false;
        }

        AppSnackBar.success(
          context: context,
          message: "Aturan status berhasil diperbarui",
        );
        return true;
      },
      children: [
        const CustomText(
          text: "Batas Bulan",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: SupportAppColors.greyDarkerColor,
          ),
        ),
        const CustomSpacing(height: 8),
        const BuildLabel(text: "Min Bulan"),
        CustomTextField(
          controller: minController,
          label: "Min Bulan",
          hint: "Kosongkan jika tanpa batas bawah",
          isNumber: true,
          filled: true,
        ),
        const CustomSpacing(height: 12),
        const BuildLabel(text: "Max Bulan"),
        CustomTextField(
          controller: maxController,
          label: "Max Bulan",
          hint: "Kosongkan jika tanpa batas atas",
          isNumber: true,
          filled: true,
        ),
        const CustomSpacing(height: 4),
        const CustomText(
          text: "Kosongkan kolom untuk menetapkan batas tanpa batas (null).",
          style: TextStyle(fontSize: 12, color: SupportAppColors.greyColor),
        ),
      ],
    );
  }

  void _showStockRuleEditSheet(BuildContext context, StockStatusRuleItem rule) {
    final minController = TextEditingController(
      text: rule.minQty?.toString() ?? '',
    );
    final maxController = TextEditingController(
      text: rule.maxQty?.toString() ?? '',
    );

    CustomBottomSheetV2.show(
      context,
      title: "Edit ${rule.displayName}",
      isScrollable: true,
      initialChildSize: 0.5,
      onSave: () async {
        final minQty = int.tryParse(minController.text.trim());
        final maxQty = int.tryParse(maxController.text.trim());

        if (minQty == null && maxQty == null) {
          AppSnackBar.warning(
            context: context,
            message: "Isi minimal salah satu kolom (Min atau Max Qty)",
          );
          return false;
        }

        final bloc = context.read<StockBloc>();
        final previousRules = bloc.state.stockStatusRules;
        bloc.add(
          UpdateStockStatusRule(
            id: rule.id ?? '',
            minQty: minQty,
            maxQty: maxQty,
          ),
        );

        await bloc.stream.firstWhere(
          (s) => s.stockStatusRules != previousRules || s.errorMessage != null,
        );

        if (!context.mounted) return false;

        if (bloc.state.errorMessage != null) {
          AppSnackBar.error(
            context: context,
            message: bloc.state.errorMessage!,
          );
          return false;
        }

        AppSnackBar.success(
          context: context,
          message: "Threshold stock berhasil diperbarui",
        );
        return true;
      },
      children: [
        const CustomText(
          text: "Batas Qty",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: SupportAppColors.greyDarkerColor,
          ),
        ),
        const CustomSpacing(height: 8),
        const BuildLabel(text: "Min Qty"),
        CustomTextField(
          controller: minController,
          label: "Min Qty",
          hint: "Kosongkan jika tanpa batas bawah",
          isNumber: true,
          filled: true,
        ),
        const CustomSpacing(height: 12),
        const BuildLabel(text: "Max Qty"),
        CustomTextField(
          controller: maxController,
          label: "Max Qty",
          hint: "Kosongkan jika tanpa batas atas",
          isNumber: true,
          filled: true,
        ),
        const CustomSpacing(height: 4),
        const CustomText(
          text: "Kosongkan kolom untuk menetapkan batas tanpa batas (null).",
          style: TextStyle(fontSize: 12, color: SupportAppColors.greyColor),
        ),
      ],
    );
  }

  Widget _card(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: SupportAppColors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
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
          text: "Stock & Inventory",
          style: TextStyle(
            color: SupportAppColors.greyDarkerColor,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          /// CARD 1
          BlocBuilder<StockBloc, StockState>(
            buildWhen: (previous, current) =>
                previous.stockStatusRules != current.stockStatusRules ||
                previous.stockStatusRulesLoading !=
                    current.stockStatusRulesLoading ||
                previous.errorMessage != current.errorMessage,
            builder: (context, state) {
              final rules = state.stockStatusRules;
              if (state.stockStatusRulesLoading && rules.isEmpty) {
                return _card([
                  const CustomText(
                    text: "Threshold Stock",
                    style: TextStyle(
                      color: SupportAppColors.greyColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  const CustomSpacing(height: 24),
                  const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  const CustomSpacing(height: 24),
                ]);
              }
              if (rules.isEmpty) {
                return _card([
                  const CustomText(
                    text: "Threshold Stock",
                    style: TextStyle(
                      color: SupportAppColors.greyColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  const CustomSpacing(height: 12),
                  CustomText(
                    text: state.errorMessage != null
                        ? "Gagal memuat data: ${state.errorMessage}"
                        : "Belum ada aturan threshold",
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  if (state.errorMessage != null) ...[
                    const CustomSpacing(height: 12),
                    CustomButton(
                      text: "Muat Ulang",
                      backgroundColor: AppColors.primary,
                      foregroundColor: SupportAppColors.white,
                      onPressed: () =>
                          context.read<StockBloc>().add(LoadStockStatusRules()),
                    ),
                  ],
                ]);
              }
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: StockStatusRulesTable(
                  rules: rules,
                  onEdit: (rule) => _showStockRuleEditSheet(context, rule),
                ),
              );
            },
          ),

          /// CARD 2
          BlocBuilder<StockBloc, StockState>(
            buildWhen: (previous, current) =>
                previous.dotStatusRules != current.dotStatusRules ||
                previous.dotStatusRulesLoading !=
                    current.dotStatusRulesLoading ||
                previous.errorMessage != current.errorMessage,
            builder: (context, state) {
              final rules = state.dotStatusRules;
              if (state.dotStatusRulesLoading && rules.isEmpty) {
                return _card([
                  const CustomText(
                    text: "Dot Status Rules",
                    style: TextStyle(
                      color: SupportAppColors.greyColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  const CustomSpacing(height: 24),
                  const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  const CustomSpacing(height: 24),
                ]);
              }
              if (rules.isEmpty) {
                return _card([
                  const CustomText(
                    text: "Dot Status Rules",
                    style: TextStyle(
                      color: SupportAppColors.greyColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  const CustomSpacing(height: 12),
                  CustomText(
                    text: state.errorMessage != null
                        ? "Gagal memuat data: ${state.errorMessage}"
                        : "Belum ada aturan status",
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  if (state.errorMessage != null) ...[
                    const CustomSpacing(height: 12),
                    CustomButton(
                      text: "Muat Ulang",
                      backgroundColor: AppColors.primary,
                      foregroundColor: SupportAppColors.white,
                      onPressed: () =>
                          context.read<StockBloc>().add(LoadDotStatusRules()),
                    ),
                  ],
                ]);
              }
              return Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: DotStatusRulesTable(
                  rules: rules,
                  onEdit: (rule) => _showEditSheet(context, rule),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
