import 'package:arena/components/bottom_sheet/custom_bottom_sheet_v2.dart';
import 'package:arena/components/icon_button/custom_icon_button_circle.dart';
import 'package:arena/components/custom_spacing.dart';
import 'package:arena/components/custom_text.dart';
import 'package:arena/config/design/app_snack_bar.dart';
import 'package:arena/config/theme/app_colors.dart';
import 'package:arena/models/enums/role.dart';
import 'package:arena/models/stock/stock_detail_model.dart';
import 'package:arena/pages/stock_detail/bloc/stock_detail_bloc.dart';
import 'package:arena/pages/stock_detail/bloc/stock_detail_event.dart';
import 'package:arena/pages/stock_detail/bloc/stock_detail_state.dart';
import 'package:arena/pages/stock_detail/components/adjust_stock_sheet.dart';
import 'package:arena/utils/app_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'widgets/card_info_ban.dart';
import 'widgets/card_harga.dart';
import 'widgets/table_stock_dot.dart';
import 'widgets/bottom_bar.dart';

class StockDetailPage extends StatelessWidget {
  final String productId;

  const StockDetailPage({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          StockDetailBloc()..add(StockDetailFetched(productId: productId)),
      child: _StockDetailView(productId: productId),
    );
  }
}

class _StockDetailView extends StatefulWidget {
  final String productId;

  const _StockDetailView({required this.productId});

  @override
  State<_StockDetailView> createState() => _StockDetailViewState();
}

class _StockDetailViewState extends State<_StockDetailView> {
  final ScrollController scrollController = ScrollController();
  Role? role;

  @override
  void initState() {
    super.initState();
    getRole();
  }

  Future<void> getRole() async {
    final String? roleStr = await AppSecureStorage.read(key: "user_role");
    setState(() {
      role = Role.fromString(roleStr);
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void _openAdjustSheet(BuildContext context, StockDetailBatch batch) {
    AdjustStockSheet.show(context, productId: widget.productId, batch: batch);
  }

  void _showMoreMenu() {
    final stock = context.read<StockDetailBloc>().state.stock;
    if (stock == null) return;

    final batches = stock.batches ?? [];

    CustomBottomSheetV2.show(
      context,
      hideHeader: true,
      children: [
        if (batches.isNotEmpty)
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: SupportAppColors.greyMidColor),
            ),
            child: ListTile(
              leading: const Icon(Icons.tune),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              title: const CustomText(text: "Sesuaikan Stok"),
              onTap: () async {
                await Future.microtask(() {});
                if (!context.mounted) return;
                context.pop();
                _selectBatch(batches);
              },
            ),
          ),
      ],
    );
  }

  void _selectBatch(List<StockDetailBatch> batches) {
    if (batches.length == 1) {
      _openAdjustSheet(context, batches.first);
      return;
    }

    CustomBottomSheetV2.show(
      context,
      hideHeader: true,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 16, bottom: 8),
          child: Align(
            alignment: Alignment.centerLeft,
            child: CustomText(
              text: "Pilih Batch",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
          ),
        ),
        ...batches.map(
          (batch) => Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: SupportAppColors.greyMidColor),
            ),
            child: ListTile(
              leading: const Icon(Icons.inventory_2),
              title: CustomText(text: batch.displayBatchCode),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              subtitle: CustomText(
                text: "Qty: ${batch.displayQuantity}",
                style: const TextStyle(
                  fontSize: 12,
                  color: SupportAppColors.greyColor,
                ),
              ),
              onTap: () async {
                await Future.microtask(() {});
                if (!context.mounted) return;
                context.pop();
                _openAdjustSheet(context, batch);
              },
            ),
          ),
        ),
        const CustomSpacing(height: 4),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StockDetailBloc, StockDetailState>(
      listener: (context, state) {
        if (state.updateSuccessMessage != null) {
          AppSnackBar.success(
            context: context,
            message: state.updateSuccessMessage!,
          );
        } else if (state.isFailure && state.errorMessage != null) {
          AppSnackBar.error(context: context, message: state.errorMessage!);
        }
      },
      builder: (context, state) {
        if (state.isInitial || state.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state.isFailure && state.stock == null) {
          return Scaffold(
            body: Center(
              child: CustomText(
                text: state.errorMessage ?? "Gagal memuat detail stock",
              ),
            ),
          );
        }

        final stock = state.stock!;

        return Scaffold(
          body: SafeArea(
            top: false,
            child: RefreshIndicator(
              onRefresh: () async {
                context.read<StockDetailBloc>().add(
                  StockDetailFetched(productId: widget.productId),
                );
              },
              child: Column(
                children: [
                  Expanded(
                    child: Scrollbar(
                      controller: scrollController,
                      thumbVisibility: true,
                      child: CustomScrollView(
                        controller: scrollController,
                        slivers: [
                          SliverAppBar(
                            elevation: 0,
                            backgroundColor: AppColors.bgColor,
                            surfaceTintColor: AppColors.bgColor,
                            floating: true,
                            snap: true,
                            pinned: true,
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
                            title: CustomText(
                              text: stock.displayProductName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                              ),
                            ),
                            actionsPadding: const EdgeInsets.only(right: 16),
                            actions: [
                              if (role == Role.owner ||
                                  role == Role.warehouseStaff)
                                CustomIconbuttonCircle(
                                  prefixIcon: Icons.more_vert,
                                  backgroundColor: Colors.white,
                                  iconColor: Colors.black,
                                  iconSize: 30,
                                  width: 60,
                                  height: 60,
                                  onPressed: _showMoreMenu,
                                ),
                            ],
                          ),

                          const SliverToBoxAdapter(
                            child: CustomSpacing(height: 20),
                          ),

                          SliverPadding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            sliver: SliverToBoxAdapter(
                              child: CardInfoBan(
                                nama: stock.displayProductName,
                                size: stock.displaySize,
                                ring: stock.displayRing,
                              ),
                            ),
                          ),

                          const SliverToBoxAdapter(
                            child: CustomSpacing(height: 8),
                          ),

                          SliverPadding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            sliver: SliverToBoxAdapter(
                              child: CardHarga(
                                hargaBeli: stock.displayHargaBeliTerakhir,
                                hargaJual: stock.displayHargaJualBawaan,
                                isOwner: role == Role.owner,
                              ),
                            ),
                          ),

                          const SliverToBoxAdapter(
                            child: CustomSpacing(height: 8),
                          ),

                          SliverPadding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            sliver: SliverToBoxAdapter(
                              child: TableStockDot(
                                batches: stock.batches ?? [],
                                sellPrice: stock.hargaJualTerakhir ?? 0,
                                buyPrice: stock.hargaBeliTerakhir ?? 0,
                                onAdjustBatch:
                                    (role == Role.owner ||
                                        role == Role.warehouseStaff)
                                    ? (batch) =>
                                          _openAdjustSheet(context, batch)
                                    : null,
                                isOwner: role == Role.owner,
                              ),
                            ),
                          ),

                          // const SliverToBoxAdapter(
                          //   child: CustomSpacing(height: 8),
                          // ),

                          // SliverPadding(
                          //   padding: const EdgeInsets.symmetric(horizontal: 16),
                          //   sliver: SliverToBoxAdapter(
                          //     child: DetailChart(
                          //       selectedIndex: 0,
                          //       onChanged: (int value) {},
                          //     ),
                          //   ),
                          // ),

                          // const SliverToBoxAdapter(
                          //   child: CustomSpacing(height: 8),
                          // ),

                          // const SliverPadding(
                          //   padding: EdgeInsets.symmetric(horizontal: 16),
                          //   sliver: SliverToBoxAdapter(
                          //     child: CardSummaryActivity(),
                          //   ),
                          // ),
                          const SliverToBoxAdapter(
                            child: CustomSpacing(height: 32),
                          ),
                        ],
                      ),
                    ),
                  ),

                  (role == Role.cashier || role == Role.customerServices)
                      ? BottomBar(stock: stock)
                      : const SizedBox.shrink(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
