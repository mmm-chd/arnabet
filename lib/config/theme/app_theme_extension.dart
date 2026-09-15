import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  const AppThemeExtension({
    required this.cardColor,
    required this.surfaceColor,
    required this.textPrimary,
    required this.textSecondary,
    required this.textHint,
    required this.dividerColor,
    required this.iconColor,
    required this.badgeDangerBg,
    required this.badgeDangerText,
    required this.badgeWarningBg,
    required this.badgeWarningText,
    required this.badgeSuccessBg,
    required this.badgeSuccessText,
    required this.badgeNeutralBg,
    required this.badgeNeutralText,
  });

  // Base semantics
  final Color cardColor;
  final Color surfaceColor;

  // Text semantics
  final Color textPrimary;
  final Color textSecondary;
  final Color textHint;

  // Elements
  final Color dividerColor;
  final Color iconColor;

  // Badges & Statuses
  final Color badgeDangerBg;
  final Color badgeDangerText;
  final Color badgeWarningBg;
  final Color badgeWarningText;
  final Color badgeSuccessBg;
  final Color badgeSuccessText;
  final Color badgeNeutralBg;
  final Color badgeNeutralText;

  static const light = AppThemeExtension(
    // Base semantics
    cardColor: SupportAppColors.white,
    surfaceColor: AppColors.bgColor,

    // Text semantics
    textPrimary: SupportAppColors.greyDarkerColor,
    textSecondary: SupportAppColors.greyColor,
    textHint: SupportAppColors.greyDarkColor,

    // Elements
    dividerColor: SupportAppColors.greyMidColor,
    iconColor: SupportAppColors.greyDarkerColor,

    // Badges & Statuses
    badgeDangerBg: SupportAppColors.lightRed,
    badgeDangerText: SupportAppColors.normalRed,
    badgeWarningBg: SupportAppColors.lightOrange,
    badgeWarningText: SupportAppColors.normalOrange,
    badgeSuccessBg: SupportAppColors.lightGreen,
    badgeSuccessText: SupportAppColors.normalGreen,
    badgeNeutralBg: SupportAppColors.greyMidTermColor,
    badgeNeutralText: SupportAppColors.greyDarkColor,
  );

  @override
  AppThemeExtension copyWith({
    Color? cardColor,
    Color? surfaceColor,
    Color? textPrimary,
    Color? textSecondary,
    Color? textHint,
    Color? dividerColor,
    Color? iconColor,
    Color? badgeDangerBg,
    Color? badgeDangerText,
    Color? badgeWarningBg,
    Color? badgeWarningText,
    Color? badgeSuccessBg,
    Color? badgeSuccessText,
    Color? badgeNeutralBg,
    Color? badgeNeutralText,
  }) => AppThemeExtension(
    cardColor: cardColor ?? this.cardColor,
    surfaceColor: surfaceColor ?? this.surfaceColor,
    textPrimary: textPrimary ?? this.textPrimary,
    textSecondary: textSecondary ?? this.textSecondary,
    textHint: textHint ?? this.textHint,
    dividerColor: dividerColor ?? this.dividerColor,
    iconColor: iconColor ?? this.iconColor,
    badgeDangerBg: badgeDangerBg ?? this.badgeDangerBg,
    badgeDangerText: badgeDangerText ?? this.badgeDangerText,
    badgeWarningBg: badgeWarningBg ?? this.badgeWarningBg,
    badgeWarningText: badgeWarningText ?? this.badgeWarningText,
    badgeSuccessBg: badgeSuccessBg ?? this.badgeSuccessBg,
    badgeSuccessText: badgeSuccessText ?? this.badgeSuccessText,
    badgeNeutralBg: badgeNeutralBg ?? this.badgeNeutralBg,
    badgeNeutralText: badgeNeutralText ?? this.badgeNeutralText,
  );

  @override
  AppThemeExtension lerp(AppThemeExtension? other, double t) {
    if (other == null) return this;
    return AppThemeExtension(
      cardColor: Color.lerp(cardColor, other.cardColor, t)!,
      surfaceColor: Color.lerp(surfaceColor, other.surfaceColor, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textHint: Color.lerp(textHint, other.textHint, t)!,
      dividerColor: Color.lerp(dividerColor, other.dividerColor, t)!,
      iconColor: Color.lerp(iconColor, other.iconColor, t)!,
      badgeDangerBg: Color.lerp(badgeDangerBg, other.badgeDangerBg, t)!,
      badgeDangerText: Color.lerp(badgeDangerText, other.badgeDangerText, t)!,
      badgeWarningBg: Color.lerp(badgeWarningBg, other.badgeWarningBg, t)!,
      badgeWarningText: Color.lerp(
        badgeWarningText,
        other.badgeWarningText,
        t,
      )!,
      badgeSuccessBg: Color.lerp(badgeSuccessBg, other.badgeSuccessBg, t)!,
      badgeSuccessText: Color.lerp(
        badgeSuccessText,
        other.badgeSuccessText,
        t,
      )!,
      badgeNeutralBg: Color.lerp(badgeNeutralBg, other.badgeNeutralBg, t)!,
      badgeNeutralText: Color.lerp(
        badgeNeutralText,
        other.badgeNeutralText,
        t,
      )!,
    );
  }
}

extension AppThemeExtensionContext on BuildContext {
  AppThemeExtension get appColors =>
      Theme.of(this).extension<AppThemeExtension>()!;
}