import 'package:arena/components/custom_text.dart';
import 'package:arena/components/dropdown/app_dropdown_color_schema.dart';
import 'package:arena/components/dropdown/custom_searchable_pop_dropdown.dart';
import 'package:arena/components/dropdown/dropdown_color_scheme.dart';
import 'package:arena/config/theme/app_colors.dart';
import 'package:arena/models/metadata/dropdown_item_model.dart';
import 'package:flutter/material.dart';

class BuildSearchablePopupDropdown extends StatelessWidget {
  final String hint;
  final List<DropdownItemModel> items;
  final ValueChanged<DropdownItemModel?> onChanged;
  final DropdownItemModel? value;

  final String? label;
  final bool enabled;

  final List<int> disabledIndexes;

  final String? helperText;
  final String? errorText;
  final TextStyle? helperStyle;
  final TextStyle? errorStyle;
  final int? helperMaxLines;
  final int? errorMaxLines;
  final Color? errorOutline;
  final bool useErrorIcon;

  final String? Function(DropdownItemModel?)? validator;
  final bool Function(DropdownItemModel, String)? customFilter;

  final void Function()? onEmpty;
  final String emptyText;

  final DropdownColorScheme? colorScheme;

  final void Function(String query)? onSearch;
  final bool isLoading;
  final void Function()? onLoadMore;
  final bool hasMore;

  final Widget Function(String)? emptyBuilder;

  const BuildSearchablePopupDropdown({
    super.key,
    required this.hint,
    required this.items,
    required this.onChanged,
    required this.value,
    this.label,
    this.enabled = true,
    this.disabledIndexes = const [],
    this.helperText,
    this.errorText,
    this.helperStyle,
    this.errorStyle,
    this.helperMaxLines,
    this.errorMaxLines,
    this.errorOutline,
    this.useErrorIcon = false,
    this.validator,
    this.customFilter,
    this.onEmpty,
    this.emptyText = 'Data tidak tersedia',
    this.colorScheme,
    this.onSearch,
    this.isLoading = false,
    this.onLoadMore,
    this.hasMore = false,
    this.emptyBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return CustomSearchablePopDropdown<DropdownItemModel>(
      hint: hint,
      items: items,
      value: value,
      onChanged: onChanged,
      itemLabel: (item) => item.name,
      compareItems: (a, b) => a.id == b.id,
      label: label,
      enabled: enabled,
      disabledIndexes: disabledIndexes,
      helperText: helperText,
      errorText: errorText,
      helperStyle: helperStyle,
      errorStyle: errorStyle,
      helperMaxLines: helperMaxLines,
      errorMaxLines: errorMaxLines,
      errorOutline: errorOutline,
      useErrorIcon: useErrorIcon,
      validator: validator,
      customFilter: onSearch != null ? (_, __) => true : customFilter,
      onEmpty: onEmpty,
      emptyText: emptyText,
      colorScheme: colorScheme ?? AppDropdownColorScheme.primary(),
      onSearch: onSearch,
      isLoading: isLoading,
      onLoadMore: onLoadMore,
      hasMore: hasMore,
      emptyBuilder:
          emptyBuilder ??
          (query) {
            if (query.isEmpty || query.length <= 3) {
              return Center(
                child: CustomText(
                  text: "Ketikkan untuk mencari",
                  style: TextStyle(
                    color: SupportAppColors.greyColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            }
            return Center(
              child: CustomText(
                text: emptyText,
                style: TextStyle(
                  color: SupportAppColors.greyColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            );
          },
    );
  }
}
