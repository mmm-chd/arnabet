import 'dart:async';

import 'package:arena/components/bottom_sheet/custom_bottom_sheet.dart';
import 'package:arena/components/build/custom_radio_group.dart';
import 'package:arena/components/bottom_sheet/custom_bottom_sheet_fix.dart';
import 'package:arena/components/icon_button/custom_icon_button_circle.dart';
import 'package:arena/components/custom_button.dart';
import 'package:arena/components/custom_spacing.dart';
import 'package:arena/components/custom_text.dart';
import 'package:arena/config/design/app_snack_bar.dart';
import 'package:arena/config/theme/app_colors.dart';
import 'package:arena/models/metadata/dropdown_item_model.dart';
import 'package:arena/models/user/user_list_model.dart';
import 'package:arena/pages/user_list/bloc/user_bloc.dart';
import 'package:arena/pages/user_list/bloc/user_event.dart';
import 'package:arena/repositories/user/user_repository.dart';
import 'package:arena/services/users/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class UserDetailPage extends StatefulWidget {
  final UserListDatum user;
  const UserDetailPage({super.key, required this.user});

  @override
  State<UserDetailPage> createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  final UserService _service = UserService();
  final UserRepository _userRepository = UserRepository();
  bool _loading = false;
  late UserListDatum _currentUser;

  final List<DropdownItemModel> _statusItems = [
    DropdownItemModel(id: 1, name: "Aktif", value: "true"),
    DropdownItemModel(id: 2, name: "Non-Aktif", value: "false"),
  ];

  final List<DropdownItemModel> _roleItems = [
    DropdownItemModel(id: 1, name: "Owner", value: "OWNER"),
    DropdownItemModel(
      id: 2,
      name: "Customer Service",
      value: "CUSTOMER_SERVICE",
    ),
    DropdownItemModel(id: 3, name: "Warehouse", value: "WAREHOUSE"),
    DropdownItemModel(id: 4, name: "Cashier", value: "CASHIER"),
  ];

  @override
  void initState() {
    super.initState();
    _currentUser = widget.user;
  }

  Future<void> _refresh() async {
    try {
      final model = await _userRepository.getUserList(
        roleId: '',
        search: _currentUser.id ?? '',
        page: 1,
        limit: 10,
      );
      if (model.data != null && model.data!.isNotEmpty) {
        final updated = model.data!.firstWhere(
          (u) => u.id == _currentUser.id,
          orElse: () => _currentUser,
        );
        setState(() => _currentUser = updated);
        if (mounted) context.read<UserBloc>().add(LoadUserList());
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.error(context: context, message: e.toString());
      }
    }
  }

  void _showStatusSheet() {
    DropdownItemModel? localStatus = _statusItems.firstWhere(
      (e) => e.value == (_currentUser.isActive == true ? "true" : "false"),
      orElse: () => _statusItems.first,
    );

    CustomBottomsheetfix.show(
      context,
      title: "Ubah Status User",
      initialChildSize: 0.4,
      onDismissed: () {},
      primaryButtonText: "Simpan",
      pBackgroundColor: AppColors.primary,
      onPressed: () {
        final isActive = localStatus?.value == "true";
        _updateStatus(isActive);
        return true;
      },
      children: [
        StatefulBuilder(
          builder: (context, setSheetState) {
            return CustomRadioGroup(
              items: _statusItems,
              value: localStatus,
              onChanged: (val) => setSheetState(() => localStatus = val),
            );
          },
        ),
      ],
    );
  }

  void _showRoleSheet() {
    DropdownItemModel? localRole = _roleItems.firstWhere(
      (e) => e.value == _currentUser.role?.toUpperCase(),
      orElse: () => _roleItems.first,
    );

    CustomBottomsheet.show(
      context,
      title: "Ubah Role User",
      initialChildSize: 0.4,

      onDismissed: () {},
      primaryButtonText: "Simpan",
      pBackgroundColor: AppColors.primary,
      onPressed: () {
        if (localRole != null) {
          _updateRole(localRole?.value ?? '');
        }
        return true;
      },
      children: [
        StatefulBuilder(
          builder: (context, setSheetState) {
            return CustomRadioGroup(
              items: _roleItems,
              value: localRole,
              onChanged: (val) => setSheetState(() => localRole = val),
            );
          },
        ),
      ],
    );
  }

  Future<void> _updateStatus(bool active) async {
    setState(() => _loading = true);
    try {
      await _service.updateUserActivation(
        userId: _currentUser.id ?? '',
        isActive: active,
      );
      setState(() {
        _currentUser = _currentUser.copyWith(isActive: active);
      });
      if (mounted) {
        AppSnackBar.success(
          context: context,
          message: 'Status berhasil diubah',
        );
      }
      unawaited(_refresh());
    } catch (e) {
      if (mounted) {
        AppSnackBar.error(context: context, message: e.toString());
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _updateRole(String role) async {
    setState(() => _loading = true);
    try {
      await _service.updateUserRole(userId: _currentUser.id ?? '', role: role);
      setState(() {
        _currentUser = _currentUser.copyWith(role: role);
      });
      if (mounted) {
        AppSnackBar.success(context: context, message: 'Role berhasil diubah');
      }
      unawaited(_refresh());
    } catch (e) {
      if (mounted) {
        AppSnackBar.error(context: context, message: e.toString());
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Widget buildItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: CustomText(
              text: title,
              style: TextStyle(color: SupportAppColors.greyColor, fontSize: 14),
            ),
          ),
          Expanded(
            flex: 3,
            child: CustomText(
              text: value,
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: SupportAppColors.greyDarkerColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCard(String title, List<Widget> children) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: SupportAppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: SupportAppColors.greyDarkerColor,
              fontSize: 18,
            ),
          ),
          const CustomSpacing(height: 12),
          ...children,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
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
        title: CustomText(
          text: _currentUser.name ?? 'User Detail',
          style: const TextStyle(
            color: SupportAppColors.greyDarkerColor,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    buildCard("Informasi User", [
                      buildItem("Nama", _currentUser.name ?? "-"),
                      buildItem("Email", _currentUser.email ?? "-"),
                      buildItem("Role", _currentUser.displayRole),
                      buildItem(
                        "Status",
                        _currentUser.isActive == true ? "Aktif" : "Non-Aktif",
                      ),
                    ]),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: _loading ? "Loading..." : "Ubah Status",
                      backgroundColor: AppColors.primary,
                      foregroundColor: SupportAppColors.white,
                      fontSize: 16,
                      onPressed: _loading ? null : _showStatusSheet,
                    ),
                  ),
                  const CustomSpacing(width: 12),
                  Expanded(
                    child: CustomButton(
                      text: _loading ? "Loading..." : "Ubah Role",
                      backgroundColor: AppColors.primary,
                      foregroundColor: SupportAppColors.white,
                      fontSize: 16,
                      onPressed: _loading ? null : _showRoleSheet,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
