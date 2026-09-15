import 'package:arena/components/animations/animated_expandable_content.dart';
import 'package:arena/components/custom_spacing.dart';
import 'package:arena/components/custom_text.dart';
import 'package:arena/config/theme/app_colors.dart';
import 'package:arena/models/customer/customer_list_model.dart';
import 'package:flutter/material.dart';

class CustomerItemCard extends StatefulWidget {
  final CustomerListDatum item;
  final bool firstItem;
  final bool lastItem;
  final VoidCallback? onTap;

  const CustomerItemCard({
    super.key,
    required this.item,
    this.firstItem = false,
    this.lastItem = false,
    this.onTap,
  });

  @override
  State<CustomerItemCard> createState() => _CustomerItemCardState();
}

class _CustomerItemCardState extends State<CustomerItemCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final vehicles = item.vehicles ?? [];
    final hasVehicles = vehicles.isNotEmpty;

    final radius = BorderRadius.vertical(
      top: widget.firstItem ? const Radius.circular(16) : Radius.zero,
      bottom: widget.lastItem ? const Radius.circular(16) : Radius.zero,
    );

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: radius,
        highlightColor: Colors.black.withValues(alpha: 0.04),
        splashColor: Colors.black.withValues(alpha: 0.08),
        child: Material(
          color: SupportAppColors.white,
          borderRadius: radius,
          elevation: 0,
          child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: widget.lastItem
                  ? BorderSide.none
                  : const BorderSide(color: SupportAppColors.greyMidColor),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: SupportAppColors.lightRed,
                          child: CustomText(
                            text: _initials(item.displayName),
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        const CustomSpacing(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text: item.displayName,
                                maxLines: 1,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                              const CustomSpacing(height: 2),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.phone_outlined,
                                    size: 14,
                                    color: SupportAppColors.greyColor,
                                  ),
                                  const CustomSpacing(width: 4),
                                  Flexible(
                                    child: CustomText(
                                      text: item.displayPhone,
                                      maxLines: 1,
                                      style: const TextStyle(
                                        color: SupportAppColors.greyColor,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const CustomSpacing(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Row(
                            children: [
                              const Icon(
                                Icons.calendar_today_outlined,
                                size: 13,
                                color: SupportAppColors.greyColor,
                              ),
                              const CustomSpacing(width: 4),
                              Flexible(
                                child: CustomText(
                                  text:
                                      "Order terakhir: ${item.displayLastOrderAt}",
                                  style: const TextStyle(
                                    color: SupportAppColors.greyColor,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: SupportAppColors.lightRed,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: CustomText(
                              text: "${vehicles.length} kendaraan",
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              AnimatedExpandableContent(
                expanded: _expanded,
                child: hasVehicles
                    ? Padding(
                        padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
                        child: Column(
                          children: vehicles.map((v) {
                            final topItem = vehicles.first == v;
                            return Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                    width: 0.5,
                                    color: SupportAppColors.greyMidColor,
                                    style: topItem
                                        ? BorderStyle.solid
                                        : BorderStyle.none,
                                  ),
                                  bottom: const BorderSide(
                                    width: 0.5,
                                    color: SupportAppColors.greyMidColor,
                                  ),
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 4,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.directions_car_filled_outlined,
                                          size: 14,
                                          color: SupportAppColors.greyColor,
                                        ),
                                        const CustomSpacing(width: 6),
                                        Flexible(
                                          child: CustomText(
                                            text: v.displayVehicleName,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: SupportAppColors
                                                  .greyDarkerColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  CustomText(
                                    text: v.displayVehiclePlate,
                                    maxLines: 1,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                      color: SupportAppColors.greyDarkerColor,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),

              if (hasVehicles)
                Padding(
                  padding: EdgeInsets.fromLTRB(14, _expanded ? 0 : 8, 14, 10),
                  child: Center(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () => setState(() => _expanded = !_expanded),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 2,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AnimatedRotation(
                              turns: _expanded ? -0.5 : 0.0,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              child: const Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: SupportAppColors.greyColor,
                              ),
                            ),
                            const CustomSpacing(width: 8),
                            CustomText(
                              text: _expanded
                                  ? "Sembunyikan Kendaraan"
                                  : "Lihat Kendaraan",
                              style: const TextStyle(
                                color: SupportAppColors.greyColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              else
                const CustomSpacing(height: 14),
            ],
          ),
        ),
      ),
    ),
  );
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return "?";
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }
}