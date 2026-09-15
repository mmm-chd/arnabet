import 'dart:async';

import 'package:arena/models/notification/notification_item.dart';
import 'package:arena/pages/notification/bloc/notification_event.dart';
import 'package:arena/pages/notification/bloc/notification_state.dart';
import 'package:arena/repositories/notification/notification_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository notificationRepository;

  static const _debounceDuration = Duration(milliseconds: 1500);
  static const _minGap = Duration(seconds: 5);

  StreamSubscription? _subscription;
  Timer? _reconnectTimer;
  Timer? _debounceTimer;
  int? _lastBannerCount;
  int? _lastAddedCount;
  int? _pendingCount;
  DateTime? _lastBannerShownAt;
  int _reconnectAttempts = 0;

  NotificationBloc({required this.notificationRepository})
    : super(const NotificationState()) {
    on<ConnectUnreadCount>(_onConnect);

    on<NotificationUnreadCountChanged>((event, emit) {
      emit(state.copyWith(unreadCount: event.unreadCount));

      _pendingCount = event.unreadCount;
      _debounceTimer?.cancel();
      _debounceTimer = Timer(_debounceDuration, () {
        if (_pendingCount != null && _lastBannerCount != _pendingCount) {
          _lastBannerCount = _pendingCount;
          _addBanner(_pendingCount!);
        }
        _pendingCount = null;
      });
    });

    on<DisconnectUnreadCount>((event, emit) async {
      _reconnectTimer?.cancel();
      _debounceTimer?.cancel();
      await _subscription?.cancel();
    });

    on<NotificationReceived>((event, emit) {
      // Cegah emit jika notif sama persis dengan yang sudah ada
      if (state.latestNotification?.id == event.notification.id) return;
      emit(state.copyWith(latestNotification: event.notification));
    });
  }

  void _addBanner(int count) {
    final now = DateTime.now();
    if (_lastBannerShownAt != null &&
        now.difference(_lastBannerShownAt!) < _minGap) {
      return; // jangan tampilkan jika masih dalam gap 5 detik
    }
    if (_lastAddedCount == count) return;
    _lastAddedCount = count;
    _lastBannerShownAt = now;
    add(
      NotificationReceived(
        notification: NotificationItem(
          id: 'notif_${now.millisecondsSinceEpoch}',
          title: 'Notifikasi Baru',
          body: 'Ada $count pesan belum dibaca',
          createdAt: now,
        ),
      ),
    );
  }

  Future<void> _onConnect(
    ConnectUnreadCount event,
    Emitter<NotificationState> emit,
  ) async {
    _reconnectTimer?.cancel();
    _debounceTimer?.cancel();
    await _subscription?.cancel();

    _subscription = notificationRepository.unreadCount().listen(
      (event) {
        _reconnectAttempts = 0;
        add(
          NotificationUnreadCountChanged(
            unreadCount: event.unreadCount,
            title: event.title,
            body: event.body,
          ),
        );
      },
      onError: (_) {
        _scheduleReconnect();
      },
      onDone: () {
        _scheduleReconnect();
      },
    );
  }

  void _scheduleReconnect() {
    _reconnectTimer?.cancel();
    final backoff = (5 << _reconnectAttempts).clamp(5, 60);
    _reconnectAttempts++;
    _reconnectTimer = Timer(Duration(seconds: backoff), () {
      add(ConnectUnreadCount());
    });
  }

  @override
  Future<void> close() {
    _reconnectTimer?.cancel();
    _debounceTimer?.cancel();
    _subscription?.cancel();
    return super.close();
  }
}
