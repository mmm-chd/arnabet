import 'package:arena/components/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:arena/config/theme/app_colors.dart';

class CustomTimelineItem extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onChanged;
  final List<String> labels;
  bool isActive;

  CustomTimelineItem({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
    this.labels = const ["1D", "1W", "1M", "6M", "1Y"],
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {

    return Row(
      children: List.generate(labels.length, (index) {
         isActive = selectedIndex >= 0 && index == selectedIndex;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                color: isActive ? SupportAppColors.lightRed : SupportAppColors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              clipBehavior: Clip.antiAlias,
              child: Material(
                type: MaterialType.transparency,
                child: InkWell(
                  onTap: () => onChanged(index),
                  child: Container(
                    alignment: Alignment.center,
                    height: double.infinity,
                    child: CustomText(
                      text: labels[index],
                      style: TextStyle(
                        fontSize: 14,
                        color: isActive ? SupportAppColors.normalRed : SupportAppColors.greyColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
