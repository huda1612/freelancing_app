import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';

class ListTabBar extends StatelessWidget {
  const ListTabBar({
    super.key,
    required this.getLabel,
    required this.isSelected,
    required this.onLabelTab,
    required this.tabsLength,
  });
  final int tabsLength;
  final String Function(int i) getLabel;
  final bool Function(int i) isSelected;
  final void Function(int i) onLabelTab;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.grey,
            blurRadius: 2,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(8, 3, 8, 0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(tabsLength, (i) {
            return Padding(
              padding: EdgeInsets.only(left: i == 0 ? 0 : 6.w),
              child: ListTabButton(
                label: getLabel(i),
                selected: isSelected(i),
                onTap: () => onLabelTab(i),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class ListTabButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool longerLine;
  const ListTabButton(
      {super.key,
      required this.label,
      required this.selected,
      required this.onTap,
      this.longerLine = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        decoration: const BoxDecoration(color: Colors.transparent),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 12.sp,
                color: selected ? AppColors.vividPurple : AppColors.normalGrey,
              ),
            ),
            SizedBox(height: 7.h),
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              height: 2.5,
              width: selected ? (longerLine ? 56 : 48) : 0,
              decoration: BoxDecoration(
                color: AppColors.vividPurple,
                borderRadius: BorderRadius.circular(20.r),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
