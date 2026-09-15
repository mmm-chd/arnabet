import 'package:arena/components/current_user_avatar.dart';
import 'package:arena/components/icon_button/custom_icon_button_circle.dart';
import 'package:arena/components/custom_spacing.dart';
import 'package:arena/components/custom_text.dart';
import 'package:arena/components/header/header_search.dart';
import 'package:arena/config/routes/app_name_route.dart';
import 'package:arena/config/routes/app_routes.dart';
import 'package:arena/config/theme/app_colors.dart';
import 'package:arena/pages/user_list/bloc/user_bloc.dart';
import 'package:arena/pages/user_list/bloc/user_event.dart';
import 'package:arena/pages/user_list/bloc/user_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'components/user_card.dart';
import 'package:arena/utils/nav_drawer.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  late final TextEditingController _searchController;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<UserBloc>().add(const LoadMoreUsers());
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SafeArea(
          top: false,
          child: Stack(
            children: [
              RefreshIndicator(
                onRefresh: () async {
                  context.read<UserBloc>().add(LoadUserList());
                  await context.read<UserBloc>().stream.firstWhere(
                    (state) => state.isReady || state.isFailure,
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
                        text: "Semua Pengguna",
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
                      bottom: PreferredSize(
                        preferredSize: const Size.fromHeight(63),
                        child: HeaderSearch(
                          onTapFilter: () {
                            context.read<UserBloc>().add(FilterUser(""));
                          },
                          onChanged: (value) {
                            context.read<UserBloc>().add(SearchUser(value));
                          },
                          onTapSearch: () {},
                        ),
                      ),
                    ),
                    BlocBuilder<UserBloc, UserState>(
                      builder: (context, state) {
                        if (state.isLoading ||
                            state.status == UserStatus.initial) {
                          return const SliverFillRemaining(
                            child: Center(child: CircularProgressIndicator()),
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
                                      text:
                                          state.errorMessage ??
                                          "Terjadi kesalahan",
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
                            child: Center(
                              child: CustomText(text: "Tidak ada pengguna"),
                            ),
                          );
                        }

                        final users = state.filteredUsers;
                        return SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          sliver: SliverList.builder(
                            itemCount:
                                users.length + (state.hasReachedMax ? 0 : 1),
                            itemBuilder: (context, index) {
                              if (index >= users.length) {
                                return const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }
                              final u = users[index];
                              return UserCard(
                                name: u.displayName,
                                email: u.displayEmail,
                                role: u.displayRole,
                                image: "",
                                onTap: () {
                                  context.pushNamed(
                                    AppNameRoute.userDetail,
                                    extra: u,
                                  );
                                },
                              );
                            },
                          ),
                        );
                      },
                    ),
                    const SliverToBoxAdapter(child: CustomSpacing(height: 88)),
                  ],
                ),
              ),
              Positioned(
                right: 16,
                bottom: 16,
                child: FloatingActionButton(
                  backgroundColor: SupportAppColors.normalRed,
                  onPressed: () {
                    context.push(AppRoutes.addUser);
                  },
                  child: const Icon(Icons.add),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
