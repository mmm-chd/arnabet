import 'package:arena/config/design/custom_icons.dart';
import 'package:arena/models/enums/enums.dart';
import 'package:arena/models/metadata/status_style.dart';
import 'package:arena/config/theme/app_colors.dart';

class InboxConfig {
  static StatusStyle getStyle(InboxSubject subject) {
    switch (subject) {
      case InboxSubject.stok:
        return const StatusStyle(
          background: SupportAppColors.lightRed,
          foreground: SupportAppColors.normalRed,
          customIcon: CustomIcons.inboxStock,
        );
      case InboxSubject.aging:
        return const StatusStyle(
          background: SupportAppColors.lightRed,
          foreground: SupportAppColors.normalRed,
          customIcon: CustomIcons.history,
        );
      case InboxSubject.perubahan:
        return const StatusStyle(
          background: SupportAppColors.lightOrange,
          foreground: SupportAppColors.normalOrange,
          customIcon: CustomIcons.inboxCaution,
        );
      case InboxSubject.pengguna:
        return const StatusStyle(
          background: SupportAppColors.lightGreen,
          foreground: SupportAppColors.normalGreen,
          customIcon: CustomIcons.inboxPerson,
        );
      case InboxSubject.laporan:
        return const StatusStyle(
          background: SupportAppColors.lightGreen,
          foreground: SupportAppColors.normalGreen,
          customIcon: CustomIcons.inboxDownload,
        );
      default:
        return const StatusStyle(
          background: SupportAppColors.greyMidTermColor,
          foreground: SupportAppColors.greyDarkColor,
          customIcon: CustomIcons.inbox,
        );
    }
  }
}

class StockConfig {
  static const Map<String, StatusStyle> _stylesByName = {
    'kadaluarsa': StatusStyle(
      background: SupportAppColors.lightRed,
      foreground: SupportAppColors.normalRed,
    ),
    'urgent': StatusStyle(
      background: SupportAppColors.lightRed,
      foreground: SupportAppColors.normalRed,
    ),
    'warning': StatusStyle(
      background: SupportAppColors.lightMidOrange,
      foreground: SupportAppColors.normalMidOrange,
    ),
    'waspada': StatusStyle(
      background: SupportAppColors.lightMidOrange,
      foreground: SupportAppColors.normalMidOrange,
    ),
    'perhatian': StatusStyle(
      background: SupportAppColors.lightOrange,
      foreground: SupportAppColors.normalOrange,
    ),
    'aman': StatusStyle(
      background: SupportAppColors.lightGreen,
      foreground: SupportAppColors.normalGreen,
    ),
  };

  static const StatusStyle _defaultStyle = StatusStyle(
    background: SupportAppColors.greyMidTermColor,
    foreground: SupportAppColors.greyDarkColor,
  );

  static StatusStyle getStyleByName(String? name) {
    if (name == null || name.trim().isEmpty) return _defaultStyle;
    final normalized = name.trim().toLowerCase();
    for (final entry in _stylesByName.entries) {
      if (normalized.contains(entry.key)) return entry.value;
    }
    return _defaultStyle;
  }
}

class OrderConfig {
  static StatusStyle getStyle(OrderStatus status) {
    switch (status) {
      case OrderStatus.NEED_PICKUP:
        return const StatusStyle(
          background: SupportAppColors.greyMidTermColor,
          foreground: SupportAppColors.greyColor,
        );

      case OrderStatus.PROCESSING:
        return const StatusStyle(
          background: SupportAppColors.lightOrange,
          foreground: SupportAppColors.normalOrange,
        );

      case OrderStatus.COMPLETED:
        return const StatusStyle(
          background: SupportAppColors.lightGreen,
          foreground: SupportAppColors.normalGreen,
        );
      case OrderStatus.CANCELLED:
        return const StatusStyle(
          background: SupportAppColors.lightRed,
          foreground: SupportAppColors.normalRed,
        );
    }
  }
}

class PaymentConfig {
  static StatusStyle getStyle(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.PAID:
        return const StatusStyle(
          background: SupportAppColors.normalGreen,
          foreground: SupportAppColors.white,
        );

      case PaymentStatus.PROCESSING:
        return const StatusStyle(
          background: SupportAppColors.normalOrange,
          foreground: SupportAppColors.white,
        );

      case PaymentStatus.FAILED:
        return const StatusStyle(
          background: SupportAppColors.normalMidRed,
          foreground: SupportAppColors.white,
        );
      case PaymentStatus.REFUNDED:
        return const StatusStyle(
          background: SupportAppColors.normalRed,
          foreground: SupportAppColors.white,
        );
      case PaymentStatus.UNPAID:
        return const StatusStyle(
          background: SupportAppColors.greyColor,
          foreground: SupportAppColors.white,
        );
      case PaymentStatus.EXPIRED:
        return const StatusStyle(
          background: SupportAppColors.lightRed,
          foreground: SupportAppColors.normalMidRed,
        );
    }
  }
}
