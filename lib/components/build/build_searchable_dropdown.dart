import 'package:arena/components/dropdown/app_dropdown_color_schema.dart';
import 'package:arena/components/dropdown/custom_searchable_dropdown.dart';
import 'package:arena/components/dropdown/dropdown_color_scheme.dart';
import 'package:arena/models/metadata/dropdown_item_model.dart';
import 'package:flutter/material.dart';

class BuildSearchableDropdown extends StatelessWidget {
  final String hint;
  final List<DropdownItemModel> items;
  final ValueChanged<DropdownItemModel?> onChanged;
  final DropdownItemModel? value;

  final String? label;
  final bool enabled;

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
  final Widget Function(String)? emptyBuilder;

  final DropdownColorScheme? colorScheme;

  final void Function(String query)? onSearch;
  final bool isLoading;
  final void Function()? onLoadMore;
  final bool hasMore;

  const BuildSearchableDropdown({
    super.key,
    required this.hint,
    required this.items,
    required this.onChanged,
    required this.value,
    this.label,
    this.enabled = true,
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
    this.emptyBuilder,
    this.colorScheme,
    this.onSearch,
    this.isLoading = false,
    this.onLoadMore,
    this.hasMore = false,
  });

  @override
  Widget build(BuildContext context) {
    return CustomSearchableDropdown<DropdownItemModel>(
      hint: hint,
      items: items,
      value: value,
      onChanged: onChanged,
      itemLabel: (item) => item.name,
      compareItems: (a, b) => a.id == b.id,
      label: label,
      enabled: enabled,
      helperText: helperText,
      errorText: errorText,
      helperStyle: helperStyle,
      errorStyle: errorStyle,
      helperMaxLines: helperMaxLines,
      errorMaxLines: errorMaxLines,
      errorOutline: errorOutline,
      useErrorIcon: useErrorIcon,
      validator: validator,
      customFilter: customFilter,
      onEmpty: onEmpty,
      emptyText: emptyText,
      onSearch: onSearch,
      isLoading: isLoading,
      onLoadMore: onLoadMore,
      hasMore: hasMore,
      emptyBuilder:
          emptyBuilder ??
          (query) {
            if (query.isEmpty) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search, size: 48, color: Colors.grey.shade300),
                    const SizedBox(height: 12),
                    Text(
                      "Ketikkan untuk mencari",
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inbox_outlined,
                    size: 48,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    emptyText,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          },
      colorScheme: colorScheme ?? AppDropdownColorScheme.primary(),
    );
  }
}
