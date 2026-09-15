import 'package:arena/components/current_user_avatar.dart';
import 'package:arena/components/icon_button/custom_icon_button_circle.dart';
import 'package:arena/components/custom_spacing.dart';
import 'package:arena/components/custom_text.dart';
import 'package:arena/components/header/header_search.dart';
import 'package:arena/config/design/custom_icons.dart';
import 'package:arena/config/routes/app_routes.dart';
import 'package:arena/config/theme/app_colors.dart';
import 'package:arena/models/enums/role.dart';
import 'package:arena/pages/auth/login/bloc/login_bloc.dart';
import 'package:arena/pages/customer/components/customer_item_card.dart';
import 'package:arena/utils/app_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'bloc/customer_bloc.dart';
import 'bloc/customer_event.dart';
import 'bloc/customer_state.dart';
import 'package:arena/utils/nav_drawer.dart';

class CustomerListPage extends StatefulWidget {
  const CustomerListPage({super.key});

  @override
  State<CustomerListPage> createState() => _CustomerListPageState();
}

class _CustomerListPageState extends State<CustomerListPage> {
  late final ScrollController _scrollController;
  Role? _userRole;
  bool _hasLoaded = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    _loadRole();
    context.read<CustomerBloc>().add(const LoadCustomer());
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<CustomerBloc>().add(const LoadMoreCustomer());
    }
  }

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
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_hasLoaded) {
      context.read<CustomerBloc>().add(LoadCustomer());
    }
    _hasLoaded = true;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: RefreshIndicator(
          onRefresh: () async {
            context.read<CustomerBloc>().add(LoadCustomer());
            await context.read<CustomerBloc>().stream.firstWhere(
              (state) => state.status == CustomerStatus.ready,
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
                  text: "List Pelanggan",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
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
                              backgroundColor: SupportAppColors.white,
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
                    onChanged: (value) {
                      context.read<CustomerBloc>().add(SearchCustomer(value));
                    },
                    onTapSearch: () {},
                  ),
                ),
              ),

              BlocListener<CustomerBloc, CustomerState>(
                listener: (context, state) {
                  if (state.status == CustomerStatus.ready) {
                    if (_scrollController.hasClients) {
                      _scrollController.animateTo(
                        0,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                      );
                    }
                  }
                },
                child: BlocBuilder<CustomerBloc, CustomerState>(
                  builder: (context, state) {
                    if (state.isReady) {
                      if (state.customers.isEmpty) {
                        return const SliverFillRemaining(
                          hasScrollBody: false,
                          child: Center(
                            child: CustomText(text: "Tidak ada customer"),
                          ),
                        );
                      }

                      return SliverPadding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                        sliver: SliverList.builder(
                          itemCount:
                              state.customers.length +
                              (state.hasReachedMax ? 0 : 1),
                          itemBuilder: (context, index) {
                            if (index >= state.customers.length) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }

                            final item = state.customers[index];
                            final firstItem = index == 0;
                            final lastItem =
                                index == state.customers.length - 1;

                            return Padding(
                              key: ValueKey(item.id ?? index),
                              padding: const EdgeInsets.only(top: 2),
                              child: CustomerItemCard(
                                item: item,
                                firstItem: firstItem,
                                lastItem: lastItem,
                                onTap: null,
                              ),
                            );
                          },
                        ),
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
                                  color: AppColors.error,
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
                                    color: SupportAppColors.greyColor,
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
    );
  }
}
