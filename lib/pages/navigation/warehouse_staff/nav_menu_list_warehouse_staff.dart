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

class NavMenuListWarehouse extends StatefulWidget {
  final String currentPath;

  const NavMenuListWarehouse({super.key, required this.currentPath});

  @override
  State<NavMenuListWarehouse> createState() => _NavMenuListWarehouseState();
}

class _NavMenuListWarehouseState extends State<NavMenuListWarehouse> {
  List<BrandListDatum> _brands = [];
  bool _loadingBrands = true;

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
    Future.delayed(const Duration(milliseconds: 300), () {
      router.goNamed(
        AppNameRoute.stockListByBrandWarehouse,
        pathParameters: {'brandName': brandName},
      );
    });
    Navigator.of(context).pop();
  }

  bool _isBrandSelected(String brandName) {
    return widget.currentPath ==
        AppRoutes.stockListByBrandWarehousePath(brandName);
  }

  @override
  Widget build(BuildContext context) {
    final bool isBanExpanded =
        widget.currentPath == AppRoutes.stockListWarehouse ||
        widget.currentPath.startsWith('/stock-list/brand/');

    final List<Widget> banChildren = [
      NavMenuSubItem(
        title: "Semua",
        selected: widget.currentPath == AppRoutes.stockListWarehouse,
        onTap: () => _onTap(context, AppRoutes.stockListWarehouse),
      ),
      if (_loadingBrands)
        const NavMenuSubItem(title: "Memuat...", selected: false, onTap: null)
      else
        ..._brands
            .where((b) => b.name != null && b.name!.isNotEmpty)
            .map(
              (b) => NavMenuSubItem(
                title: b.name!,
                selected: _isBrandSelected(b.name!),
                onTap: () => _onTapBrand(context, b.name!),
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
            svgIcon: CustomIcons.dashboard,
            title: "Dashboard",
            selected: widget.currentPath == AppRoutes.dashboardWarehouse,
            onTap: () => _onTap(context, AppRoutes.dashboardWarehouse),
          ),
          NavMenuItem(
            svgIcon: CustomIcons.orderList,
            title: "List Pesanan",
            selected: widget.currentPath == AppRoutes.orderListWarehouse,
            onTap: () => _onTap(context, AppRoutes.orderListWarehouse),
          ),
          NavMenuItem(
            svgIcon: CustomIcons.history,
            title: "Riwayat",
            selected: widget.currentPath == AppRoutes.historyWarehouse,
            onTap: () => _onTap(context, AppRoutes.historyWarehouse),
          ),
          const CustomSpacing(height: 8),

          NavMenuItem(
            svgIcon: CustomIcons.inbox,
            title: "List Brand",
            selected: widget.currentPath == AppRoutes.brandListWarehouse,
            onTap: () => _onTap(context, AppRoutes.brandListWarehouse),
          ),
          const CustomSpacing(height: 8),
          NavMenuItem(
            svgIcon: CustomIcons.produk,
            title: "List Produk",
            selected: widget.currentPath == AppRoutes.productListWarehouse,
            onTap: () => _onTap(context, AppRoutes.productListWarehouse),
          ),
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
