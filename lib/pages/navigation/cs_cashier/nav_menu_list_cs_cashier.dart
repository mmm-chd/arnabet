import 'package:arena/config/design/custom_icons.dart';
import 'package:arena/components/custom_spacing.dart';
import 'package:arena/components/custom_text.dart';
import 'package:arena/config/routes/app_name_route.dart';
import 'package:arena/config/routes/app_routes.dart';
import 'package:arena/config/theme/app_colors.dart';
import 'package:arena/models/brand/brand_list_model.dart';
import 'package:arena/pages/navigation/components/nav_expansion_menu_item.dart';
import 'package:arena/pages/navigation/components/nav_menu_item.dart';
import 'package:arena/pages/navigation/components/nav_menu_sub_item.dart';
import 'package:arena/repositories/brand/brand_repository.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:arena/models/enums/role.dart';

class NavMenuListCsCashier extends StatefulWidget {
  final String currentPath;
  final Role role;

  const NavMenuListCsCashier({
    super.key,
    required this.currentPath,
    required this.role,
  });

  @override
  State<NavMenuListCsCashier> createState() => _NavMenuListCsCashierState();
}

class _NavMenuListCsCashierState extends State<NavMenuListCsCashier> {
  List<BrandListDatum> _brands = [];
  bool _loadingBrands = true;
  bool get isCs => widget.role == Role.customerServices;

  @override
  void initState() {
    super.initState();
    _loadBrands();
  }

  Future<void> _loadBrands() async {
    try {
      final repo = BrandRepository();
      final model = await repo.getBrands();
      if (mounted) {
        setState(() {
          _brands = model.data ?? [];
          _loadingBrands = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _loadingBrands = false;
        });
      }
    }
  }

  void _onTap(BuildContext context, String route) {
    final router = GoRouter.of(context);
    Future.delayed(const Duration(milliseconds: 300), () {
      router.go(route);
    });
    Navigator.of(context).pop();
  }

  void _onTapBrand(BuildContext context, String brandName) {
    final router = GoRouter.of(context);
    final routeName = isCs
        ? AppNameRoute.stockListByBrandCs
        : AppNameRoute.stockListByBrandCashier;
    Future.delayed(const Duration(milliseconds: 300), () {
      router.goNamed(routeName, pathParameters: {'brandName': brandName});
    });
    Navigator.of(context).pop();
  }

  bool _isBrandSelected(String brandName) {
    return widget.currentPath ==
        (isCs
            ? AppRoutes.stockListByBrandCsPath(brandName)
            : AppRoutes.stockListByBrandCashierPath(brandName));
  }

  @override
  Widget build(BuildContext context) {
    final String routeDashboard = isCs
        ? AppRoutes.orderListCs
        : AppRoutes.orderListCashier;
    final String routeStockList = isCs
        ? AppRoutes.stockListCs
        : AppRoutes.stockListCashier;
    final bool isBanExpanded =
        widget.currentPath == routeStockList ||
        widget.currentPath.startsWith(
          isCs
              ? AppRoutes.stockListByBrandCs.split(':')[0]
              : AppRoutes.stockListByBrandCashier.split(':')[0],
        );

    final List<Widget> banChildren = [
      NavMenuSubItem(
        title: "Semua",
        selected: widget.currentPath == routeStockList,
        onTap: () => _onTap(context, routeStockList),
      ),
      if (_loadingBrands)
        const NavMenuSubItem(title: "Memuat...", selected: false, onTap: null)
      else
        ..._brands.map(
          (b) => NavMenuSubItem(
            title: b.name ?? '-',
            selected: _isBrandSelected(b.name ?? ''),
            onTap: () => _onTapBrand(context, b.name ?? ''),
          ),
        ),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: "Menu",
            style: TextStyle(color: SupportAppColors.greyColor, fontSize: 12),
          ),
          const CustomSpacing(height: 8),
          NavMenuItem(
            svgIcon: CustomIcons.orderList,
            title: "Pesanan",
            selected: widget.currentPath == routeDashboard,
            onTap: () => _onTap(context, routeDashboard),
          ),
          const CustomSpacing(height: 8),
          CustomText(
            text: "List Stok",
            style: TextStyle(color: SupportAppColors.greyColor, fontSize: 12),
          ),
          const CustomSpacing(height: 8),
          NavExpansionMenuItem(
            title: "Ban",
            svgPath: CustomIcons.tire,
            initiallyExpanded: isBanExpanded,
            children: banChildren,
          ),
        ],
      ),
    );
  }
}
