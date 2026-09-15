import 'dart:async';

import 'package:arena/components/bottom_sheet/custom_bottom_sheet.dart';
import 'package:arena/components/icon_button/custom_icon_button_circle.dart';
import 'package:arena/components/current_user_avatar.dart';
import 'package:arena/components/custom_spacing.dart';
import 'package:arena/components/custom_text.dart';
import 'package:arena/components/custom_filter_chip.dart';
import 'package:arena/components/header/header_search.dart';
import 'package:arena/config/routes/app_name_route.dart';
import 'package:arena/config/routes/app_routes.dart';
import 'package:arena/config/design/app_snack_bar.dart';
import 'package:arena/config/theme/app_colors.dart';
import 'package:arena/models/enums/enums.dart';
import 'package:arena/pages/order_list/cashier/widgets/cashier_order_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/order_bloc.dart';
import '../bloc/order_event.dart';
import '../bloc/order_state.dart';
import 'package:arena/utils/nav_drawer.dart';

class CashierOrderList extends StatefulWidget {
  const CashierOrderList({super.key});

  @override
  State<CashierOrderList> createState() => _CashierOrderListState();
}

class _CashierOrderListState extends State<CashierOrderList> {
  int selectedTab = 0;
  String query = '';
  Timer? _searchDebounce;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    context.read<OrderBloc>().add(
      LoadOrders(
        orderStatus: _statusForTab(selectedTab),
        paymentStatus: _selectedPaymentStatus,
        search: query.isEmpty ? null : query,
      ),
    );
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    setState(() => query = value);
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 400), () {
      if (!mounted) return;
      context.read<OrderBloc>().add(
        LoadOrders(
          orderStatus: _statusForTab(selectedTab),
          paymentStatus: _selectedPaymentStatus,
          search: query.trim().isEmpty ? null : query.trim(),
        ),
      );
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<OrderBloc>().add(LoadMoreOrders());
    }
  }

  void _refreshWithFilter() {
    context.read<OrderBloc>().add(
      LoadOrders(
        orderStatus: _statusForTab(selectedTab),
        paymentStatus: _selectedPaymentStatus,
        search: query.trim().isEmpty ? null : query.trim(),
      ),
    );
  }

  void _showConfirmSheet({
    required String title,
    required String message,
    required String confirmText,
    required FutureOr<bool?> Function() onConfirm,
  }) {
    CustomBottomsheet.show(
      context,
      title: title,
      initialChildSize: 0.4,
      onDismissed: () {},
      secondaryButtonText: 'Batal',
      primaryButtonText: confirmText,
      sBorderColor: AppColors.primary,
      pBackgroundColor: AppColors.primary,
      sBackgroundColor: SupportAppColors.white,
      onReset: () {},
      onPressed: onConfirm,
      children: [
        CustomText(
          text: message,
          style: const TextStyle(fontSize: 16),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  final List<String> _tabLabels = [
    'Semua',
    'Perlu Diambil',
    'Diproses',
    'Selesai',
    'Dibatalkan',
  ];

  OrderStatus? _statusForTab(int tab) {
    switch (tab) {
      case 1:
        return OrderStatus.NEED_PICKUP;
      case 2:
        return OrderStatus.PROCESSING;
      case 3:
        return OrderStatus.COMPLETED;
      case 4:
        return OrderStatus.CANCELLED;
      default:
        return null;
    }
  }

  PaymentStatus? _selectedPaymentStatus;

  static const List<PaymentStatus?> _paymentFilterValues = [
    null,
    PaymentStatus.UNPAID,
    PaymentStatus.PAID,
    PaymentStatus.PROCESSING,
    PaymentStatus.FAILED,
    PaymentStatus.EXPIRED,
    PaymentStatus.REFUNDED,
  ];

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
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
            ..._paymentFilterValues.asMap().entries.map((entry) {
              final status = entry.value;
              final label = status?.toIndonesian() ?? 'Semua';
              final isSelected = status == _selectedPaymentStatus;
              return ListTile(
                leading: Icon(
                  Icons.circle,
                  size: 10,
                  color: isSelected ? AppColors.primary : Colors.grey.shade300,
                ),
                title: CustomText(
                  text: label,
                  style: TextStyle(
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
                onTap: () {
                  setState(() => _selectedPaymentStatus = status);
                  _refreshWithFilter();
                  context.pop();
                },
              );
            }),
            const CustomSpacing(height: 16),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrderBloc, OrderState>(
      listenWhen: (previous, current) =>
          previous.errorMessage != current.errorMessage &&
          current.errorMessage != null,
      listener: (context, state) {
        AppSnackBar.error(context: context, message: state.errorMessage!);
      },
      child: Scaffold(
        backgroundColor: AppColors.bgColor,
        body: SafeArea(
          top: false,
          child: RefreshIndicator(
            onRefresh: () async {
              _refreshWithFilter();
              await context.read<OrderBloc>().stream.firstWhere(
                (state) => !state.isLoading && !state.isInitial,
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
                  title: const CustomText(
                    text: 'List Pesanan',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
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
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(63),
                    child: HeaderSearch(
                      useFilter: true,
                      onTapFilter: _showFilterSheet,
                      onChanged: _onSearchChanged,
                      onTapSearch: () {},
                    ),
                  ),
                ),

                // Filter chips
                SliverToBoxAdapter(
                  child: CustomSpacing(
                    height: 40,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _tabLabels.length,
                      separatorBuilder: (_, __) =>
                          const CustomSpacing(width: 8),
                      itemBuilder: (context, i) {
                        return CustomFilterChip(
                          label: _tabLabels[i],
                          isSelected: selectedTab == i,
                          onTap: () {
                            setState(() => selectedTab = i);
                            _refreshWithFilter();
                          },
                        );
                      },
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: CustomSpacing(height: 8)),

                // Order list
                BlocBuilder<OrderBloc, OrderState>(
                  builder: (context, state) {
                    if (state.isLoading) {
                      return const SliverFillRemaining(
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    if (state.isFailure) {
                      return SliverFillRemaining(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                                  text:
                                      state.errorMessage ?? 'Terjadi kesalahan',
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

                    if (state.isReady || state.hasOrders) {
                      final orders = state.orders;

                      if (orders.isEmpty) {
                        return SliverFillRemaining(
                          hasScrollBody: false,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.inbox_outlined,
                                  size: 48,
                                  color: Colors.grey.shade400,
                                ),
                                const CustomSpacing(height: 12),
                                CustomText(
                                  text: 'Tidak ada pesanan',
                                  style: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      return SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        sliver: SliverList.builder(
                          itemCount:
                              orders.length + (state.hasReachedMax ? 0 : 1),
                          itemBuilder: (context, index) {
                            if (index >= orders.length) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }
                            final order = orders[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: CashierOrderCard(
                                order: order,
                                onTap: () async {
                                  await context.pushNamed(
                                    AppNameRoute.orderDetailCashier,
                                    pathParameters: {'id': order.id!},
                                  );
                                  if (!mounted) return;
                                  _refreshWithFilter();
                                },

                                onCancel: () {
                                  _showConfirmSheet(
                                    title: 'Batalkan Pesanan',
                                    message:
                                        'Apakah anda yakin ingin membatalkan pesanan ini?',
                                    confirmText: 'Batalkan',
                                    onConfirm: () {
                                      context.read<OrderBloc>().add(
                                        CancelOrder(orderId: order.id!),
                                      );
                                      return true;
                                    },
                                  );
                                },

                                onConfirmPayment: () {
                                  _showConfirmSheet(
                                    title: 'Konfirmasi Pembayaran',
                                    message:
                                        'Apakah anda yakin telah menerima uang tunai dari CS? '
                                        'Pembayaran pesanan ini akan ditandai LUNAS.',
                                    confirmText: 'Konfirmasi',
                                    onConfirm: () {
                                      context.read<OrderBloc>().add(
                                        ConfirmPayment(
                                          orderId: order.id!,
                                          notes: 'Uang tunai diterima kasir',
                                        ),
                                      );
                                      return true;
                                    },
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      );
                    }

                    return const SliverFillRemaining(child: CustomSpacing());
                  },
                ),

                const SliverToBoxAdapter(child: CustomSpacing(height: 24)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
