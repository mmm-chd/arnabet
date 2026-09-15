import 'package:arena/components/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomAvatar extends StatefulWidget {
  final String? name;
  final String? imageUrl;
  final double radius;
  final Color? backgroundColor;
  final TextStyle? textStyle;

  const CustomAvatar({
    super.key,
    this.name,
    this.imageUrl,
    this.radius = 20,
    this.backgroundColor,
    this.textStyle,
  });

  @override
  State<CustomAvatar> createState() => _CustomAvatarState();
}

class _CustomAvatarState extends State<CustomAvatar> {
  bool _hasError = false;

  @override
  void didUpdateWidget(covariant CustomAvatar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageUrl != widget.imageUrl) {
      setState(() {
        _hasError = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double pixelRatio =
        MediaQuery.maybeOf(context)?.devicePixelRatio ?? 3.0;
    final int cacheSize = (widget.radius * 2 * pixelRatio).round();

    Widget avatar;

    if (widget.imageUrl != null && widget.imageUrl!.isNotEmpty && !_hasError) {
      final isNetwork = widget.imageUrl!.startsWith('http');
      final isAsset = widget.imageUrl!.startsWith('assets/');

      if (isNetwork) {
        avatar = CircleAvatar(
          radius: widget.radius,
          backgroundImage: ResizeImage(
            NetworkImage(widget.imageUrl!),
            width: cacheSize,
            height: cacheSize,
          ),
          backgroundColor: Colors.transparent,
          onBackgroundImageError: (exception, stackTrace) {
            if (mounted) {
              setState(() {
                _hasError = true;
              });
            }
          },
        );
      } else if (isAsset) {
        if (widget.imageUrl!.endsWith('.svg')) {
          avatar = CircleAvatar(
            radius: widget.radius,
            backgroundColor: Colors.transparent,
            child: ClipOval(
              child: SvgPicture.asset(
                widget.imageUrl!,
                width: widget.radius * 2,
                height: widget.radius * 2,
                fit: BoxFit.cover,
              ),
            ),
          );
        } else {
          avatar = CircleAvatar(
            radius: widget.radius,
            backgroundImage: ResizeImage(
              AssetImage(widget.imageUrl!),
              width: cacheSize,
              height: cacheSize,
            ),
            backgroundColor: Colors.transparent,
            onBackgroundImageError: (exception, stackTrace) {
              if (mounted) {
                setState(() {
                  _hasError = true;
                });
              }
            },
          );
        }
      } else {
        avatar = _buildInitialsAvatar();
      }
    } else {
      avatar = _buildInitialsAvatar();
    }

    return RepaintBoundary(child: avatar);
  }

  Widget _buildInitialsAvatar() {
    final initials = widget.name != null && widget.name!.isNotEmpty
        ? widget.name!
              .trim()
              .split(' ')
              .map((e) => e[0])
              .take(2)
              .join()
              .toUpperCase()
        : '?';

    final color =
        widget.backgroundColor ?? _getColorFromName(widget.name ?? '');

    return CircleAvatar(
      radius: widget.radius,
      backgroundColor: color,
      child: CustomText(
        text: initials,
        style:
            widget.textStyle ??
            TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: widget.radius * 0.8,
            ),
      ),
    );
  }

  Color _getColorFromName(String name) {
    final colors = [
      const Color(0xFF1E88E5),
      const Color(0xFFD81B60),
      const Color(0xFF00897B),
      const Color(0xFFF4511E),
      const Color(0xFF43A047),
      const Color(0xFF5E35B1),
      const Color(0xFF3949AB),
      const Color(0xFFFB8C00),
    ];
    if (name.isEmpty) return colors[0];
    final hash = name.codeUnits.reduce((a, b) => a + b);
    return colors[hash % colors.length];
  }
}
