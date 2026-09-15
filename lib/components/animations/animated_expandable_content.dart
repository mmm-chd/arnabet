import 'package:flutter/material.dart';

class AnimatedExpandableContent extends StatefulWidget {
  final bool expanded;
  final Widget child;
  final Duration duration;
  final Curve curve;
  final double axisAlignment;

  const AnimatedExpandableContent({
    super.key,
    required this.expanded,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeOutCubic,
    this.axisAlignment = -1.0,
  });

  @override
  State<AnimatedExpandableContent> createState() => _AnimatedExpandableContentState();
}

class _AnimatedExpandableContentState extends State<AnimatedExpandableContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _sizeFactor;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
      value: widget.expanded ? 1.0 : 0.0,
    );
    _sizeFactor = CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
      reverseCurve: widget.curve.flipped,
    );
  }

  @override
  void didUpdateWidget(AnimatedExpandableContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.expanded != oldWidget.expanded) {
      widget.expanded ? _controller.forward() : _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: _sizeFactor,
      axisAlignment: widget.axisAlignment,
      child: widget.child,
    );
  }
}