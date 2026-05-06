import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/constants/app_spaces.dart';
import 'package:freelancing_platform/views/skills_section/skills_widgets/selected_skills_box.dart';

class BottomSkillsBar extends StatelessWidget {
  final List<String> selectedSkills;
  final Function(String) toggleSelectSkill;
  final VoidCallback? onButtonPress;
  final String? buttonText;

  const BottomSkillsBar({
    super.key,
    required this.toggleSelectSkill,
    required this.selectedSkills,
    this.onButtonPress,
    this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    final hasSkills = selectedSkills.isNotEmpty;

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          AppSpaces.mediumHorizontalPadding,
          8.h,
          AppSpaces.mediumHorizontalPadding,
          12.h,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          textDirection: TextDirection.rtl,
          mainAxisAlignment:
              hasSkills ? MainAxisAlignment.start : MainAxisAlignment.end,
          children: [
            if (hasSkills) ...[
              Expanded(
                child: SelectedSkillsBox(
                  skills: selectedSkills.toList(),
                  onRemove: toggleSelectSkill,
                  maxContentHeight: 80,
                ),
              ),
              SizedBox(width: 10.w),
            ],
            ElevatedButton(
              onPressed: onButtonPress,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.vividPurple,
                padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                buttonText ?? 'حفظ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget _buildBottomSkillsBar(BuildContext context) {
//     return Obx(() {
//       final hasSkills = controller.selectedSkills.isNotEmpty;
//       return SafeArea(
//         top: false,
//         child: Padding(
//           padding: EdgeInsets.fromLTRB(
//             AppSpaces.mediumHorizontalPadding,
//             8.h,
//             AppSpaces.mediumHorizontalPadding,
//             12.h,
//           ),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             textDirection: TextDirection.rtl,
//             mainAxisAlignment:
//                 hasSkills ? MainAxisAlignment.start : MainAxisAlignment.end,
//             children: [
//               if (hasSkills) ...[
//                 Expanded(
//                   child: SelectedSkillsBox(
//                     skills: controller.selectedSkills.toList(),
//                     onRemove: controller.toggleSelectSkill,
//                     maxContentHeight: 80,
//                   ),
//                 ),
//                 SizedBox(width: 10.w),
//               ],
//               ElevatedButton(
//                 onPressed: controller.canSubmit
//                     ? () => controller.firstNextBottonOnPressed()
//                     : null,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppColors.vividPurple,
//                   padding:
//                       EdgeInsets.symmetric(horizontal: 40.w, vertical: 14.h),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 child: Text(
//                   'التالي',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 16.sp,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     });
//   }