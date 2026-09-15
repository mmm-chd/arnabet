import 'package:arena/components/custom_spacing.dart';
import 'package:arena/components/custom_text.dart';
import 'package:arena/config/theme/app_colors.dart';
import 'package:arena/pages/inbox/bloc/inbox_bloc.dart';
import 'package:arena/pages/inbox/bloc/inbox_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class InboxCard extends StatelessWidget {
  final int id;
  final String title;
  final String subtitle;
  final String date;
  final String icon;
  final Color iconColor, bgColor;
  final bool isNew;
  final bool showButton;
  final double iconSize;
  final double? topLeft, topRight, bottomLeft, bottomRight;

  const InboxCard({
    super.key,
    required this.id,
    required this.title,
    required this.subtitle,
    required this.date,
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.iconSize,
    this.isNew = false,
    this.showButton = false,
    this.topLeft,
    this.topRight,
    this.bottomLeft,
    this.bottomRight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(topLeft ?? 0),
            topRight: Radius.circular(topRight ?? 0),
            bottomLeft: Radius.circular(bottomLeft ?? 0),
            bottomRight: Radius.circular(bottomRight ?? 0),
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(topLeft ?? 0),
            topRight: Radius.circular(topRight ?? 0),
            bottomLeft: Radius.circular(bottomLeft ?? 0),
            bottomRight: Radius.circular(bottomRight ?? 0),
          ),
          onTap: () => context.read<InboxBloc>().add(MarkAsRead(id)),
          onLongPress: () => context.read<InboxBloc>().add(DeleteInbox(id)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      padding: EdgeInsets.all(iconSize),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: bgColor,
                      ),
                      child: SvgPicture.asset(
                        icon,
                        colorFilter: ColorFilter.mode(
                          iconColor,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    const CustomSpacing(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: AnimatedDefaultTextStyle(
                                  duration: const Duration(milliseconds: 300),
                                  style: TextStyle(
                                    color: SupportAppColors.greyDarkerColor,
                                    fontSize: 14,
                                    fontWeight: isNew
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                  ),
                                  child: CustomText(text: title, maxLines: 1),
                                ),
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  AnimatedDefaultTextStyle(
                                    duration: const Duration(milliseconds: 300),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isNew
                                          ? SupportAppColors.greyDarkColor
                                          : SupportAppColors.greyColor,
                                      fontWeight: isNew
                                          ? FontWeight.w500
                                          : FontWeight.w400,
                                    ),
                                    child: CustomText(text: date, maxLines: 1),
                                  ),

                                  AnimatedSize(
                                    curve: Curves.easeInOut,
                                    duration: const Duration(milliseconds: 300),
                                    child: isNew
                                        ? Padding(
                                            padding: EdgeInsets.only(left: 6),
                                            child: Container(
                                              padding: EdgeInsets.all(3),
                                              decoration: BoxDecoration(
                                                color: SupportAppColors.greyDarkerColor,
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                          )
                                        : const CustomSpacing(),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          const CustomSpacing(height: 5),

                          CustomText(
                            text: subtitle,
                            maxLines: 2,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                              fontWeight: isNew
                                  ? FontWeight.w500
                                  : FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                if (showButton) ...[
                  const CustomSpacing(height: 12),
                  Ink(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: SupportAppColors.greyColor),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 16,
                        ),
                        child: CustomText(
                          text: "Klik untuk mengunduh",
                          style: TextStyle(
                            fontSize: 14,
                            color: isNew
                                ? SupportAppColors.greyDarkerColor
                                : SupportAppColors.greyColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
