import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freelancing_platform/core/classes/user_session.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/constants/app_spaces.dart';
import 'package:freelancing_platform/core/constants/app_text_styles.dart';
import 'package:freelancing_platform/core/constants/data_constsnats/project_status.dart';
import 'package:freelancing_platform/core/constants/data_constsnats/task_status.dart';
import 'package:freelancing_platform/core/widgets/custom_bottom_sheet_container.dart';
import 'package:freelancing_platform/core/widgets/custom_button.dart';
import 'package:freelancing_platform/core/widgets/custom_loading.dart';
import 'package:freelancing_platform/core/widgets/custom_text_field.dart';
import 'package:freelancing_platform/models/project_collections/task_model.dart';
import 'package:freelancing_platform/views/project_section/project_widgets/status_container.dart';
import 'package:get/get.dart';

class ProjectTaskRow extends StatelessWidget {
  const ProjectTaskRow({
    super.key,
    required this.task,
    required this.orderNumber,
    this.projectStatus = ProjectStatus.inProgress,
    this.showEndTaskButton = false,
    this.showApproveButtons = false,
    this.isLoading = false,
    this.onEndTask,
    this.onApproveTask,
    this.onRejectTask,
    this.onApproveRequestedTask,
    this.onRejectRequestedTask,
    this.onCencelRequestedTask,
    this.rejectReasonController,
  });

  final TaskModel task;
  final int orderNumber;
  final String projectStatus;

  final bool showEndTaskButton;
  final bool showApproveButtons;
  final bool isLoading;

  final VoidCallback? onEndTask;
  final VoidCallback? onApproveTask;
  final VoidCallback? onRejectTask;

  final VoidCallback? onApproveRequestedTask;
  final VoidCallback? onRejectRequestedTask;
  final VoidCallback? onCencelRequestedTask;

  final TextEditingController? rejectReasonController;
  bool get isCompleted =>
      task.status == TaskStatus.completedByFreelancer ||
      task.status == TaskStatus.approved;
  Color get statusColor {
    switch (task.status) {
      case TaskStatus.approved:
        return AppColors.grey;
      case TaskStatus.pending:
        return Colors.green.withOpacity(.4);
      case TaskStatus.completedByFreelancer:
        return AppColors.lightPurple;
      case TaskStatus.requested:
        return AppColors.lightPurple;
      default:
        return AppColors.grey;
    }
  }

  Color get statusTextColor {
    switch (task.status) {
      case TaskStatus.approved:
        return AppColors.normalGrey;
      case TaskStatus.pending:
        return Colors.green;
      case TaskStatus.completedByFreelancer:
        return AppColors.vividPurple;
      case TaskStatus.requested:
        return AppColors.vividPurple;
      default:
        return AppColors.normalGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border(
            right: BorderSide(
              color: statusColor,
              width: 5,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.04),
              blurRadius: 8,
              offset: Offset(0, 2),
            )
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //علقت من هون
          /// Header
          // Row(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //     //number
          //     Container(
          //       width: 26.w,
          //       height: 26.w,
          //       decoration: BoxDecoration(
          //         color: AppColors.vividPurple.withOpacity(.1),
          //         shape: BoxShape.circle,
          //       ),
          //       child: Center(
          //         child: Text(
          //           "$orderNumber",
          //           style: TextStyle(
          //             fontSize: 12.sp,
          //             fontWeight: FontWeight.w600,
          //           ),
          //         ),
          //       ),
          //     ),
          //     // CircleAvatar(
          //     //   radius: 15.r,
          //     //   backgroundColor: AppColors.vividPurple.withOpacity(.15),
          //     //   child: Text(
          //     //     "$orderNumber",
          //     //     style: TextStyle(
          //     //       color: AppColors.vividPurple,
          //     //       fontWeight: FontWeight.bold,
          //     //       fontSize: 13.sp,
          //     //     ),
          //     //   ),
          //     // ),

          //     SizedBox(width: 10.w),

          //     /// Description + amount
          //     Expanded(
          //       child:

          //           Text(
          //         task.description,
          //         style: AppTextStyles.body.copyWith(
          //           decoration: isCompleted ? TextDecoration.lineThrough : null,
          //           color: isCompleted ? Colors.grey : AppColors.black,
          //         ),
          //       ),

          //       // Text(
          //       //   "${task.amount.toStringAsFixed(0)} \$",
          //       //   style: AppTextStyles.body.copyWith(
          //       //     fontWeight: FontWeight.bold,
          //       //     color:
          //       //         isCompleted ? Colors.grey : AppColors.vividPurple,
          //       //     decoration:
          //       //         isCompleted ? TextDecoration.lineThrough : null,
          //       //   ),
          //       // ),
          //       //   ],
          //       // ),
          //     ),
          //     Column(
          //       crossAxisAlignment: CrossAxisAlignment.end,
          //       children: [
          //         if (projectStatus != ProjectStatus.waitingTasksApproval)
          //           _buildStatusChip(),
          //         SizedBox(height: 10.h),
          //         _buildAmountChip()
          //       ],
          //     ),

          //     /// Status Chip
          //     // if (projectStatus != ProjectStatus.waitingTasksApproval)
          //     //   _buildStatusChip(),
          //   ],
          // ),
          // // SizedBox(height: 10.h),
          // // Row(
          // //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // //   children: [
          // //     _buildAmountChip(),
          // //     // if (projectStatus != ProjectStatus.waitingTasksApproval)
          // //     //   _buildStatusChip(),
          // //     // SizedBox(height: 10.h),
          // //   ],
          // // ),
          // if (task.status == TaskStatus.pending &&
          //     task.rejectionReason != null) ...[
          //   SizedBox(
          //     height: AppSpaces.heightSmall,
          //   ),
          //   Container(
          //     padding: EdgeInsets.all(8.w),
          //     decoration: BoxDecoration(
          //       color: Colors.red.withOpacity(.08),
          //       borderRadius: BorderRadius.circular(8.r),
          //       border: Border.all(color: Colors.red.withOpacity(.2)),
          //     ),
          //     child: Text(
          //       "سبب الرفض السابق : ${task.rejectionReason}",
          //       style: AppTextStyles.body.copyWith(
          //         color: Colors.red,
          //         fontSize: 12.sp,
          //       ),
          //     ),
          //   ),
          // ],
          //لهون
          //جديده :*****************
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "المهمة $orderNumber",
                style:
                    AppTextStyles.inputLabel.copyWith(color: statusTextColor),
              ),

              /// Status Chip
              if (projectStatus != ProjectStatus.waitingTasksApproval)
                _buildStatusChip(),
            ],
          ),
          Divider(
            color: statusTextColor,
          ),
          SizedBox(
            height: AppSpaces.heightSmall,
          ),
          Text(
            task.description,
            style: AppTextStyles.body.copyWith(
              decoration: isCompleted ? TextDecoration.lineThrough : null,
              color: isCompleted ? Colors.grey : AppColors.black,
            ),
          ),
          SizedBox(
            height: AppSpaces.heightSmall,
          ),
          // Align(alignment: Alignment.topLeft, child: _buildAmountChip()),
          Row(
            children: [
              Text(
                "القيمة : ",
                style: AppTextStyles.body.copyWith(
                  decoration: task.status == TaskStatus.approved
                      ? TextDecoration.lineThrough
                      : null,
                  color: isCompleted ? Colors.grey : AppColors.black,
                ),
              ),
              _buildAmountChip()
            ],
          ),
          if (task.status == TaskStatus.pending &&
              task.rejectionReason != null) ...[
            SizedBox(
              height: AppSpaces.heightSmall,
            ),
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(.08),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: Colors.red.withOpacity(.2)),
              ),
              child: Text(
                "سبب الرفض السابق : ${task.rejectionReason}",
                style: AppTextStyles.body.copyWith(
                  color: Colors.red,
                  fontSize: 12.sp,
                ),
              ),
            ),
          ],
          //لهون**************

          //************************action buttons****************
          //requested task state buttons
          if (showApproveButtons ||
              task.status == TaskStatus.requested ||
              (showEndTaskButton &&
                  !isCompleted &&
                  projectStatus != ProjectStatus.waitingTasksApproval))
            Divider(
              // height: 20.h,
              color: Colors.grey.shade200,
            ),
          if (!isLoading) ...[
            if (task.status == TaskStatus.requested &&
                task.requestedBy != UserSession.uid)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                      onPressed: onApproveRequestedTask,
                      child: Text(
                        "موافقه",
                        style: AppTextStyles.link.copyWith(
                            color: AppColors.vividPurple, fontSize: 14.sp),
                      )),
                  TextButton(
                      onPressed: onRejectRequestedTask,
                      child: Text(
                        "رفض",
                        style: AppTextStyles.link
                            .copyWith(color: AppColors.red, fontSize: 14.sp),
                      )),
                ],
              ),
            if (task.status == TaskStatus.requested &&
                task.requestedBy == UserSession.uid)
              Align(
                  alignment: Alignment.center,
                  child: TextButton(
                      onPressed: onCencelRequestedTask,
                      child: Text(
                        "إلغاء الطلب",
                        style: AppTextStyles.link
                            .copyWith(color: AppColors.red, fontSize: 14.sp),
                      ))),

            /// Actions
            if (showEndTaskButton &&
                !isCompleted &&
                projectStatus != ProjectStatus.waitingTasksApproval)
              Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: () => Get.defaultDialog(
                      title: "انهاء المهمة",
                      content: Text("هل انت متأكد من انهاء المهمة ؟ "),
                      onConfirm: onEndTask,
                      textConfirm: "انهاء",
                      textCancel: "إلغاء",
                      onCancel: () => Get.back(),
                    ),
                    child: Text(
                      "إنهاء",
                      style: AppTextStyles.link.copyWith(
                          color: Colors.green.shade700, fontSize: 14.sp),
                    ),
                    // icon: const Icon(
                    //   Icons.done,
                    //   size: 20,
                    //   color: AppColors.darkPurple,
                    // ),
                  )
                  // TextButton.icon(
                  //   onPressed: () => Get.defaultDialog(
                  //     title: "انهاء المهمة",
                  //     content: Text("هل انت متأكد من انهاء المهمة ؟ "),
                  //     onConfirm: onEndTask,
                  //     textConfirm: "انهاء",
                  //     textCancel: "إلغاء",
                  //     onCancel: () => Get.back(),
                  //   ),
                  //   // onEndTask,
                  //   icon: const Icon(
                  //     Icons.done,
                  //     size: 18,
                  //     color: AppColors.darkPurple,
                  //   ),
                  //   label: Text(
                  //     "إنهاء",
                  //     style: AppTextStyles.link.copyWith(
                  //       color: AppColors.darkPurple,
                  //     ),
                  //   ),
                  // )

                  ),

            if (showApproveButtons) ...[
              SizedBox(height: 12.h),
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: onApproveTask,
                      icon: const Icon(Icons.check),
                      label: const Text("موافقة"),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.darkPurple,
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onRejectTask != null
                          ? () => Get.bottomSheet(_rejectBottomSheet())
                          : null,
                      icon: const Icon(Icons.close),
                      label: const Text("رفض"),
                    ),
                  ),
                ],
              ),
            ],
          ] else
            CustomLoading()
        ],
      ),
    );
  }

  Widget _buildAmountChip() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10.w,
        vertical: 4.h,
      ),
      decoration: BoxDecoration(
        color: task.status == TaskStatus.approved
            ? Colors.grey.withOpacity(.1)
            : task.status == TaskStatus.pending
                ? AppColors.green.withOpacity(.1)
                : AppColors.vividPurple.withOpacity(.1),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        "${task.amount.toStringAsFixed(0)} \$",
        // style: TextStyle(
        //   color: AppColors.vividPurple,
        //   fontWeight: FontWeight.bold,
        // ),
        style: AppTextStyles.body.copyWith(
          fontSize: 14.sp,
          fontWeight: FontWeight.bold,
          color: task.status == TaskStatus.approved
              ? Colors.grey
              : task.status == TaskStatus.pending
                  ? Colors.green.shade700
                  : AppColors.vividPurple,
          decoration: task.status == TaskStatus.approved
              ? TextDecoration.lineThrough
              : null,
        ),
      ),
    );
  }

  Widget _rejectBottomSheet() {
    return CustomBottomSheetContainer(children: [
      Text("رفض انهاء المهمة", style: AppTextStyles.heading),
      Text(
        "انت على وشك رفض انهاء المهمة ، الرجاء ادخال سبب الرفض :",
        style: AppTextStyles.body.copyWith(color: AppColors.black),
      ),
      SizedBox(
        height: AppSpaces.heightMedium,
      ),
      Align(
        alignment: Alignment.topRight,
        child: Text(
          "سبب الرفض",
          style:
              AppTextStyles.inputLabel.copyWith(color: AppColors.lightPurple),
        ),
      ),
      CustomTextField(
        controller: rejectReasonController,
        // onChanged: (val) =>
        //     controller.rejectComment = val // hintText: "ادخل سبب الرفض",
      ),
      SizedBox(
        height: AppSpaces.heightMedium,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomButton(
            width: 100.w,
            text: "رفض",
            onTap: onRejectTask!,
            color: AppColors.red,
          ),
          SizedBox(
            width: AppSpaces.heightMedium2,
          ),
          CustomButton(
            textStyle: AppTextStyles.button.copyWith(color: AppColors.purple),
            color: AppColors.white,
            width: 100.w,
            text: "إلغاء",
            onTap: () {
              rejectReasonController?.text = '';
              Get.back();
            },
          ),
        ],
      )
    ]);
  }

  Widget _buildStatusChip() {
    Color bgColor;
    Color textColor;
    String text;

    switch (task.status) {
      case TaskStatus.completedByFreelancer:
        bgColor = AppColors.veryLightPurple;
        textColor = AppColors.darkPurple;
        text = "بانتظار الموافقة";
        break;

      case TaskStatus.approved:
        // bgColor = Colors.green.shade100;
        // textColor = Colors.green.shade800;
        bgColor = Colors.grey.shade200;
        textColor = Colors.grey.shade700;
        text = "منتهية";
        break;

      case TaskStatus.requested:
        bgColor = AppColors.veryLightPurple;
        textColor = AppColors.darkPurple;
        text = "بانتظار القبول";
        break;

      default:
        // bgColor = Colors.grey.shade200;
        // textColor = Colors.grey.shade700;
        bgColor = Colors.green.shade100;
        textColor = Colors.green.shade800;
        text = "قيد التنفيذ";
    }

    return StatusContainer(
      bgColor: bgColor,
      textColor: textColor,
      text: text,
    );
  }
}
