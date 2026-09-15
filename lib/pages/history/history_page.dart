import 'dart:async';

import 'package:arena/components/cards/expandable_history_card.dart';
import 'package:arena/components/current_user_avatar.dart';
import 'package:arena/components/icon_button/custom_icon_button_circle.dart';
import 'package:arena/components/header/header_search.dart';
import 'package:arena/config/routes/app_routes.dart';
import 'package:arena/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../components/custom_spacing.dart';
import '../../components/custom_text.dart';

import 'bloc/history_bloc.dart';
import 'bloc/history_event.dart';
import 'bloc/history_state.dart';

import 'components/history_filter.dart';
import 'package:arena/utils/nav_drawer.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late final ScrollController _scrollController;
  Timer? _searchDebounce;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 400), () {
      if (!mounted) return;
      context.read<HistoryBloc>().add(SearchHistory(value));
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<HistoryBloc>().add(const LoadMoreHistory());
    }
  }

  @override
  Widget build(BuildContext context) {
    final filters = [
      "Semua",
      "Stock In",
      "Stock Out",
      "Penyesuaian Masuk",
      "Penyesuaian Keluar",
    ];

    return SafeArea(
      top: false,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: RefreshIndicator(
          onRefresh: () async {
            context.read<HistoryBloc>().add(const LoadHistory());
            await context.read<HistoryBloc>().stream.firstWhere(
              (state) => !state.isLoading,
            );
          },
          child: CustomScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverAppBar(
                elevation: 0,
                backgroundColor: AppColors.bgColor,
                surfaceTintColor: AppColors.bgColor,
                floating: true,
                snap: true,
                pinned: true,
                automaticallyImplyLeading: false,
                expandedHeight: 130,
                leadingWidth: 72,
                leading: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: CustomIconbuttonCircle(
                    prefixIcon: Icons.menu,
                    backgroundColor: Colors.white,
                    iconColor: Colors.black,
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
                  text: "Riwayat",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                ),
                actionsPadding: EdgeInsets.only(right: 16),
                actions: [
                  InkWell(
                    borderRadius: BorderRadius.circular(50),
                    onTap: () => context.push(AppRoutes.profile),
                    child: const CurrentUserAvatar(),
                  ),
                ],
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(63),
                  child: HeaderSearch(
                    onTapFilter: () {
                      context.read<HistoryBloc>().add(FilterHistory(""));
                    },
                    onChanged: _onSearchChanged,
                    onTapSearch: () {},
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 40,
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        scrollDirection: Axis.horizontal,
                        itemCount: filters.length,
                        itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: HistoryFilter(text: filters[index]),
                        ),
                      ),
                    ),
                    const CustomSpacing(height: 12),
                  ],
                ),
              ),
              BlocBuilder<HistoryBloc, HistoryState>(
                builder: (context, state) {
                  if (state.isLoading ||
                      state.status == HistoryStatus.initial) {
                    return const SliverFillRemaining(
                      hasScrollBody: false,
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
                                text: state.errorMessage ?? "Terjadi kesalahan",
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

                  if (state.isEmpty) {
                    return const SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: CustomText(text: "Tidak ada riwayat"),
                      ),
                    );
                  }

                  return SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverList.builder(
                      itemCount:
                          state.filteredHistories.length +
                          (state.hasReachedMax ? 0 : 1),
                      itemBuilder: (context, index) {
                        if (index >= state.filteredHistories.length) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        final item = state.filteredHistories[index];
                        final lastItem =
                            index == state.filteredHistories.length - 1;
                        return ExpandableHistoryCard(
                          item: item,
                          firstItem: index == 0,
                          lastItem: lastItem,
                          size: item.displaySize,
                          ring: item.displayRing,
                        );
                      },
                    ),
                  );
                },
              ),
              const SliverToBoxAdapter(child: CustomSpacing(height: 24)),
            ],
          ),
        ),
      ),
    );
  }
}
