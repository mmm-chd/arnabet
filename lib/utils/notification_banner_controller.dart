import 'package:arena/components/notification/notification_banner_overlay.dart';
import 'package:arena/models/notification/notification_banner_model.dart';
import 'package:flutter/material.dart';

class NotificationBannerController {
  NotificationBannerController._();

  static final NotificationBannerController instance =
      NotificationBannerController._();

  final GlobalKey<OverlayState> overlayKey = GlobalKey<OverlayState>();

  final List<NotificationBannerModel> _queue = [];
  OverlayEntry? _entry;
  bool _isShowing = false;
  NotificationBannerModel? _currentModel;
  int? _lastShownCount;

  void show(NotificationBannerModel model) {
    final count = _extractCount(model.message);
    if (count != null && count == _lastShownCount) return;
    if (_currentModel?.message == model.message) return;
    if (_queue.any((m) => m.message == model.message)) return;

    _queue.add(model);
    if (!_isShowing) {
      _showNext();
    }
  }

  int? _extractCount(String message) {
    final reg = RegExp(r'(\d+)');
    final match = reg.firstMatch(message);
    return match != null ? int.tryParse(match.group(1)!) : null;
  }

  void hide() {
    _queue.clear();
    _removeEntry();
    _isShowing = false;
    _currentModel = null;
  }

  void _showNext() {
    if (_queue.isEmpty) {
      _isShowing = false;
      return;
    }

    final overlayState = overlayKey.currentState;
    if (overlayState == null) {
      _isShowing = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_isShowing && _queue.isNotEmpty) _showNext();
      });
      return;
    }

    _isShowing = true;
    final model = _queue.removeAt(0);
    _currentModel = model;
    _lastShownCount = _extractCount(model.message);

    _removeEntry();

    _entry = OverlayEntry(
      builder: (context) => NotificationBannerOverlay(
        model: model,
        onCompleted: () {
          _removeEntry();
          _showNext();
        },
      ),
    );

    overlayState.insert(_entry!);
  }

  void _removeEntry() {
    _entry?.remove();
    _entry = null;
    _currentModel = null;
  }
}
