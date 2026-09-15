import 'dart:async';

import 'package:arena/components/cards/expandable_history_card.dart';
import 'package:arena/components/cards/expandable_stock_card.dart';
import 'package:arena/components/current_user_avatar.dart';
import 'package:arena/components/icon_button/custom_icon_button_circle.dart';
import 'package:arena/components/custom_spacing.dart';
import 'package:arena/components/custom_text.dart';
import 'package:arena/components/list_header.dart';
import 'package:arena/config/design/custom_icons.dart';
import 'package:arena/config/theme/app_colors.dart';
import 'package:arena/config/routes/app_routes.dart';
import 'package:arena/config/routes/app_name_route.dart';
import 'package:arena/models/enums/enums.dart';
import 'package:arena/pages/dashboard/owner/components/dashboard_stat_card.dart';
import 'package:arena/pages/dashboard/warehouse_staff/bloc/warehouse_dashboard_bloc.dart';
import 'package:arena/pages/dashboard/warehouse_staff/bloc/warehouse_dashboard_event.dart';
import 'package:arena/pages/dashboard/warehouse_staff/bloc/warehouse_dashboard_state.dart';
import 'package:arena/pages/profile/bloc/profile_bloc.dart';
import 'package:arena/pages/profile/bloc/profile_state.dart';
import 'package:arena/pages/history/bloc/history_bloc.dart';
import 'package:arena/pages/history/bloc/history_event.dart';
import 'package:arena/pages/history/bloc/history_state.dart';
import 'package:arena/pages/order_list/bloc/order_bloc.dart';
import 'package:arena/pages/order_list/bloc/order_event.dart';
import 'package:arena/pages/order_list/bloc/order_state.dart';
import 'package:flutter_svg/svg.dart';
import '../../stock_list/bloc/stock_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../stock_list/bloc/stock_bloc.dart';
import '../../stock_list/bloc/stock_state.dart';
import 'package:go_router/go_router.dart';
import '../../../components/cards/warehouse_order_card.dart';
import 'package:arena/utils/nav_drawer.dart';

class DashboardWarehousePage extends StatefulWidget {
  const DashboardWarehousePage({super.key});

  @override
  State<DashboardWarehousePage> createState() => _DashboardWarehousePageState();
}

class _DashboardWarehousePageState extends State<DashboardWarehousePage> {
  int selectedTimeIndex = 0;
  DateTime? startDate;
  DateTime? endDate;
  final ScrollController _scrollController = ScrollController();
  Timer? _autoRefreshTimer;

  @override
  void initState() {
    super.initState();
    context.read<StockBloc>().add(LoadStock());
    context.read<HistoryBloc>().add(LoadHistory());
    context.read<OrderBloc>().add(LoadOrders());
    context.read<WarehouseDashboardBloc>().add(const LoadWarehouseDashboard());

    _autoRefreshTimer = Timer.periodic(const Duration(minutes: 2), (_) {
      if (mounted) {
        setState(() {});
        _fetchAll();
      }
    });
  }

  void _fetchAll() {
    context.read<StockBloc>().add(LoadStock());
    context.read<HistoryBloc>().add(LoadHistory());
    context.read<OrderBloc>().add(LoadOrders());
    context.read<WarehouseDashboardBloc>().add(const LoadWarehouseDashboard());
  }

  @override
  void dispose() {
    _autoRefreshTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  bool _isToday(DateTime? date) {
    if (date == null) return false;
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  String _greetingPrefix() {
    final hour = DateTime.now().hour;
    if (hour < 11) return "Selamat Pagi";
    if (hour < 15) return "Selamat Siang";
    if (hour < 19) return "Selamat Sore";
    return "Selamat Malam";
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return Scaffold(
          backgroundColor: AppColors.bgColor,
          body: SafeArea(
            top: false,
            child: RefreshIndicator(
              onRefresh: () async {
                _fetchAll();
              },
              child: CustomScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverAppBar(
                    elevation: 0,
                    backgroundColor: AppColors.bgColor,
                    surfaceTintColor: AppColors.bgColor,
                    systemOverlayStyle: SystemUiOverlayStyle.dark,
                    floating: true,
                    snap: true,
                    automaticallyImplyLeading: false,
                    leadingWidth: 72,
                    leading: Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: CustomIconbuttonCircle(
                        prefixIcon: Icons.menu,
                        backgroundColor: SupportAppColors.white,
                        iconColor: SupportAppColors.greyDarkerColor,
                        iconSize: 24,
                        width: 40,
                        height: 40,
                        onPressed: () {
                          openNavDrawer(context);
                        },
                      ),
                    ),
                    titleSpacing: 16,
                    title: const CustomText(
                      text: "Dashboard",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                    ),
                    actionsPadding: const EdgeInsets.only(right: 16),
                    actions: [
                      InkWell(
                        borderRadius: BorderRadius.circular(50),
                        onTap: () {
                          context.push(AppRoutes.profile);
                        },
                        child: const CurrentUserAvatar(),
                      ),
                    ],
                  ),

                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CustomSpacing(height: 12),

                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: BlocBuilder<ProfileBloc, ProfileState>(
                                  builder: (context, state) {
                                    final name = state is ProfileLoaded
                                        ? state.name
                                        : "";
                                    final greeting = name.isNotEmpty
                                        ? "${_greetingPrefix()} $name!"
                                        : "${_greetingPrefix()}!";
                                    return CustomText(
                                      text: greeting,
                                      maxLines: 2,
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w600,
                                        color: SupportAppColors.greyDarkerColor,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Expanded(child: CustomSpacing(width: 12)),
                            ],
                          ),
                          const CustomSpacing(height: 4),
                          CustomText(
                            text:
                                "Berikut adalah aktivitas yang terjadi pada hari ini",
                            style: TextStyle(
                              fontSize: 13,
                              color: SupportAppColors.greyColor,
                            ),
                          ),
                          const CustomSpacing(height: 16),
                        ],
                      ),
                    ),
                  ),

                  SliverToBoxAdapter(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      scrollDirection: Axis.horizontal,
                      child:
                          BlocBuilder<
                            WarehouseDashboardBloc,
                            WarehouseDashboardState
                          >(
                            builder: (context, state) {
                              final data = state.data;
                              final totalStock = data?.totalStock;
                              final stockIn = data?.stockIn;
                              final stockOut = data?.stockOut;

                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  DashboardStatCard(
                                    title: "Total produk",
                                    value: totalStock?.displayCount ?? "-",
                                    percent: totalStock?.trendPercentage == null
                                        ? null
                                        : totalStock?.displayTrendPercentage,
                                    isDown: totalStock?.isDown ?? false,
                                  ),
                                  const CustomSpacing(width: 8),
                                  DashboardStatCard(
                                    title: "Total produk masuk",
                                    value: stockIn?.displayCount ?? "-",
                                    percent: stockIn?.trendPercentage == null
                                        ? null
                                        : stockIn?.displayTrendPercentage,
                                    isDown: stockIn?.isDown ?? false,
                                  ),
                                  const CustomSpacing(width: 8),
                                  DashboardStatCard(
                                    title: "Total produk keluar",
                                    value: stockOut?.displayCount ?? "-",
                                    percent: stockOut?.trendPercentage == null
                                        ? null
                                        : stockOut?.displayTrendPercentage,
                                    isDown: stockOut?.isDown ?? false,
                                  ),
                                ],
                              );
                            },
                          ),
                    ),
                  ),

                  const SliverPadding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                  ),

                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: ListHeader(
                        title: 'Order Hari Ini',
                        description: 'Daftar barang keluar berdasarkan order',
                        onTap: () => context.push(AppRoutes.orderListWarehouse),
                      ),
                    ),
                  ),

                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: BlocBuilder<OrderBloc, OrderState>(
                        builder: (context, state) {
                          Widget content;

                          if (state.isLoading) {
                            content = Container(
                              key: const ValueKey('order-loading'),
                              margin: EdgeInsets.only(top: 2, bottom: 16),
                              decoration: BoxDecoration(
                                color: SupportAppColors.white,
                                borderRadius: BorderRadius.vertical(
                                  bottom: Radius.circular(16),
                                ),
                              ),
                              child: const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(24.0),
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                            );
                          } else if (state.isReady || state.hasOrders) {
                            final todayOrders = state.orders
                                .where((o) => _isToday(o.createdAt))
                                .toList();
                            final displayOrders = todayOrders.take(2).toList();

                            if (displayOrders.isEmpty) {
                              content = Container(
                                key: const ValueKey('order-empty'),
                                margin: const EdgeInsets.only(top: 2),
                                decoration: BoxDecoration(
                                  color: SupportAppColors.white,
                                  borderRadius: BorderRadius.vertical(
                                    bottom: Radius.circular(16),
                                  ),
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(24.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          CustomIcons.orderList,
                                          colorFilter: ColorFilter.mode(
                                            SupportAppColors.greyMidColor,
                                            BlendMode.srcIn,
                                          ),
                                          width: 48,
                                          height: 48,
                                        ),
                                        CustomSpacing(height: 8),
                                        CustomText(
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: SupportAppColors.greyColor,
                                          ),
                                          text: "Belum ada order hari ini",
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              content = Column(
                                key: const ValueKey('order-list'),
                                children: displayOrders.asMap().entries.map((
                                  entry,
                                ) {
                                  final index = entry.key;
                                  final order = entry.value;
                                  final lastItem =
                                      index == displayOrders.length - 1;

                                  return Padding(
                                    key: ValueKey(order.id ?? index),
                                    padding: const EdgeInsets.only(top: 2),
                                    child: WarehouseOrderCard(
                                      key: ValueKey(order.id),
                                      invoiceNumber: order.displayInvoiceNumber,
                                      status:
                                          order.orderStatus ??
                                          OrderStatus.NEED_PICKUP,
                                      createdAt: order.createdAt,
                                      items: order.items ?? [],
                                      isPickedUp:
                                          order.orderStatus ==
                                          OrderStatus.PROCESSING,
                                      onTap: () => context.pushNamed(
                                        AppNameRoute.orderDetailWarehouse,
                                        pathParameters: {'id': order.id!},
                                      ),
                                      onConfirmPickup: () {
                                        context.read<OrderBloc>().add(
                                          MarkOrderAsPickedUp(
                                            orderId: order.id!,
                                          ),
                                        );
                                      },
                                      firstItem: false,
                                      lastItem: lastItem,
                                    ),
                                  );
                                }).toList(),
                              );
                            }
                          } else {
                            content = Container(
                              key: const ValueKey('order-error'),
                              width: double.infinity,
                              padding: const EdgeInsets.all(24.0),
                              margin: const EdgeInsets.only(top: 2),
                              decoration: BoxDecoration(
                                color: SupportAppColors.white,
                                borderRadius: BorderRadius.vertical(
                                  bottom: Radius.circular(16),
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    color: SupportAppColors.normalRed,
                                    size: 32,
                                  ),
                                  const CustomSpacing(height: 8),
                                  CustomText(
                                    text: "Gagal memuat order",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: SupportAppColors.greyDarkerColor,
                                    ),
                                  ),
                                  const CustomSpacing(height: 4),
                                  CustomText(
                                    text: "Tarik ke bawah untuk memuat ulang",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: SupportAppColors.greyColor,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }

                          return content;
                        },
                      ),
                    ),
                  ),

                  const SliverPadding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                  ),

                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: ListHeader(
                        title: 'Perlu Restock',
                        description: 'Daftar produk yang stoknya menipis',
                        onTap: () => context.push(AppRoutes.stockListWarehouse),
                      ),
                    ),
                  ),

                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: BlocBuilder<StockBloc, StockState>(
                        builder: (context, state) {
                          Widget content;

                          if (state.isLoading) {
                            content = Container(
                              key: const ValueKey('stock-loading'),
                              margin: EdgeInsets.only(top: 2),
                              decoration: BoxDecoration(
                                color: SupportAppColors.white,
                                borderRadius: BorderRadius.vertical(
                                  bottom: Radius.circular(16),
                                ),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.all(24.0),
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                            );
                          } else if (state.isReady) {
                            final restockList = state.stocks
                                .where((item) => (item.totalQty ?? 0) < 20)
                                .toList();
                            final displayList = restockList.take(2).toList();

                            if (displayList.isEmpty) {
                              content = Container(
                                key: const ValueKey('stock-empty'),
                                margin: EdgeInsets.only(top: 2),
                                decoration: BoxDecoration(
                                  color: SupportAppColors.white,
                                  borderRadius: BorderRadius.vertical(
                                    bottom: Radius.circular(16),
                                  ),
                                ),
                                child: const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(24.0),
                                    child: CustomText(
                                      text:
                                          "Belum ada stok yang perlu direstock",
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              content = Column(
                                key: const ValueKey('stock-list'),
                                children: displayList.asMap().entries.map((
                                  entry,
                                ) {
                                  final index = entry.key;
                                  final item = entry.value;
                                  final lastItem =
                                      index == displayList.length - 1;

                                  return Padding(
                                    key: ValueKey(item.productId ?? index),
                                    padding: const EdgeInsets.only(top: 2),
                                    child: ExpandableStockCard(
                                      item: item,
                                      lastItem: lastItem,
                                      size: item.displaySize,
                                      ring: item.displayRing,
                                      totalBatches: item.displayTotalBatches,
                                      dotStatus:
                                          item
                                              .batchStatus
                                              ?.displayBatchStatusName ??
                                          item.displayProductName,
                                    ),
                                  );
                                }).toList(),
                              );
                            }
                          } else {
                            content = Container(
                              key: const ValueKey('stock-error'),
                              width: double.infinity,
                              padding: const EdgeInsets.all(24.0),
                              margin: const EdgeInsets.only(top: 2),
                              decoration: BoxDecoration(
                                color: SupportAppColors.white,
                                borderRadius: BorderRadius.vertical(
                                  bottom: Radius.circular(16),
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    color: SupportAppColors.normalRed,
                                    size: 32,
                                  ),
                                  const CustomSpacing(height: 8),
                                  CustomText(
                                    text: "Gagal memuat stok",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: SupportAppColors.greyDarkerColor,
                                    ),
                                  ),
                                  const CustomSpacing(height: 4),
                                  CustomText(
                                    text: "Tarik ke bawah untuk memuat ulang",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: SupportAppColors.greyColor,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }

                          return content;
                        },
                      ),
                    ),
                  ),

                  SliverPadding(padding: EdgeInsets.symmetric(vertical: 8)),

                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: ListHeader(
                        title: 'Riwayat Stok',
                        description: 'Perubahan Stok Terbaru',
                        onTap: () => context.push(AppRoutes.historyWarehouse),
                      ),
                    ),
                  ),

                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: BlocBuilder<HistoryBloc, HistoryState>(
                        builder: (context, state) {
                          Widget content;

                          if (state.isLoading) {
                            content = Container(
                              key: const ValueKey('history-loading'),
                              margin: const EdgeInsets.only(top: 2),
                              decoration: BoxDecoration(
                                color: SupportAppColors.white,
                                borderRadius: BorderRadius.vertical(
                                  bottom: Radius.circular(16),
                                ),
                              ),
                              child: const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(24.0),
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                            );
                          } else if (state.isReady) {
                            final displayHistories = state.allHistories
                                .take(2)
                                .toList();

                            if (displayHistories.isEmpty) {
                              content = Container(
                                key: const ValueKey('history-empty'),
                                margin: const EdgeInsets.only(top: 2),
                                decoration: BoxDecoration(
                                  color: SupportAppColors.white,
                                  borderRadius: BorderRadius.vertical(
                                    bottom: Radius.circular(16),
                                  ),
                                ),
                                child: const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(24.0),
                                    child: CustomText(
                                      text: "Belum ada riwayat stok",
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              content = Column(
                                key: const ValueKey('history-list'),
                                children: displayHistories.asMap().entries.map((
                                  entry,
                                ) {
                                  final index = entry.key;
                                  final item = entry.value;
                                  final lastItem =
                                      index == displayHistories.length - 1;

                                  return Padding(
                                    key: ValueKey(index),
                                    padding: const EdgeInsets.only(top: 2),
                                    child: ExpandableHistoryCard(
                                      item: item,
                                      lastItem: lastItem,
                                      size: item.displaySize,
                                      ring: item.displayRing,
                                    ),
                                  );
                                }).toList(),
                              );
                            }
                          } else {
                            content = Container(
                              key: const ValueKey('history-error'),
                              width: double.infinity,
                              padding: const EdgeInsets.all(24.0),
                              margin: const EdgeInsets.only(top: 2),
                              decoration: BoxDecoration(
                                color: SupportAppColors.white,
                                borderRadius: BorderRadius.vertical(
                                  bottom: Radius.circular(16),
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    color: SupportAppColors.normalRed,
                                    size: 32,
                                  ),
                                  const CustomSpacing(height: 8),
                                  CustomText(
                                    text: "Gagal memuat riwayat",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: SupportAppColors.greyDarkerColor,
                                    ),
                                  ),
                                  const CustomSpacing(height: 4),
                                  CustomText(
                                    text: "Tarik ke bawah untuk memuat ulang",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: SupportAppColors.greyColor,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }

                          return content;
                        },
                      ),
                    ),
                  ),

                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CustomSpacing(height: 32),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 22),
                            alignment: Alignment.center,
                            child: CustomText(
                              text:
                                  "Akhir dari perjalanan. Butuh bantuan lain?",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: SupportAppColors.greyColor,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          const CustomSpacing(height: 42),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
