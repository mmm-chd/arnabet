import 'package:arena/components/cards/expandable_history_card.dart';
import 'package:arena/components/cards/expandable_stock_card.dart';
import 'package:arena/components/current_user_avatar.dart';
import 'package:arena/components/icon_button/custom_icon_button_circle.dart';
import 'package:arena/components/custom_spacing.dart';
import 'package:arena/components/custom_text.dart';
import 'package:arena/config/theme/app_colors.dart';
import 'package:arena/config/routes/app_routes.dart';
import 'package:arena/components/list_header.dart';
import 'package:arena/models/stock/stock_list_model.dart';
import 'package:arena/pages/dashboard/owner/components/header/dashboard_header_bottom.dart';
import 'package:arena/pages/dashboard/owner/bloc/dashboard_bloc.dart';
import 'package:arena/pages/dashboard/owner/bloc/dashboard_event.dart';
import 'package:arena/pages/dashboard/owner/bloc/dashboard_state.dart';
import 'package:arena/pages/history/bloc/history_bloc.dart';
import 'package:arena/pages/history/bloc/history_event.dart';
import 'package:arena/pages/history/bloc/history_state.dart';
import 'package:arena/pages/profile/bloc/profile_bloc.dart';
import 'package:arena/pages/profile/bloc/profile_state.dart';
import 'package:arena/pages/stock_list/bloc/stock_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:arena/pages/stock_list/bloc/stock_bloc.dart';
import 'package:arena/pages/stock_list/bloc/stock_state.dart';
import 'package:go_router/go_router.dart';

import 'components/dashboard_stat_card.dart';
import 'package:arena/utils/nav_drawer.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  static const List<String> _periods = ["1D", "1W", "1M", "6M", "1Y"];
  static const List<String> _periodLabels = ['1h', '1m', '1b', '6b', '1thn'];
  int selectedTimeIndex = 2;
  DateTime? startDate;
  DateTime? endDate;
  final ScrollController _scrollController = ScrollController();

  String get _selectedPeriod => _periods[selectedTimeIndex];

  String _greetingPrefix() {
    final hour = DateTime.now().hour;
    if (hour < 11) return "Selamat Pagi";
    if (hour < 15) return "Selamat Siang";
    if (hour < 19) return "Selamat Sore";
    return "Selamat Malam";
  }

  String _periodPhrase() {
    switch (selectedTimeIndex) {
      case 0:
        return "hari ini";
      case 1:
        return "minggu ini";
      case 3:
        return "6 bulan terakhir";
      case 4:
        return "tahun ini";
      default:
        return "bulan ini";
    }
  }

  void _forceRelayout() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.offset);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    context.read<StockBloc>().add(LoadStock());
    context.read<HistoryBloc>().add(LoadHistory());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return MultiBlocListener(
          listeners: [
            BlocListener<StockBloc, StockState>(
              listener: (context, state) {
                if (state.isLoading) _forceRelayout();
              },
            ),
            BlocListener<HistoryBloc, HistoryState>(
              listener: (context, state) {
                if (state.isLoading) _forceRelayout();
              },
            ),
            BlocListener<DashboardBloc, DashboardState>(
              listener: (context, state) {
                if (state.isLoading) _forceRelayout();
              },
            ),
          ],
          child: Scaffold(
            body: SafeArea(
              top: false,
              child: RefreshIndicator(
                onRefresh: () async {
                  context.read<StockBloc>().add(LoadStock());
                  context.read<HistoryBloc>().add(LoadHistory());
                  context.read<DashboardBloc>().add(
                    RefreshDashboard(period: _selectedPeriod),
                  );
                },
                child: CustomScrollView(
                  controller: _scrollController,
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
                          onTap: () => context.push(AppRoutes.profile),
                          child: const CurrentUserAvatar(),
                        ),
                      ],
                    ),

                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      sliver: SliverToBoxAdapter(
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
                                          color:
                                              SupportAppColors.greyDarkerColor,
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
                              text: "Berikut ringkasan stok ${_periodPhrase()}",
                              style: const TextStyle(
                                fontSize: 13,
                                color: SupportAppColors.greyColor,
                              ),
                            ),
                            const CustomSpacing(height: 12),
                          ],
                        ),
                      ),
                    ),

                    SliverToBoxAdapter(
                      child: DashboardHeaderBottom(
                        selectedIndex: selectedTimeIndex,
                        labels: _periodLabels,
                        onChanged: (index) {
                          setState(() => selectedTimeIndex = index);
                          context.read<DashboardBloc>().add(
                            LoadDashboard(period: _periods[index]),
                          );
                        },
                        onDateRangeSelected: (start, end) {
                          setState(() {
                            startDate = start;
                            endDate = end;
                          });
                        },
                        startDate: startDate,
                        endDate: endDate,
                      ),
                    ),

                    SliverToBoxAdapter(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        scrollDirection: Axis.horizontal,
                        child: IntrinsicHeight(
                          child: BlocBuilder<DashboardBloc, DashboardState>(
                            builder: (context, state) {
                              final data = state.dashboard;
                              final catalog = data?.catalog;
                              final incoming = data?.movement?.incoming;
                              final outgoing = data?.movement?.outgoing;
                              final chart = data?.chart;
                              final incomingText =
                                  incoming?.displayQty ??
                                  (chart != null
                                      ? "${chart.totalIncoming}"
                                      : "-");
                              final outgoingText =
                                  outgoing?.displayQty ??
                                  (chart != null
                                      ? "${chart.totalOutgoing}"
                                      : "-");

                              return Row(
                                children: [
                                  DashboardStatCard(
                                    title: "Total produk",
                                    value: catalog?.displayTotalProducts ?? "-",
                                    unit: "",
                                  ),
                                  const CustomSpacing(width: 8),
                                  DashboardStatCard(
                                    title: "Stock masuk",
                                    value: incomingText,
                                    percent: incoming?.trendPercentage != null
                                        ? incoming!.displayTrendPercentage
                                        : null,
                                    isDown: incoming?.isDown ?? false,
                                  ),
                                  const CustomSpacing(width: 8),
                                  DashboardStatCard(
                                    title: "Stock keluar",
                                    value: outgoingText,
                                    percent: outgoing?.trendPercentage != null
                                        ? outgoing!.displayTrendPercentage
                                        : null,
                                    isDown: outgoing?.isDown ?? false,
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ),

                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const CustomSpacing(height: 12),
                            ListHeader(
                              title: 'Perlu Restock',
                              description: 'Daftar produk yang stoknya menipis',
                              onTap: () =>
                                  context.push(AppRoutes.stockListOwner),
                            ),

                            BlocBuilder<StockBloc, StockState>(
                              builder: (context, state) {
                                if (state.isLoading) {
                                  return Container(
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
                                }

                                if (state.isReady) {
                                  final restockList = state.stocks
                                      .where(
                                        (item) => (item.totalQty ?? 0) < 20,
                                      )
                                      .toList();

                                  restockList.sort((a, b) {
                                    final qtyA = a.totalQty ?? 0;
                                    final qtyB = b.totalQty ?? 0;
                                    final isUrgentA = qtyA < 10;
                                    final isUrgentB = qtyB < 10;
                                    if (isUrgentA && !isUrgentB) return -1;
                                    if (!isUrgentA && isUrgentB) return 1;
                                    return qtyA.compareTo(qtyB);
                                  });

                                  final displayList = restockList.isNotEmpty
                                      ? restockList.take(2).toList()
                                      : (List<StockListDatum>.from(state.stocks)
                                              ..sort(
                                                (a, b) => (a.totalQty ?? 0)
                                                    .compareTo(b.totalQty ?? 0),
                                              ))
                                            .take(2)
                                            .toList();

                                  if (displayList.isEmpty) {
                                    return Container(
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
                                            text: "Belum ada stok",
                                          ),
                                        ),
                                      ),
                                    );
                                  }

                                  return Column(
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
                                          totalBatches:
                                              item.displayTotalBatches,
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

                                return Container(
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
                                          color:
                                              SupportAppColors.greyDarkerColor,
                                        ),
                                      ),
                                      const CustomSpacing(height: 4),
                                      CustomText(
                                        text:
                                            "Tarik ke bawah untuk memuat ulang",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: SupportAppColors.greyColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),

                            const CustomSpacing(height: 12),
                            ListHeader(
                              title: 'Riwayat Stok',
                              description: 'Perubahan Stok Terbaru',
                              onTap: () => context.push(AppRoutes.historyOwner),
                            ),

                            BlocBuilder<HistoryBloc, HistoryState>(
                              builder: (context, state) {
                                if (state.isLoading) {
                                  return Container(
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
                                }

                                if (state.isReady) {
                                  final displayHistories = state
                                      .filteredHistories
                                      .take(2)
                                      .toList();

                                  if (displayHistories.isEmpty) {
                                    return Container(
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
                                  }

                                  return Column(
                                    children: displayHistories
                                        .asMap()
                                        .entries
                                        .map((entry) {
                                          final index = entry.key;
                                          final item = entry.value;
                                          final lastItem =
                                              index ==
                                              displayHistories.length - 1;

                                          return Padding(
                                            key: ValueKey(index),
                                            padding: const EdgeInsets.only(
                                              top: 2,
                                            ),
                                            child: ExpandableHistoryCard(
                                              item: item,
                                              lastItem: lastItem,
                                              size: item.displaySize,
                                              ring: item.displayRing,
                                            ),
                                          );
                                        })
                                        .toList(),
                                  );
                                }

                                return Container(
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
                                          color:
                                              SupportAppColors.greyDarkerColor,
                                        ),
                                      ),
                                      const CustomSpacing(height: 4),
                                      CustomText(
                                        text:
                                            "Tarik ke bawah untuk memuat ulang",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: SupportAppColors.greyColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),

                            const CustomSpacing(height: 32),
                            Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 22,
                              ),
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
          ),
        );
      },
    );
  }
}
