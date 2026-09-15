import 'dart:async';
import 'package:arena/components/custom_button.dart';
import 'package:arena/components/custom_spacing.dart';
import 'package:arena/components/custom_text.dart';
import 'package:arena/components/dialog/custom_dialog.dart';
import 'package:arena/config/design/custom_icons.dart';
import 'package:arena/config/routes/app_routes.dart';
import 'package:arena/config/routes/nav_routes.dart';
import 'package:arena/config/theme/app_colors.dart';
import 'package:arena/models/notification/notification_banner_model.dart';
import 'package:arena/pages/navigation/cs_cashier/nav_menu_list_cs_cashier.dart';
import 'package:arena/pages/navigation/owner/nav_menu_list_owner.dart';
import 'package:arena/pages/navigation/warehouse_staff/nav_menu_list_warehouse_staff.dart';
import 'package:arena/pages/notification/bloc/notification_bloc.dart';
import 'package:arena/pages/notification/bloc/notification_state.dart';
import 'package:arena/utils/notification_banner_controller.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:arena/models/enums/role.dart';

class NavPage extends StatefulWidget {
  final Widget child;
  final Role role;
  const NavPage({super.key, required this.child, required this.role});

  @override
  State<NavPage> createState() => _NavPageState();
}

class _NavPageState extends State<NavPage> {
  static const _svgAssets = [
    CustomIcons.logoLight,
    CustomIcons.logoDark,
    CustomIcons.tire,
  ];

  bool _svgsCached = false;
  late final StreamSubscription<List<ConnectivityResult>>
  _connectivitySubscription;
  bool _isDisconnected = false;
  DateTime? _lastBackPressed;

  @override
  void initState() {
    super.initState();
    _checkInitialConnectivity();
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) {
      _updateConnectionStatus(results);
    });
  }

  Future<void> _checkInitialConnectivity() async {
    try {
      final results = await Connectivity().checkConnectivity();
      _updateConnectionStatus(results);
    } catch (_) {
    }
  }

  void _updateConnectionStatus(List<ConnectivityResult> results) {
    final bool disconnected =
        results.isEmpty || results.contains(ConnectivityResult.none);
    if (_isDisconnected != disconnected) {
      setState(() {
        _isDisconnected = disconnected;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_svgsCached) {
      _precacheSvgs();
      _svgsCached = true;
    }
  }

  Future<void> _precacheSvgs() async {
    for (final assetPath in _svgAssets) {
      try {
        final loader = SvgAssetLoader(assetPath);
        final cacheKey = loader.cacheKey(null);
        svg.cache.putIfAbsent(cacheKey, () => loader.loadBytes(null));
      } catch (_) {
      }
    }
  }

  Widget _buildNoConnectionBanner() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
      height: _isDisconnected ? 40 : 0,
      width: double.infinity,
      color: SupportAppColors.normalOrange,
      clipBehavior: Clip.hardEdge,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 250),
        opacity: _isDisconnected ? 1.0 : 0.0,
        curve: Curves.easeIn,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.wifi_off_rounded,
                color: SupportAppColors.white,
                size: 16,
              ),
              CustomSpacing(width: 8),
              Expanded(
                child: CustomText(
                  text: "Tidak Ada Koneksi Internet",
                  style: TextStyle(
                    color: SupportAppColors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              CustomSpacing(width: 8),
              GestureDetector(
                onTap: () {
                  CustomDialog.info(
                    context,
                    title: "Informasi Mode Offline",
                    message:
                        "Aplikasi sedang tidak terhubung ke internet. Beberapa fitur mungkin tidak dapat diakses, namun perubahan data akan disimpan sementara di perangkat dan akan disinkronisasikan ketika koneksi kembali.",
                  );
                },
                child: const Icon(
                  Icons.info_outline,
                  color: SupportAppColors.white,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final String currentPath = GoRouterState.of(context).uri.path;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        if (currentPath != NavRoutes.getHomeRoute(widget.role)) {
          context.go(NavRoutes.getHomeRoute(widget.role));
          return;
        }

        final now = DateTime.now();
        final isDoubleBack =
            _lastBackPressed != null &&
            now.difference(_lastBackPressed!) < const Duration(seconds: 2);

        if (isDoubleBack) {
          SystemNavigator.pop();
          return;
        }

        _lastBackPressed = now;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: CustomText(
              text: "Tekan sekali lagi untuk keluar",
              style: TextStyle(color: SupportAppColors.white),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            backgroundColor: SupportAppColors.greyColor,
            duration: Duration(seconds: 2),
          ),
        );
      },
      child: Scaffold(
        backgroundColor: AppColors.bgColor,
        drawer: SafeArea(
          child: Drawer(
            backgroundColor: SupportAppColors.white,
            child: RepaintBoundary(
              child: Column(
                children: [
                  _buildDrawerHeader(context, isDark),
                  Divider(height: 1, color: SupportAppColors.greyMidColor),
                  Expanded(
                    child: _buildDrawerList(context, currentPath, widget.role),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: BlocConsumer<NotificationBloc, NotificationState>(
          listenWhen: (previous, current) =>
              current.unreadCount > previous.unreadCount ||
              current.latestNotification != previous.latestNotification,
          listener: (context, state) {
            final latest = state.latestNotification;
            if (latest == null) return;

            NotificationBannerController.instance.show(
              NotificationBannerModel(
                title: latest.title,
                message: latest.body,
                icon: Icons.notifications_rounded,
                timestampLabel: 'Baru saja',
                onTap: () => context.push(NavRoutes.getInboxRoute(widget.role)),
              ),
            );
          },
          builder: (context, state) {
            return Column(
              children: [
                _buildNoConnectionBanner(),
                const CustomSpacing(height: 8),
                Expanded(child: widget.child),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 24, 24, 12),
      child: Row(
        children: [
          RepaintBoundary(
            child: SvgPicture.asset(
              isDark ? CustomIcons.logoDark : CustomIcons.logoLight,
              width: 24,
              height: 24,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.image, size: 40),
            ),
          ),
          const CustomSpacing(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: "ARENA BAN",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: SupportAppColors.greyDarkerColor,
                ),
              ),
              const CustomSpacing(height: 2),
              CustomText(
                text: "Sistem Manajemen",
                style: TextStyle(
                  fontSize: 12,
                  color: SupportAppColors.greyColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }
}

Widget _buildDrawerList(BuildContext context, String currentPath, Role role) {
  switch (role) {
    case Role.owner:
    case Role.developer:
      return NavMenuListOwner(currentPath: currentPath);
    case Role.warehouseStaff:
      return NavMenuListWarehouse(currentPath: currentPath);
    case Role.cashier:
    case Role.customerServices:
      return NavMenuListCsCashier(currentPath: currentPath, role: role);
    default:
      return Center(
        child: Column(
          children: [
            const CustomText(text: "Role tidak ditemukan"),
            const CustomSpacing(height: 8),
            CustomButton(
              text: "Kembali ke login",
              onPressed: () => context.go(AppRoutes.login),
            ),
          ],
        ),
      );
  }
}
