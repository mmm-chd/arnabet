import 'package:arena/components/bottom_sheet/custom_bottom_sheet_fix.dart';
import 'package:arena/config/design/custom_icons.dart';
import 'package:arena/config/theme/app_colors.dart';
import 'package:arena/components/custom_spacing.dart';
import 'package:arena/components/custom_text.dart';
import 'package:arena/models/enums/role.dart';
import 'package:arena/pages/notification/bloc/notification_bloc.dart';
import 'package:arena/pages/notification/bloc/notification_event.dart';
import 'package:arena/pages/profile/bloc/profile_bloc.dart';
import 'package:arena/pages/profile/bloc/profile_event.dart';
import 'package:arena/pages/profile/bloc/profile_state.dart';
import 'package:arena/config/routes/app_routes.dart';
import 'package:arena/services/auth/user_session.dart';
import 'package:arena/utils/app_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'components/profile_header.dart';
import 'components/profile_section.dart';
import 'components/profile_item.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Role? _userRole;

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
  void initState() {
    super.initState();
    _loadRole();
    context.read<ProfileBloc>().add(LoadProfile());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: SafeArea(
        child: BlocConsumer<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state is ProfileLogoutSuccess) {
              UserSession.clear();
              context.go(AppRoutes.login);
            } else if (state is ProfileError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: CustomText(text: state.message)),
              );
            }
          },
          builder: (context, state) {
            if (state is ProfileLoading || state is ProfileInitial) {
              return const Center(child: CircularProgressIndicator());
            }

            String email = "";
            String name = "";
            String role = "";
            String? imageUrl;

            if (state is ProfileLoaded) {
              email = state.email;
              name = state.name;
              role = state.role;
              imageUrl = state.imageUrl;
            }

            return SingleChildScrollView(
              child: Column(
                children: [
                  ProfileHeader(
                    email: email,
                    name: name,
                    role: role,
                    imageUrl: imageUrl,
                  ),

                  const CustomSpacing(height: 16),

                  ProfileSection(
                    title: "Akun Anda",
                    children: [
                      ProfileItem(
                        icon: CustomIcons.profilePerson,
                        title: "Edit Profile",
                        onTap: () {
                          if (name.isEmpty) return;
                          context.push(AppRoutes.editProfile, extra: name);
                        },
                      ),
                      ProfileItem(
                        icon: CustomIcons.profileLock,
                        title: "Ganti Password",
                        onTap: () {
                          if (email.isEmpty) return;
                          context.push(AppRoutes.changePassword, extra: email);
                        },
                        radiusBottom: 16,
                      ),
                    ],
                  ),
                  if (_userRole == Role.warehouseStaff ||
                      _userRole == Role.owner)
                    ProfileSection(
                      title: "Preferensi",
                      children: [
                        (_userRole == Role.owner)
                            ? ProfileItem(
                                icon: CustomIcons.profileBell,
                                title: "Notifikasi",
                                onTap: () => context.push(
                                  AppRoutes.notificationSettings,
                                ),
                                radiusBottom:
                                    _userRole == Role.warehouseStaff ||
                                        _userRole == Role.owner
                                    ? 0
                                    : 16,
                              )
                            : const SizedBox.shrink(),

                        (_userRole == Role.warehouseStaff ||
                                _userRole == Role.owner)
                            ? ProfileItem(
                                icon: CustomIcons.profileWarehouse,
                                title: "Stok & Inventory",
                                radiusBottom: 16,
                                onTap: () => context.push(
                                  AppRoutes.stockInventorySettings,
                                ),
                              )
                            : const SizedBox.shrink(),
                      ],
                    ),

                  ProfileSection(
                    title: "Lainnya",
                    children: [
                      ProfileItem(
                        icon: CustomIcons.profileLogout,
                        title: "Logout",
                        isLogout: true,
                        radiusBottom: 16,
                        onTap: () {
                          CustomBottomsheetfix.show(
                            context,
                            hideHeader: true,
                            initialChildSize: 0.35,
                            onDismissed: () {},
                            onPressed: () async {
                              context.read<NotificationBloc>().add(
                                DisconnectUnreadCount(),
                              );
                              context.read<ProfileBloc>().add(
                                LogoutProfileEvent(),
                              );

                              context.go(AppRoutes.splash);
                              return true;
                            },
                            onReset: () => context.pop(),
                            primaryButtonText: 'Ya, Keluar',
                            secondaryButtonText: 'Tidak',
                            pBackgroundColor: SupportAppColors.normalRed,
                            sBorderColor: SupportAppColors.greyMidColor,
                            sForegroundColor: SupportAppColors.greyColor,
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const CustomText(
                                    text: "Ingin keluar dari akun Anda?",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const CustomSpacing(height: 12),
                                  CustomText(
                                    text:
                                        "Setelah keluar, Anda perlu masuk kembali untuk mengakses akun ini.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: SupportAppColors.greyColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),

                  const CustomSpacing(height: 20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
