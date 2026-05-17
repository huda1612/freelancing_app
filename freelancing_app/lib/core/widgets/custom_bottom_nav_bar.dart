import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/constants/app_routes.dart';
import 'package:get/get.dart';

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
              ),
              _buildNavItem(
                icon: Icons.search,
                index: 1,
              ),
              if (isClient) _buildFabButton(),
              _buildNavItem(
                icon: Icons.chat_bubble_outline,
                index: 2,
              ),
              _buildNavItem(
                icon: Icons.person_outline,
                index: 3,
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
  }) {
    final isSelected = currentIndex == index;

    return InkWell(
      onTap: () => onTap(index),
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 14.w,
          vertical: 10.h,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ShaderMask(
              shaderCallback: (bounds) {
                return LinearGradient(
                  colors: isSelected
                      ? AppColors.gradientColor.colors
                      : [AppColors.grey, AppColors.grey],
                ).createShader(bounds);
              },
              child: Icon(
                icon,
                size: 26,
                color: Colors.white,
              ),
            ),
            if (isSelected)
              Container(
                margin: const EdgeInsets.only(top: 4),
                height: 3,
                width: 18,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: AppColors.gradientColor.colors,
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Widget _buildNavItem({
  //   required IconData icon,
  //   required int index,
  // }) {
  //   final isSelected = currentIndex == index;

  //   return GestureDetector(
  //     onTap: () => onTap(index),
  //     behavior: HitTestBehavior.opaque,
  //     child: Column(
  //       mainAxisSize: MainAxisSize.min,
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         ShaderMask(
  //           shaderCallback: (bounds) {
  //             return LinearGradient(
  //               colors: isSelected
  //                   ? AppColors.gradientColor.colors
  //                   : [AppColors.grey, AppColors.grey],
  //             ).createShader(bounds);
  //           },
  //           child: Icon(
  //             icon,
  //             size: 26,
  //             color: AppColors.white, // اللون يتحدد من ShaderMask
  //           ),
  //         ),
  //         if (isSelected)
  //           Container(
  //             margin: const EdgeInsets.only(top: 4),
  //             height: 3,
  //             width: 18,
  //             decoration: BoxDecoration(
  //               gradient:
  //                   LinearGradient(colors: AppColors.gradientColor.colors),
  //               borderRadius: BorderRadius.circular(2),
  //             ),
  //           ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildFabButton() {
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.createProject),
      child: Container(
        height: 60,
        width: 60,
        margin: const EdgeInsets.only(top: 2, bottom: 5),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(colors: AppColors.gradientColor.colors),
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
      ),
    );
  }
}
