import 'package:arena/components/icon_button/custom_icon_button_circle.dart';
import 'package:arena/components/current_user_avatar.dart';
import 'package:arena/config/design/status_color_config.dart';
import 'package:arena/config/routes/app_routes.dart';
import 'package:arena/components/custom_spacing.dart';
import 'package:arena/components/custom_text.dart';
import 'package:arena/components/header/header_search.dart';
import 'package:arena/config/theme/app_colors.dart';
import 'package:arena/pages/inbox/bloc/inbox_bloc.dart';
import 'package:arena/pages/inbox/bloc/inbox_event.dart';
import 'package:arena/pages/inbox/bloc/inbox_state.dart';
import 'package:arena/pages/inbox/components/inbox_card.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:arena/utils/nav_drawer.dart';

class InboxPage extends StatefulWidget {
  const InboxPage({super.key});

  @override
  State<InboxPage> createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> {
  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: CustomScrollView(
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
            expandedHeight: 130,
            leadingWidth: 72,
            leading: _isSearching
                ? null
                : Padding(
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
            title: _isSearching
                ? null
                : const CustomText(
                    text: "Kotak Masuk",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                  ),
            actionsPadding: const EdgeInsets.only(right: 16),
            actions: _isSearching
                ? null
                : [
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
                onFocusChanged: (hasFocus) {
                  setState(() {
                    _isSearching = hasFocus;
                  });
                },
                onTapFilter: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            title: const CustomText(text: "Semua"),
                            onTap: () {
                              context.read<InboxBloc>().add(FilterInbox("all"));
                              context.pop();
                            },
                          ),
                          ListTile(
                            title: const CustomText(text: "Belum Dibaca"),
                            onTap: () {
                              context.read<InboxBloc>().add(
                                FilterInbox("unread"),
                              );
                              context.pop();
                            },
                          ),
                          ListTile(
                            title: const CustomText(text: "Stok"),
                            onTap: () {
                              context.read<InboxBloc>().add(
                                FilterInbox("stock"),
                              );
                              context.pop();
                            },
                          ),
                          ListTile(
                            title: const CustomText(text: "User"),
                            onTap: () {
                              context.read<InboxBloc>().add(
                                FilterInbox("user"),
                              );
                              context.pop();
                            },
                          ),
                          ListTile(
                            title: const CustomText(text: "Laporan"),
                            onTap: () {
                              context.read<InboxBloc>().add(
                                FilterInbox("report"),
                              );
                              context.pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                onChanged: (value) {
                  context.read<InboxBloc>().add(SearchInbox(value));
                },
                onTapSearch: () {},
              ),
            ),
          ),
          BlocBuilder<InboxBloc, InboxState>(
            builder: (context, state) {
              if (state is InboxInitial) {
                return const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (state is InboxLoading) {
                return const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (state is InboxLoaded) {
                if (state.inbox.isEmpty) {
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.inbox_outlined,
                            size: 48,
                            color: SupportAppColors.greyColor,
                          ),
                          CustomSpacing(height: 12),
                          CustomText(
                            text: "Belum ada perubahan",
                            style: TextStyle(
                              color: SupportAppColors.greyColor,
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  sliver: SliverList.builder(
                    itemCount: state.inbox.length,
                    itemBuilder: (context, index) {
                      final item = state.inbox[index];
                      final lastIndex = state.inbox.length - 1;
                      final topItem = index == 0;
                      final belowItem = index == lastIndex;
                      final style = InboxConfig.getStyle(item.subject);
                      return InboxCard(
                        id: item.id,
                        title: item.title,
                        subtitle: item.subtitle,
                        date: item.date,
                        icon: style.customIcon ?? "",
                        iconColor: style.foreground,
                        iconSize: item.displaySizeIcon,
                        bgColor: style.background,
                        isNew: !item.isRead,
                        showButton: item.showDownloadButton,
                        topLeft: topItem ? 16 : 0,
                        topRight: topItem ? 16 : 0,
                        bottomLeft: belowItem ? 16 : 0,
                        bottomRight: belowItem ? 16 : 0,
                      );
                    },
                  ),
                );
              }

              return const SliverToBoxAdapter(child: CustomSpacing());
            },
          ),
          const SliverToBoxAdapter(child: CustomSpacing(height: 24)),
        ],
      ),
    );
  }
}
