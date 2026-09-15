import 'package:arena/components/icon_button/custom_icon_button_circle.dart';
import 'package:arena/components/custom_spacing.dart';
import 'package:arena/config/design/custom_icons.dart';
import 'package:arena/components/text_field/custom_text_field.dart';
import 'package:arena/config/theme/app_colors.dart';
import 'package:arena/utils/app_shared_preferances.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HeaderSearch extends StatefulWidget {
  final VoidCallback? onTapFilter;
  final VoidCallback? onTapSearch;
  final ValueChanged<String> onChanged;
  final ValueChanged<bool>? onFocusChanged;
  final bool useFilter;

  const HeaderSearch({
    super.key,
    this.onTapFilter,
    required this.onChanged,
    this.onTapSearch,
    this.onFocusChanged,
    this.useFilter = false,
  });

  @override
  State<HeaderSearch> createState() => _HeaderSearchState();
}

class _HeaderSearchState extends State<HeaderSearch> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<String> _history = [];
  bool _showHistory = false;

  @override
  void initState() {
    super.initState();
    _loadHistory();
    _focusNode.addListener(() {
      final hasFocus = _focusNode.hasFocus;
      widget.onFocusChanged?.call(hasFocus);
      setState(() {
        _showHistory = hasFocus && _history.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _loadHistory() async {
    final list = await AppSharedPreferances.readList('inbox_search_history');
    setState(() {
      _history = list;
    });
  }

  Future<void> _saveToHistory(String query) async {
    if (query.trim().isEmpty) return;

    _history.remove(query);
    _history.insert(0, query);

    if (_history.length > 8) {
      _history = _history.sublist(0, 4);
    }

    await AppSharedPreferances.writeList('inbox_search_history', _history);
    setState(() {});
  }

  Future<void> _removeFromHistory(String query) async {
    _history.remove(query);
    await AppSharedPreferances.writeList('inbox_search_history', _history);
    setState(() {
      _showHistory = _history.isNotEmpty;
    });
  }

  void _onSubmitted(String value) {
    // _saveToHistory(value);
    _focusNode.unfocus();
    setState(() => _showHistory = false);
    widget.onChanged(value);
  }

  void _selectHistory(String item) {
    _controller.text = item;
    _controller.selection = TextSelection.fromPosition(
      TextPosition(offset: item.length),
    );
    widget.onChanged(item);
    _focusNode.unfocus();
    setState(() => _showHistory = false);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  controller: _controller,

                  focusNode: _focusNode,
                  onChanged: (value) {
                    widget.onChanged(value);
                    setState(() {
                      _showHistory = _focusNode.hasFocus && _history.isNotEmpty;
                    });
                  },
                  onTap: () {
                    widget.onTapSearch?.call();
                    setState(() {
                      _showHistory = _focusNode.hasFocus && _history.isNotEmpty;
                    });
                  },
                  onFieldSubmitted: _onSubmitted,
                  borderColor: SupportAppColors.greyMidTermColor,
                  usePrefixIcon: true,
                  prefixIcon: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: SvgPicture.asset(
                      CustomIcons.search,
                      width: 20,
                      height: 20,
                      colorFilter: ColorFilter.mode(
                        SupportAppColors.greyDarkColor,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  useSuffixIcon: true,
                  suffixIcon: _controller.text.isEmpty
                      ? const CustomSpacing()
                      : CustomIconbuttonCircle(
                          onPressed: () {
                            _focusNode.unfocus();
                            _controller.clear();
                            widget.onChanged("");
                            setState(() {});
                          },
                          prefixIcon: Icons.close,
                          iconSize: 20,
                        ),
                  hint: "Search...",
                  label: "Search...",
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              if (widget.useFilter) ...[
                const CustomSpacing(width: 10),
                _buildFilterButton(context, widget.onTapFilter ?? () {}),
              ],
            ],
          ),


        ],
      ),
    );
  }
}

Widget _buildFilterButton(BuildContext context, VoidCallback onTap) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(16),
    child: Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 0,
      child: Container(
        height: 48,
        width: 48,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: SvgPicture.asset(
          CustomIcons.filter,
          colorFilter: ColorFilter.mode(
            SupportAppColors.greyDarkerColor,
            BlendMode.srcIn,
          ),
        ),
      ),
    ),
  );
}
