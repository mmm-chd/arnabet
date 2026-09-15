import 'dart:async';

import 'package:arena/components/notification/notification_banner_widget.dart';
import 'package:arena/models/notification/notification_banner_model.dart';
import 'package:flutter/material.dart';

class NotificationBannerOverlay extends StatefulWidget {
  const NotificationBannerOverlay({
    super.key,
    required this.model,
    required this.onCompleted,
  });

  final NotificationBannerModel model;

  final VoidCallback onCompleted;

  @override
  State<NotificationBannerOverlay> createState() =>
      _NotificationBannerOverlayState();
}

class _NotificationBannerOverlayState extends State<NotificationBannerOverlay>
    with SingleTickerProviderStateMixin {
  static const _animDuration = Duration(milliseconds: 250);
  static const _progressTick = Duration(milliseconds: 50);

  late final AnimationController _controller;
  late final Animation<Offset> _slide;
  late final Animation<double> _fade;

  Timer? _autoDismissTimer;
  Timer? _progressTicker;
  double _progress = 1.0;
  bool _dismissing = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: _animDuration);
    _slide = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.forward();
    _startAutoDismiss();
  }

  void _startAutoDismiss() {
    final totalDuration = widget.model.duration;
    final totalTicks =
        (totalDuration.inMilliseconds / _progressTick.inMilliseconds).clamp(
          1,
          double.infinity,
        );
    var elapsedTicks = 0;

    _progressTicker = Timer.periodic(_progressTick, (timer) {
      elapsedTicks++;
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        _progress = (1 - (elapsedTicks / totalTicks)).clamp(0.0, 1.0);
      });
      if (elapsedTicks >= totalTicks) {
        timer.cancel();
      }
    });

    _autoDismissTimer = Timer(totalDuration, _dismiss);
  }

  Future<void> _dismiss() async {
    if (_dismissing || !mounted) return;
    _dismissing = true;

    _autoDismissTimer?.cancel();
    _progressTicker?.cancel();

    await _controller.reverse();
    if (!mounted) return;

    widget.onCompleted();
  }

  @override
  void dispose() {
    _autoDismissTimer?.cancel();
    _progressTicker?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        bottom: false,
        child: SlideTransition(
          position: _slide,
          child: FadeTransition(
            opacity: _fade,
            child: NotificationBannerWidget(
              model: widget.model,
              progress: _progress,
              onDismiss: _dismiss,
            ),
          ),
        ),
      ),
    );
  }
}
