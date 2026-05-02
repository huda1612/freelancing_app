import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final bool isClient; // true = عميل → يظهر زر +

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.isClient,
  });

  @override
  Widget build(BuildContext context) {
    final gradientColors = [const Color(0xFF6A00FF), const Color(0xFF00C2FF)];

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            // color: Colors.black12,
            color: AppColors.grey,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: 70.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                icon: Icons.home_outlined,
                index: 0,
                gradientColors: gradientColors,
              ),
              _buildNavItem(
                icon: Icons.search,
                index: 1,
                gradientColors: gradientColors,
              ),
              if (isClient) _buildFabButton(gradientColors),
              _buildNavItem(
                icon: Icons.chat_bubble_outline,
                index: 2,
                gradientColors: gradientColors,
              ),
              _buildNavItem(
                icon: Icons.person_outline,
                index: 3,
                gradientColors: gradientColors,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required int index,
    required List<Color> gradientColors,
  }) {
    final isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ShaderMask(
            shaderCallback: (bounds) {
              return LinearGradient(
                colors: isSelected
                    ? gradientColors
                    : [Colors.grey.shade500, Colors.grey.shade500],
              ).createShader(bounds);
            },
            child: Icon(
              icon,
              size: 26,
              color: Colors.white, // اللون يتحدد من ShaderMask
            ),
          ),
          if (isSelected)
            Container(
              margin: const EdgeInsets.only(top: 4),
              height: 3,
              width: 18,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: gradientColors),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFabButton(List<Color> gradientColors) {
    return Container(
      height: 60,
      width: 60,
      margin: const EdgeInsets.only(top: 4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(colors: gradientColors),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: const Icon(
        Icons.add,
        color: Colors.white,
        size: 30,
      ),
    );
  }
}
