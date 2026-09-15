import 'package:arena/components/bottom_sheet/custom_bottom_sheet_v2.dart';
import 'package:arena/components/custom_button.dart';
import 'package:arena/components/icon_button/custom_icon_button_circle.dart';
import 'package:arena/components/custom_spacing.dart';
import 'package:arena/components/custom_text.dart';
import 'package:arena/components/state/error_state_widget.dart';
import 'package:arena/components/text_field/custom_text_field.dart';
import 'package:arena/helper/currency_input_formatter.dart';
import 'package:arena/helper/currency_local_formatter.dart';
import 'package:arena/helper/string_extension_helper.dart';
import 'package:arena/config/design/app_snack_bar.dart';
import 'package:arena/config/design/custom_icons.dart';
import 'package:arena/config/routes/app_routes.dart';
import 'package:arena/config/theme/app_colors.dart';
import 'package:arena/config/routes/nav_routes.dart';
import 'package:arena/models/cart/cart_list_model.dart';
import 'package:arena/models/enums/role.dart';
import 'package:arena/pages/cart/components/cart_card.dart';
import 'package:arena/pages/cart/components/service_cart_card.dart';
import 'package:arena/pages/cart/components/service_sheet.dart';
import 'package:arena/utils/app_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'bloc/cart_bloc.dart';
import 'bloc/cart_event.dart';
import 'bloc/cart_state.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  Role? _userRole;
  final _discountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cartBloc.add(LoadCart());
    _loadRole();
  }

  @override
  void dispose() {
    _discountController.dispose();
    super.dispose();
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

  void _showMoreMenu(BuildContext context) {
    final isCartEmpty =
        !(_cartBloc.state.cartListData?.items?.isNotEmpty ?? false);

    CustomBottomSheetV2.show(
      context,
      title: 'Opsi Keranjang',
      hideHeader: true,
      initialChildSize: 0.15,
      onDismissed: () {},
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          enabled: !isCartEmpty,
          leading: SvgPicture.asset(CustomIcons.x, color: AppColors.error),
          title: const CustomText(
            text: 'Hapus Semua',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.error,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          subtitle: const CustomText(
            text: 'Kosongkan seluruh isi keranjang',
            style: TextStyle(fontSize: 12, color: SupportAppColors.greyColor),
          ),
          onTap: () {
            context.pop();
            _cartBloc.add(ClearCart());
          },
        ),
      ],
    );
  }

  Widget _buildAddOnTile(BuildContext context) {
    return InkWell(
      onTap: () => ServiceSheet.show(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: SupportAppColors.lightOrange,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(8),
              child: SvgPicture.asset(CustomIcons.add),
            ),
            const CustomSpacing(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: 'Tambahan',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: SupportAppColors.greyDarkerColor,
                    ),
                  ),
                  CustomSpacing(height: 2),
                  CustomText(
                    text: 'Biaya jasa pasang',
                    style: TextStyle(
                      fontSize: 12,
                      color: SupportAppColors.greyColor,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: SupportAppColors.greyColor,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }

  void _showDiscountSheet(BuildContext context) {
    final currentDiscount = _cartBloc.state.cartListData?.discount ?? 0;
    _discountController.text = currentDiscount > 0
        ? currentDiscount.toLocaleCurrency(showSymbol: false, symbol: null)
        : '';

    CustomBottomSheetV2.show(
      context,
      title: 'Tambah Diskon',
      initialChildSize: 0.7,
      onDismissed: () {},
      onSave: () {
        final amount = _discountController.text.fromCurrencyToInt();
        _cartBloc.add(ApplyDiscount(discountAmount: amount));
        return true;
      },
      children: [
        const CustomText(
          text: 'Nominal Diskon',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: SupportAppColors.greyDarkerColor,
          ),
        ),
        const CustomSpacing(height: 8),
        CustomTextField(
          controller: _discountController,
          label: 'Masukkan nominal diskon',
          hint: '000.000',
          prefixText: 'Rp ',
          isNumber: true,
          filled: true,
          autofocus: true,
          inputFormatters: [CurrencyInputFormatter()],
        ),
      ],
    );
  }

  Widget _buildDiscountTile(BuildContext context) {
    final discount = context.select<CartBloc, int>(
      (bloc) => bloc.state.cartListData?.discount ?? 0,
    );
    final hasDiscount = discount > 0;

    final title = hasDiscount ? discount.toLocaleCurrency() : 'Discount';
    final subtitle = hasDiscount ? 'Diskon diterapkan' : 'Potongan harga';

    return InkWell(
      onTap: () => _showDiscountSheet(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: SupportAppColors.lightOrange,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(8),
              child: SvgPicture.asset(CustomIcons.discount),
            ),
            const CustomSpacing(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: hasDiscount
                          ? AppColors.primary
                          : SupportAppColors.greyDarkerColor,
                    ),
                  ),
                  const CustomSpacing(height: 2),
                  CustomText(
                    text: subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: SupportAppColors.greyColor,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: SupportAppColors.greyColor,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }

  CartBloc get _cartBloc => context.read<CartBloc>();

  void _handleQuantityChange(String itemId, int currentQuantity, int delta) {
    if (itemId.isEmpty) return;
    final newQuantity = currentQuantity + delta;
    if (newQuantity < 1) {
      _cartBloc.add(DeleteCartItem(itemId: itemId));
      return;
    }

    if (delta > 0) {
      final item = _cartBloc.state.cartListData?.items?.firstWhere(
        (i) => i.id == itemId,
        orElse: () => Item(),
      );
      final availableQty = item?.availableQty;
      if (availableQty != null &&
          availableQty > 0 &&
          newQuantity > availableQty) {
        AppSnackBar.warning(
          context: context,
          message:
              'Jumlah tidak boleh melebihi stok yang tersedia ($availableQty)',
        );
        return;
      }
    }

    _cartBloc.add(ChangeQuantity(itemId: itemId, quantity: newQuantity));
  }

  Future<void> _handleRefresh() async {
    final bloc = _cartBloc;
    bloc.add(LoadCart());
    await bloc.stream.firstWhere((s) => s.isReady || s.isFailure);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.bgColor,
        surfaceTintColor: AppColors.bgColor,
        automaticallyImplyLeading: false,
        leadingWidth: 72,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: CustomIconbuttonCircle(
            prefixIcon: Icons.arrow_back,
            backgroundColor: SupportAppColors.white,
            iconColor: SupportAppColors.greyDarkerColor,
            iconSize: 24,
            width: 40,
            height: 40,
            onPressed: () => context.pop(),
          ),
        ),
        titleSpacing: 16,
        title: const CustomText(
          text: 'Keranjang',
          style: TextStyle(
            color: SupportAppColors.greyDarkerColor,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        actionsPadding: const EdgeInsets.only(right: 16),
        actions: [
          CustomIconbuttonCircle(
            prefixIcon: Icons.more_vert,
            backgroundColor: SupportAppColors.white,
            iconColor: SupportAppColors.greyDarkerColor,
            iconSize: 28,
            width: 60,
            height: 60,
            onPressed: () => _showMoreMenu(context),
          ),
        ],
      ),
      body: BlocConsumer<CartBloc, CartState>(
        listenWhen: (previous, current) =>
            current.status == CartListStatus.ready &&
            current.message.isNotEmpty &&
            previous.message != current.message,
        listener: (context, state) {
          if (state.status == CartListStatus.failure) {
            AppSnackBar.error(context: context, message: state.message);
          } else {
            AppSnackBar.info(context: context, message: state.message);
          }
        },
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.isReady || state.isSuccess) {
            final cart = state.cartListData;
            final cartItems = cart?.items ?? const [];
            final isCartEmpty = cartItems.isEmpty;
            final productItems = cartItems
                .where((item) => item.itemType != 'SERVICE')
                .toList();
            final serviceItems = cartItems
                .where((item) => item.itemType == 'SERVICE')
                .toList();

            return RefreshIndicator(
              onRefresh: _handleRefresh,
              child: Column(
                children: [
                  Expanded(
                    child: isCartEmpty
                        ? RefreshIndicator(
                            onRefresh: _handleRefresh,
                            child: LayoutBuilder(
                              builder: (context, constraints) => SingleChildScrollView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    minHeight: constraints.maxHeight,
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 24,
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const CustomText(
                                            text: 'Belum Ada Barang',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.grey,
                                            ),
                                          ),

                                          const CustomSpacing(height: 6),

                                          const CustomText(
                                            text:
                                                'Tambahkan barang ke keranjang',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey,
                                            ),
                                          ),

                                          const CustomSpacing(height: 28),

                                          SizedBox(
                                            width: 200,
                                            child: CustomButton(
                                              text: "Cari Barang",
                                              backgroundColor:
                                                  AppColors.bgColor,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                side: BorderSide(
                                                  color: AppColors.primary,
                                                  width: 1.5,
                                                ),
                                              ),
                                              foregroundColor:
                                                  AppColors.primary,
                                              onPressed: () {
                                                if (_userRole != null) {
                                                  context.go(
                                                    NavRoutes.getStockListRoute(
                                                      _userRole!,
                                                    ),
                                                  );
                                                } else {
                                                  context.go(AppRoutes.login);
                                                }
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: _handleRefresh,
                            child: ListView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              padding: EdgeInsets.zero,
                              children: [
                                if (productItems.isNotEmpty) ...[
                                  const Padding(
                                    padding: EdgeInsets.fromLTRB(20, 12, 20, 4),
                                    child: CustomText(
                                      text: 'Product',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: SupportAppColors.greyDarkerColor,
                                      ),
                                    ),
                                  ),
                                  ...productItems.map((item) {
                                    final itemId = item.id ?? '';
                                    final quantity = item.quantity ?? 0;
                                    return CartCard(
                                      item: item,
                                      isSyncing: state.isSyncing(itemId),
                                      onAdd: () => _handleQuantityChange(
                                        itemId,
                                        quantity,
                                        1,
                                      ),
                                      onMin: () => _handleQuantityChange(
                                        itemId,
                                        quantity,
                                        -1,
                                      ),
                                    );
                                  }),
                                ],
                                if (serviceItems.isNotEmpty) ...[
                                  const Padding(
                                    padding: EdgeInsets.fromLTRB(20, 16, 20, 4),
                                    child: CustomText(
                                      text: 'Service',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: SupportAppColors.greyDarkerColor,
                                      ),
                                    ),
                                  ),
                                  ...serviceItems.map((item) {
                                    final itemId = item.id ?? '';
                                    return ServiceCartCard(
                                      item: item,
                                      isSyncing: state.isSyncing(itemId),
                                      onDelete: () => _cartBloc.add(
                                        DeleteCartItem(itemId: itemId),
                                      ),
                                    );
                                  }),
                                ],
                                const CustomSpacing(height: 20),
                              ],
                            ),
                          ),
                  ),
                  Container(
                    color: SupportAppColors.white,
                    child: Column(
                      children: [
                        _buildAddOnTile(context),
                        _buildDiscountTile(context),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 20,
                            right: 20,
                            bottom: 20,
                            top: 8,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 2,
                                child: isCartEmpty
                                    ? const CustomText(
                                        text: 'Tambahkan barang ke keranjang',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey,
                                        ),
                                      )
                                    : Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          if (state.hasDiscount) ...[
                                            CustomText(
                                              text: state.displayRawTotalHarga,
                                              style: const TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                                color:
                                                    SupportAppColors.greyColor,
                                                decoration:
                                                    TextDecoration.lineThrough,
                                              ),
                                            ),
                                            const CustomSpacing(height: 2),
                                          ],
                                          CustomText(
                                            text: state.displayTotalHarga,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              color: SupportAppColors
                                                  .greyDarkerColor,
                                            ),
                                          ),
                                        ],
                                      ),
                              ),

                              Expanded(
                                child: CustomButton(
                                  text: "Beli",
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: SupportAppColors.white,
                                  onPressed: isCartEmpty
                                      ? null
                                      : () {
                                          context.push(AppRoutes.checkoutCart);
                                        },
                                ),
                              ),
                            ],
                          ),
                        ),
                        const CustomSpacing(height: 24),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          return ErrorStateWidget(
            message: state.message,
            onRetry: () => _cartBloc.add(LoadCart()),
          );
        },
      ),
    );
  }
}
