import 'package:flutter/cupertino.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/constants/app_spaces.dart';

class CustomBottomSheetContainer extends StatelessWidget {
  final List<Widget> children;
  const CustomBottomSheetContainer({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(AppSpaces.radiusLarge),
              topRight: Radius.circular(AppSpaces.radiusLarge)),
        ),
        child: Padding(
          padding: EdgeInsets.all(AppSpaces.paddingLarge),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            // SizedBox(
            //   height: AppSpaces.heightLarge,
            // ),
            ...children,
            // SizedBox(
            //   height: AppSpaces.heightLarge,
            // ),
          ]),
        ));
  }
}
