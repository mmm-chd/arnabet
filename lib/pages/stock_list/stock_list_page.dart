import 'package:arena/components/cards/expandable_stock_card.dart';
import 'package:arena/components/current_user_avatar.dart';
import 'package:arena/components/icon_button/custom_icon_button_circle.dart';
import 'package:arena/components/header/header_search.dart';
import 'package:arena/config/design/custom_icons.dart';
import 'package:arena/config/routes/app_routes.dart';
import 'package:arena/config/theme/app_colors.dart';
import 'package:arena/pages/stock_list/bloc/stock_bloc.dart';
import 'package:arena/components/custom_spacing.dart';
import 'package:arena/utils/app_secure_storage.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:arena/pages/auth/login/bloc/login_bloc.dart';
import 'bloc/stock_event.dart';
import 'bloc/stock_state.dart';
import 'package:arena/components/custom_filter_chip.dart';
import 'package:arena/components/custom_text.dart';
import 'package:arena/models/enums/role.dart';
import 'package:arena/utils/nav_drawer.dart';

class StockListPage extends StatefulWidget {
  final String? filterBan;

  const StockListPage({super.key, this.filterBan});

  @override
  State<StockListPage> createState() => _StockListPageState();
}

class _StockListPageState extends State<StockListPage> {
  String selectedFilter = "Semua";
  final filters = ["Semua", "Healthy", "Warning", "Urgent"];
  late final ScrollController _scrollController;
  Role? _userRole;
  String _currentSortBy = 'expiry';

  @override
  void initState() {
    super.initState();
    _loadRole();
    _scrollController = ScrollController()..addListener(_onScroll);
    context.read<StockBloc>().add(LoadDotStatusRules());
  }

  Future<void> _loadRole() async {
    final raw = await AppSecureStorage.read(key: "user_role");
    final role = Role.fromString(raw);
    if (mounted) {
      setState(() {
        _userRole = role;
        _currentSortBy = (role == Role.warehouseStaff) ? 'latest' : 'expiry';
      });
      context.read<StockBloc>().add(
        LoadStock(brandName: widget.filterBan, sortBy: _currentSortBy),
      );
    }
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: SupportAppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CustomSpacing(height: 8),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const CustomSpacing(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: CustomText(
                    text: 'Urutkan Berdasarkan',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const CustomSpacing(height: 12),
                ...[
                  {'value': 'latest', 'label': 'Terbaru'},
                  {'value': 'expiry', 'label': 'Kadaluarsa'},
                ].map((option) {
                  final value = option['value']!;
                  final label = option['label']!;
                  final isSelected = _currentSortBy == value;
                  return ListTile(
                    leading: Icon(
                      Icons.circle,
                      size: 10,
                      color: isSelected
                          ? AppColors.primary
                          : Colors.grey.shade300,
                    ),
                    title: CustomText(
                      text: label,
                      style: TextStyle(
                        fontWeight: isSelected
                            ? FontWeight.w500
                            : FontWeight.normal,
                      ),
                    ),
                    onTap: () {
                      setModalState(() => _currentSortBy = value);
                      setState(() => _currentSortBy = value);
                      context.read<StockBloc>().add(ChangeSortBy(value));
                      context.pop();
                    },
                  );
                }),
                const CustomSpacing(height: 16),
              ],
            );
          },
        );
      },
    );
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<StockBloc>().add(LoadMoreStocks());
    }
  }

  @override
  void didUpdateWidget(StockListPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.filterBan != widget.filterBan) {
      context.read<StockBloc>().add(
        LoadStock(brandName: widget.filterBan, sortBy: _currentSortBy),
      );
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        floatingActionButton: BlocBuilder<StockBloc, StockState>(
          builder: (context, state) {
            final canAddStock =
                (_userRole == Role.warehouseStaff || _userRole == Role.owner) &&
                state.selectedStatusName == null;

            if (!canAddStock) {
              return const SizedBox.shrink();
            }

            return FloatingActionButton(
              backgroundColor: AppColors.primary,
              onPressed: () {
                context.push(AppRoutes.addStock);
              },
              child: const Icon(Icons.add),
            );
          },
        ),
        body: SafeArea(
          top: false,
          child: RefreshIndicator(
            onRefresh: () async {
              context.read<StockBloc>().add(
                LoadStock(brandName: widget.filterBan),
              );
              await context.read<StockBloc>().stream.firstWhere(
                (state) => state.status == StockListStatus.ready,
              );
            },
            child: CustomScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
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
                  expandedHeight: 130,
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
                  title: CustomText(
                    text: widget.filterBan != null
                        ? "Stok ${widget.filterBan}"
                        : "List Stok",
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                    ),
                  ),
                  actionsPadding: const EdgeInsets.only(right: 16),
                  actions: [
                    BlocBuilder<LoginBloc, LoginState>(
                      builder: (context, state) {
                        return (_userRole == Role.customerServices ||
                                _userRole == Role.cashier)
                            ? CustomIconbuttonCircle(
                                onPressed: () {
                                  context.push(AppRoutes.cartList);
                                },
                                isCustom: true,
                                useSvg: true,
                                iconWidth: 28,
                                iconHeight: 28,
                                width: 48,
                                height: 48,
                                backgroundColor: Colors.white,
                                assetPath: CustomIcons.cart,
                              )
                            : const SizedBox.shrink();
                      },
                    ),
                    const CustomSpacing(width: 12),
                    InkWell(
                      borderRadius: BorderRadius.circular(50),
                      onTap: () => context.push(AppRoutes.profile),
                      child: const CurrentUserAvatar(),
                    ),
                  ],
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(63),
                    child: HeaderSearch(
                      useFilter: true,
                      onTapFilter: _showFilterSheet,
                      onChanged: (value) {
                        context.read<StockBloc>().add(SearchStock(value));
                      },
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: BlocBuilder<StockBloc, StockState>(
                    buildWhen: (prev, curr) =>
                        prev.dotStatusRules != curr.dotStatusRules ||
                        prev.selectedStatusName != curr.selectedStatusName,
                    builder: (context, state) {
                      final activeRules =
                          state.dotStatusRules
                              .where((r) => r.isActive == true)
                              .toList()
                            ..sort(
                              (a, b) =>
                                  (a.priority ?? 0).compareTo(b.priority ?? 0),
                            );

                      final chips = <({String? name, String label})>[
                        (name: null, label: 'Semua'),
                        ...activeRules.map(
                          (r) => (name: r.name, label: r.displayName),
                        ),
                      ];

                      return SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          spacing: 8,
                          children: chips.map((chip) {
                            final isSelected =
                                state.selectedStatusName == chip.name;
                            return CustomFilterChip(
                              label: chip.label,
                              isSelected: isSelected,
                              onTap: () {
                                final newName = isSelected ? null : chip.name;
                                context.read<StockBloc>().add(
                                  FilterStock(
                                    statusName: newName,
                                    brandName: widget.filterBan,
                                  ),
                                );
                              },
                            );
                          }).toList(),
                        ),
                      );
                    },
                  ),
                ),

                const SliverToBoxAdapter(child: CustomSpacing(height: 12)),

                BlocListener<StockBloc, StockState>(
                  listener: (context, state) {
                    if (state.isReady) {
                      if (_scrollController.hasClients) {
                        _scrollController.animateTo(
                          0,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                        );
                      }
                    }
                  },
                  child: BlocBuilder<StockBloc, StockState>(
                    builder: (context, state) {
                      if (state.isReady) {
                        if (state.stocks.isEmpty) {
                          return const SliverFillRemaining(
                            hasScrollBody: false,
                            child: Center(
                              child: CustomText(text: "Tidak ada stok"),
                            ),
                          );
                        }

                        return SliverPadding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                          sliver: SliverList.builder(
                            itemCount:
                                state.stocks.length +
                                (state.hasReachedMax ? 0 : 1),
                            itemBuilder: (context, index) {
                              if (index >= state.stocks.length) {
                                return const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }

                              final item = state.stocks[index];
                              final firstItem = index == 0;
                              final lastItem = index == state.stocks.length - 1;

                              return Padding(
                                key: ValueKey(item.displayProductId),
                                padding: const EdgeInsets.only(top: 2),
                                child: ExpandableStockCard(
                                  item: item,
                                  firstItem: firstItem,
                                  lastItem: lastItem,
                                  size: item.displaySize,
                                  ring: item.displayRing,
                                  totalBatches: item.displayTotalBatches,
                                  dotStatus:
                                      item
                                          .batchStatus
                                          ?.displayBatchStatusName ??
                                      "Undefined",
                                ),
                              );
                            },
                          ),
                        );
                      }

                      if (state.isFailure) {
                        return SliverFillRemaining(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.error_outline,
                                    size: 48,
                                    color: Colors.red,
                                  ),
                                  const CustomSpacing(height: 12),
                                  CustomText(
                                    text: state.errorMessage ?? "Error",
                                    textAlign: TextAlign.center,
                                  ),
                                  const CustomSpacing(height: 20),
                                  const CustomText(
                                    text: "Tarik ke bawah untuk memuat ulang",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }

                      return const SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    },
                  ),
                ),

                const SliverToBoxAdapter(child: CustomSpacing(height: 88)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
