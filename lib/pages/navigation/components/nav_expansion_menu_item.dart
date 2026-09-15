import 'package:arena/components/custom_spacing.dart';
import 'package:arena/components/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:arena/config/theme/app_colors.dart';
import 'package:flutter_svg/svg.dart';

class NavExpansionMenuItem extends StatefulWidget {
  final String title;
  final String svgPath;
  final List<Widget> children;
  final bool initiallyExpanded;
  final Function(bool)? onExpansionChanged;

  const NavExpansionMenuItem({
    super.key,
    required this.title,
    required this.svgPath,
    required this.children,
    this.initiallyExpanded = false,
    this.onExpansionChanged,
  });

  @override
  State<NavExpansionMenuItem> createState() => _ExpansionMenuItemState();
}

class _ExpansionMenuItemState extends State<NavExpansionMenuItem> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
  }

  @override
  void didUpdateWidget(NavExpansionMenuItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initiallyExpanded != widget.initiallyExpanded) {
      _isExpanded = widget.initiallyExpanded;
    }
  }

  @override
  Widget build(BuildContext context) {

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              setState(() => _isExpanded = !_isExpanded);
              widget.onExpansionChanged?.call(_isExpanded);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Row(
                children: [
                  RepaintBoundary(
                    child: SvgPicture.asset(
                      widget.svgPath,
                      width: 22,
                      colorFilter: ColorFilter.mode(
                        SupportAppColors.greyDarkColor,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  const CustomSpacing(width: 16),
                  Expanded(
                    child: CustomText(
                      text: widget.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: SupportAppColors.greyDarkerColor,
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    turns: _isExpanded ? 0.5 : -0.25,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: SupportAppColors.greyDarkColor,
                    ),
                  ),
                ],
              ),
            ),
          ),

          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: ClipRect(
              clipBehavior: Clip.hardEdge,
              child: Align(
                alignment: Alignment.topCenter,
                heightFactor: _isExpanded ? 1.0 : 0.0,
                child: Padding(
                  padding: const EdgeInsets.only(left: 46, bottom: 8, right: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: widget.children,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
