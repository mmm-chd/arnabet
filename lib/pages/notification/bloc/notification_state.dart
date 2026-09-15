import 'package:arena/models/notification/notification_item.dart';
import 'package:equatable/equatable.dart';

enum NotificationStatus {
  initial,
  loading,
  ready,
  submitting,
  success,
  failure,
}

class NotificationState extends Equatable {
  final NotificationStatus status;
  final int unreadCount;
  final NotificationItem? latestNotification;
  final String? errorMessage;

  const NotificationState({
    this.status = NotificationStatus.initial,
    this.unreadCount = 0,
    this.latestNotification,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [
    status,
    unreadCount,
    latestNotification,
    errorMessage,
  ];

  NotificationState copyWith({
    NotificationStatus? status,
    int? unreadCount,
    NotificationItem? latestNotification,
    Object? errorMessage = _sentinel,
  }) {
    return NotificationState(
      status: status ?? this.status,
      unreadCount: unreadCount ?? this.unreadCount,
      latestNotification: latestNotification ?? this.latestNotification,
      errorMessage: identical(errorMessage, _sentinel)
          ? this.errorMessage
          : errorMessage as String?,
    );
  }

  bool get isInitial => status == NotificationStatus.initial;
  bool get isLoading => status == NotificationStatus.loading;
  bool get isReady => status == NotificationStatus.ready;
  bool get isSubmitting => status == NotificationStatus.submitting;
  bool get isFailure => status == NotificationStatus.failure;
  bool get isSuccess => status == NotificationStatus.success;

  bool get hasUnreadCount => unreadCount > 0;
}

const _sentinel = Object();
