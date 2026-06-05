import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freelancing_platform/core/classes/app_date_formatter.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/constants/app_input_styles.dart';
import 'package:freelancing_platform/core/constants/app_spaces.dart';
import 'package:freelancing_platform/core/constants/app_text_styles.dart';
import 'package:freelancing_platform/core/constants/data_constsnats/task_status.dart';
import 'package:freelancing_platform/core/widgets/custom_app_bar.dart';
import 'package:freelancing_platform/core/widgets/custom_bottom_sheet_container.dart';
import 'package:freelancing_platform/core/widgets/custom_button.dart';
import 'package:freelancing_platform/core/widgets/custom_error_widget.dart';
import 'package:freelancing_platform/core/widgets/custom_rating_widget.dart';
import 'package:freelancing_platform/core/widgets/custom_text_field.dart';
import 'package:freelancing_platform/core/widgets/get_rerponse_handler.dart';
import 'package:freelancing_platform/models/project_collections/offer_model.dart';
import 'package:freelancing_platform/models/project_collections/project_model.dart';
import 'package:freelancing_platform/models/project_collections/task_model.dart';
import 'package:freelancing_platform/views/project_section/project_controller/active_project_controller.dart';
import 'package:freelancing_platform/views/project_section/project_widgets/project_deadline_widget.dart';
import 'package:freelancing_platform/views/project_section/project_widgets/project_partner_header.dart';
import 'package:freelancing_platform/views/project_section/project_widgets/project_section_card.dart';
import 'package:freelancing_platform/views/project_section/project_widgets/project_summary_section.dart';
import 'package:freelancing_platform/views/project_section/project_widgets/project_task_row.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

const Color _softPurple = Color(0xffA99CFF);

class ActiveProjectView extends GetView<ActiveProjectController> {
  const ActiveProjectView({super.key});

  @override
  Widget build(BuildContext context) {
    final tasksSectionKey = GlobalKey();
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: CustomAppBar(
          title: 'المشروع',
          trailingIcon: controller.isClient
              ? Obx(() {
                  return // الثلاث نقاط
                      controller.canCencelProject.value &&
                              !controller.cancelIsLoading.value
                          ? PopupMenuButton(
                              color: Colors.grey.shade100,
                              icon: const Icon(Icons.more_vert,
                                  color: AppColors.white),
                              position: PopupMenuPosition.under,
                              onSelected: (value) {
                                if (value == "cancel") {
                                  Get.bottomSheet(
                                    _cancelReasonBottomSheet(),
                                  );
                                }
                              },
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  value: "cancel",
                                  child: Row(
                                    children: [
                                      Icon(Icons.delete,
                                          color: Colors.red, size: 18),
                                      SizedBox(width: 8),
                                      Text("إلغاء المشروع"),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : SizedBox.shrink();
                })
              : null,
          backgroundGradient: AppColors.gradientColor,
        ),
        body: Obx(() {
          final project = controller.project;
          final offer = controller.offer;

          // if (project == null || offer == null) {
          //   return const Center(
          //     child: CustomErrorWidget(message: 'تعذر تحميل البيانات'),
          //   );
          // }

          return ModalProgressHUD(
            inAsyncCall: controller.cancelIsLoading.value,
            child: UiStateHandler(
              status: controller.pageState.value,
              fetchDataFun: controller.initPage,
              child: project == null
                  ? CustomErrorWidget(message: 'تعذر تحميل البيانات')
                  : RefreshIndicator(
                      onRefresh: controller.loadTasks,
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.all(AppSpaces.paddingMedium),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (controller.pendingTasksForApprovalCount > 0 &&
                                controller.isClient)
                              Padding(
                                padding: EdgeInsets.only(bottom: 12.h),
                                child: _pendingTaskApprovalBanner(
                                    pendingTasksCount:
                                        controller.pendingTasksForApprovalCount,
                                    onTap: () {
                                      final context =
                                          tasksSectionKey.currentContext;

                                      if (context != null) {
                                        Scrollable.ensureVisible(
                                          context,
                                          duration:
                                              const Duration(milliseconds: 500),
                                          curve: Curves.easeInOut,
                                        );
                                      }
                                    }),
                              ),

                            //project summary
                            ProjectSummarySection(
                              status: controller.project!.status,
                              cancelReason: controller.project!.cancelReason,
                              progress: controller.progress,
                              tasksCount: controller.tasks.length,
                              completedTasksCount:
                                  controller.completedTasksCount,
                              extraTasksCount: controller.extraTasksCount,
                              completedExtraTasksCount:
                                  controller.completedExtraTasksCount,
                              totalAmount: controller.totalAmount,
                              paidAmount: controller.paidAmount,
                              deadlineWidget: (controller.isInProgress ||
                                          controller.isReadyToComplete) &&
                                      controller.project!.startAt != null &&
                                      controller.offer != null
                                  ? ProjectDeadlineWidget(
                                      totalDays: offer!.durationDays,
                                      acceptedAt:
                                          controller.project!.startAt!.toDate(),
                                    )
                                  : SizedBox.shrink(),
                              showRating: controller.isComplete ||
                                  (controller.isCanceled &&
                                      controller.isMainTasksAbove75Percent),
                              isRated: controller.isRated,
                              ratingIsLoading: controller.ratingIsLoading.value,
                              onRatingTap: () async {
                                if (controller.isRated &&
                                    controller.myRating.value == null) {
                                  await controller.onViewRate();
                                }
                                Get.bottomSheet(CustomBottomSheetContainer(
                                    padding: 0,
                                    children: [
                                      CustomRatingWidget(
                                          ratingModel: !controller.isRated
                                              ? null
                                              : controller.myRating.value,
                                          formattedDate: controller.myRating
                                                      .value?.createdAt !=
                                                  null
                                              ? AppDateFormatter.smartTime(
                                                  controller.myRating.value
                                                      ?.createdAt)
                                              : null,
                                          projectName:
                                              controller.project!.title,
                                          projectStatus:
                                              controller.project!.status,
                                          category:
                                              controller.project!.category.name,
                                          onRatingSubmit:
                                              controller.onRatingSubmit,
                                          isLoading:
                                              controller.ratingIsLoading.value)
                                    ]));
                              },
                              partnerMiniProfile: ProjectPartnerHeader(
                                partnerType: controller.isClient
                                    ? "Freelancer"
                                    : "Client",
                                displayName:
                                    controller.partnerName.value.isNotEmpty
                                        ? controller.partnerName.value
                                        : 'unknown',
                                isLoading: controller.partnerLoading.value,
                                onViewProfile: controller.openPartnerProfile,
                              ),
                            ),

                            //project details
                            ProjectSectionCard(
                              child: ExpansionTile(
                                shape: const Border(), //  يشيل الخط العلوي
                                collapsedShape:
                                    const Border(), //  يشيل الخط السفلي
                                title: Text(
                                  "تفاصيل المشروع",
                                  style: AppTextStyles.subheading
                                      .copyWith(color: AppColors.darkPurple),
                                ),
                                leading: Icon(
                                  Icons.work_outline_rounded,
                                  color: AppColors.darkPurple,
                                ),
                                children: _projectInfoSections(project),
                              ),
                            ),
                            SizedBox(height: 8.h),
                            //offer details
                            if (controller.offer != null)
                              ProjectSectionCard(
                                child: ExpansionTile(
                                  shape: const Border(),
                                  collapsedShape: const Border(),
                                  title: Text(
                                    "تفاصيل العرض",
                                    style: AppTextStyles.subheading
                                        .copyWith(color: AppColors.darkPurple),
                                  ),
                                  leading: Icon(
                                    Icons.description_outlined,
                                    color: AppColors.darkPurple,
                                  ),
                                  children: [
                                    ..._offertInfoSections(offer!),
                                  ],
                                ),
                              ),
                            Container(
                                key: tasksSectionKey, child: _tasksSection()),
                            SizedBox(height: AppSpaces.heightSmall),
                            if (controller.isReadyToComplete &&
                                controller.autoCompleteRemainingTime != null &&
                                controller.isClient)
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "تنبيه : سيتم انهاء المشروع تلقائيا خلال ${controller.autoCompleteRemainingTime}",
                                  style: AppTextStyles.link
                                      .copyWith(color: AppColors.red),
                                ),
                              ),
                            _actionButtons(),
                            if (controller.isReadyToComplete &&
                                // controller.autoCompleteRemainingTime != null &&
                                controller.isFreelancer) ...[
                              SizedBox(height: AppSpaces.heightSmall),
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "ملاحظة : سيتم انهاء المشروع تلقائيا خلال ${controller.autoCompleteRemainingTime}",
                                  style: AppTextStyles.link.copyWith(
                                      color: AppColors.grey, fontSize: 14.sp),
                                ),
                              ),
                            ],
                            SizedBox(height: AppSpaces.heightSmall),
                          ],
                        ),
                      ),
                    ),
            ),
          );
        }),
      ),
    );
  }

  List<Widget> _projectInfoSections(ProjectModel project) {
    return [
      ProjectSectionCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ProjectSectionTitle('عنوان المشروع'),
            SizedBox(height: AppSpaces.heightSmall),
            Text(
              project.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      ProjectSectionCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ProjectSectionTitle('وصف المشروع'),
            SizedBox(height: AppSpaces.heightSmall),
            Text(
              project.description,
              style: const TextStyle(height: 1.7, fontSize: 15),
            ),
          ],
        ),
      ),
      ProjectSectionCard(
        child: ProjectInfoRow(
          icon: Icons.attach_money,
          title: 'الميزانية',
          value: project.budget.toStringAsFixed(0),
        ),
      ),
      ProjectSectionCard(
        child: ProjectInfoRow(
          icon: Icons.timer,
          title: 'مدة التنفيذ',
          value: '${project.durationDays} يوم',
        ),
      ),
      ProjectSectionCard(
        child: ProjectInfoRow(
          icon: Icons.category_outlined,
          title: 'التصنيف',
          value: project.category.name,
        ),
      ),
      if (project.skillsRequired.isNotEmpty)
        ProjectSectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ProjectSectionTitle('المهارات المطلوبة'),
              SizedBox(height: AppSpaces.heightSmall),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: project.skillsRequired
                    .map(
                      (skill) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: _softPurple.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          skill,
                          style: const TextStyle(
                            color: AppColors.purple,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
    ];
  }

  List<Widget> _offertInfoSections(OfferModel offer) {
    return [
      ProjectSectionCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ProjectSectionTitle('تفاصيل العرض'),
            SizedBox(height: AppSpaces.heightSmall),
            Text(
              offer.proposalText,
              style: const TextStyle(height: 1.7, fontSize: 15),
            ),
          ],
        ),
      ),
      ProjectSectionCard(
        child: ProjectInfoRow(
          icon: Icons.attach_money,
          title: 'الميزانية',
          value: offer.price.toStringAsFixed(0),
        ),
      ),
      ProjectSectionCard(
        child: ProjectInfoRow(
          icon: Icons.timer,
          title: 'مدة التنفيذ',
          value: '${offer.durationDays} يوم',
        ),
      ),
    ];
  }

  Widget _tasksSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //task section header
        Row(
          children: [
            const Expanded(
              child: ProjectSectionTitle('قائمة المهام'),
            ),
            if (controller.iswaitingTasksApproval)
              Text(
                "(في انتظار الموافقة على المهام)",
                style: AppTextStyles.link.copyWith(color: AppColors.red),
              ),
            if (controller.canAddBasTask)
              IconButton(
                onPressed: controller.onAddNewTask,
                icon:
                    const Icon(Icons.add_circle, color: AppColors.vividPurple),
                tooltip: 'إضافة مهمة',
              ),
            if (controller.canManageExtraTasks)
              TextButton.icon(
                  onPressed: controller.onAddExtraTasks,
                  label: Text(
                    "طلب مهمة اضافية",
                    style: AppTextStyles.link,
                  ))
          ],
        ),
        SizedBox(height: 8.h),
        //task section tasks
        Obx(() {
          // empty masseges
          if (controller.isSetup &&
                  controller.setupTasks.isEmpty &&
                  controller.canAddBasTask
              // controller.canEditTasks
              ) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              child: Text(
                'اضغط + لإضافة أول مهمة',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            );
          }

          if (controller.isSetup &&
              !controller.canEditTasks &&
              controller.tasks.isEmpty) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              child: Text(
                'لا توجد مهام بعد ، بانتظار اضافة المهام',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            );
          }

          //اذا ولا وحده من اللي فوق وكمان مافي اي تاسك
          if (controller.tasks.isEmpty && controller.extraTasks.isEmpty) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              child: Text(
                "لا يوجد مهام ، لم يتم تحديدها",
                style: TextStyle(color: Colors.grey.shade600),
              ),
            );
          }

          //tasks
          return Column(children: [
            if (!controller.isSetup)
              ...List.generate(
                controller.tasks.length,
                (index) {
                  final task = controller.tasks[index];

                  return ProjectTaskRow(
                    orderNumber: index + 1,
                    task: task,
                    isLoading: controller.isTaskLoading(task.id),
                    showEndTaskButton: controller.canEditTasks,
                    onEndTask: () => controller.onFreelancerEndTask(
                        taskId: task.id, index: index, isExtra: false),
                    showApproveButtons:
                        task.status == TaskStatus.completedByFreelancer &&
                            controller.isClient,
                    onApproveTask: () => controller.onClientApproveTask(
                        taskId: task.id, index: index, isExtra: false),
                    onRejectTask: () => controller.onClientRejectTask(
                        taskId: task.id, index: index, isExtra: false),
                    rejectReasonController: controller.rejectReasonController,
                    projectStatus: controller.project!.status,
                  );
                },
              )
            else if (controller.isSetup && controller.isFreelancer)
              ...List.generate(
                controller.setupTasks.length,
                (index) {
                  final setupTask = controller.setupTasks[index];
                  return _newTaskRow(setupTask, index);
                },
              ),
            if (controller.isSetup && controller.isClient)
              Text(
                "في انتظار اعادة تعيين المهام",
                style: AppTextStyles.subheading.copyWith(color: AppColors.grey),
              ),
            if (controller.extraTasks.isNotEmpty ||
                controller.extraTasksControllers.isNotEmpty)
              ..._extraTasksSection()
          ]);
        }),
      ],
    );
    // );
  }

  List<Widget> _extraTasksSection() {
    return [
      // Divider(
      //   thickness: 1,
      //   color: AppColors.normalGrey,
      // ),
      SizedBox(
        height: AppSpaces.heightSmall,
      ),
      Align(
          alignment: Alignment.topRight,
          child: ProjectSectionTitle('المهام الإضافية')),
      SizedBox(
        height: AppSpaces.heightSmall,
      ),
      ...List.generate(controller.extraTasks.length, (index) {
        TaskModel extraTask = controller.extraTasks[index];
        return ProjectTaskRow(
          orderNumber: index + 1,
          task: extraTask,
          isLoading: controller.isTaskLoading(extraTask.id),
          showEndTaskButton: controller.canEditTasks &&
              extraTask.status != TaskStatus.requested,
          onEndTask: () => controller.onFreelancerEndTask(
              taskId: extraTask.id, index: index, isExtra: true),
          showApproveButtons:
              extraTask.status == TaskStatus.completedByFreelancer &&
                  controller.isClient,
          onApproveTask: () => controller.onClientApproveTask(
              taskId: extraTask.id, index: index, isExtra: true),
          onRejectTask: () => controller.onClientRejectTask(
              taskId: extraTask.id, index: index, isExtra: true),
          rejectReasonController: controller.rejectReasonController,
          projectStatus: controller.project!.status,
          onCencelRequestedTask: () => controller.onCancelOrRejectRequestedTask(
              taskId: extraTask.id,
              taskDescription: extraTask.description,
              isCencel: true),
          onRejectRequestedTask: () => controller.onCancelOrRejectRequestedTask(
              taskId: extraTask.id,
              taskDescription: extraTask.description,
              isCencel: false),
          onApproveRequestedTask: () => controller.onApproveRequestedTask(
            taskId: extraTask.id,
            taskDescription: extraTask.description,
          ),
        );
      }),
      SizedBox(
        height: AppSpaces.heightSmall,
      ),
      ...List.generate(controller.extraTasksControllers.length, (index) {
        SetupTaskInput extraTasksController =
            controller.extraTasksControllers[index];
        return _newTaskRow(extraTasksController, index, isExtra: true);
      })
    ];
  }

  Widget _newTaskRow(SetupTaskInput setupTask, int index,
      {bool isExtra = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 14.h),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: TextFormField(
              minLines: 1,
              maxLines: 4,
              controller: setupTask.descriptionController,
              decoration: unifiedDecoration("وصف المهمة"),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            flex: 2,
            child: TextFormField(
              controller: setupTask.amountController,
              keyboardType: TextInputType.number,
              decoration: unifiedDecoration("المبلغ"),
              onChanged: (_) {
                controller.setupTasks.refresh();
              },
            ),
          ),
          IconButton(
            onPressed: () {
              setupTask.descriptionController.dispose();
              setupTask.amountController.dispose();
              !isExtra
                  ? controller.setupTasks.removeAt(index)
                  : controller.extraTasksControllers.removeAt(index);
            },
            icon: Icon(
              Icons.delete_outline_rounded,
              color: Colors.red,
              size: 22.sp,
            ),
          ),
          if (isExtra)
            IconButton(
              onPressed: () => controller.onRequestExtraTask(index),
              icon: Icon(
                Icons.check,
                color: Colors.green,
                size: 22.sp,
              ),
            )
        ],
      ),
    );
  }

  Widget _actionButtons() {
    return Obx(() {
      if (controller.isSetup && controller.isFreelancer) {
        return Column(
          children: [
            Obx(() {
              return Text(
                '${controller.tasksTotalAmount}\$ / ${controller.offer?.price ?? 0}\$',
                style: AppTextStyles.link,
              );
            }),
            CustomButton(
              text: 'ارسال المهام',
              onTap: controller.sendTasks,
              isDisable: !controller.canSendTasks,
              isLoading: controller.actionLoading.value,
              gradient: AppColors.gradientColor,
              prefix: const Icon(Icons.check_circle_outline,
                  color: AppColors.white),
            ),
          ],
        );
      }
      if (controller.iswaitingTasksApproval && controller.isClient) {
        return Row(
          children: [
            Expanded(
              child: CustomButton(
                text: 'الموافقة على المهام',
                onTap: controller.approveProjectTasks,
                isLoading: controller.actionLoading.value,
                gradient: AppColors.gradientColor,
                prefix: const Icon(Icons.check_circle_outline,
                    color: AppColors.white),
              ),
            ),
            SizedBox(
              width: 8.w,
            ),
            Expanded(
              child: CustomButton(
                text: 'رفض المهام',
                textStyle: AppTextStyles.button.copyWith(color: AppColors.red),
                onTap: controller.rejectProjectTasks,
                isLoading: controller.actionLoading.value,
                // gradient: AppColors.gradientColor,
                prefix: const Icon(Icons.cancel_outlined, color: AppColors.red),
                buttonType: ButtonType.outlined,
              ),
            ),
          ],
        );
      }
      // if (controller.iswaitingTasksApproval && controller.isFreelancer) {
      //   return Align(
      //     alignment: Alignment.center,
      //     child: Text(
      //       "في انتظار موافقة العميل على المهام",
      //       style:
      //           AppTextStyles.blacksubheading.copyWith(color: AppColors.grey),
      //     ),
      //   );
      // }
      // final _ = controller.actionLoading.value;

      if (controller.canCompleteProject) {
        return CustomButton(
          text: 'إنهاء المشروع',
          onTap: () {
            Get.defaultDialog(
              title: "انهاء المشروع",
              content: Text("هل انت متأكد من انهاء المشروع ؟ "),
              textConfirm: "إنهاء",
              textCancel: "إلغاء",
              onConfirm: controller.completeProject,
              onCancel: () => Get.back(),
            );
          },
          //  controller.completeProject,
          isLoading: controller.actionLoading.value,
          gradient: AppColors.gradientColor,
          prefix:
              const Icon(Icons.check_circle_outline, color: AppColors.white),
        );
      }

      if (controller.isReadyToComplete && controller.isFreelancer) {
        return Align(
          alignment: Alignment.center,
          child: Text('تم التسليم — بانتظار انهاء المشروع',
              textAlign: TextAlign.center,
              style: AppTextStyles.blacksubheading
                  .copyWith(color: AppColors.grey)),
        );
      }

      return const SizedBox.shrink();
    });
  }

  Widget _cancelReasonBottomSheet() {
    return CustomBottomSheetContainer(
      children: [
        Text(" إلغاء المشروع", style: AppTextStyles.heading),
        SizedBox(
          height: AppSpaces.heightSmall,
        ),
        Text(
          "انت على وشك إلغاء المشروع قبل اكتماله، الرجاء ادخال سبب الإلغاء :",
          style: AppTextStyles.body.copyWith(color: AppColors.black),
        ),
        SizedBox(
          height: AppSpaces.heightMedium,
        ),
        Align(
          alignment: Alignment.topRight,
          child: Text(
            "السبب (اختياري)",
            style:
                AppTextStyles.inputLabel.copyWith(color: AppColors.lightPurple),
          ),
        ),
        CustomTextField(
          controller: controller.projectCancelReasonController,
        ),
        SizedBox(
          height: AppSpaces.heightMedium,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomButton(
              width: 100.w,
              text: "إلغاء المشروع",
              onTap: controller.cancelProject,
              color: AppColors.red,
            ),
            SizedBox(
              width: AppSpaces.heightMedium2,
            ),
            CustomButton(
              textStyle: AppTextStyles.button.copyWith(color: AppColors.purple),
              color: AppColors.white,
              width: 100.w,
              text: "تراجع",
              onTap: () => Get.back(),
            ),
          ],
        )
      ],
    );
  }
}

Widget _pendingTaskApprovalBanner(
    {required int pendingTasksCount, required VoidCallback? onTap}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpaces.paddingSmall),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.orange.withOpacity(0.4),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.pending_actions_rounded,
            color: Colors.orange,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              pendingTasksCount == 1
                  ? 'يوجد مهمة بانتظار موافقتك على إنهائها'
                  : 'يوجد $pendingTasksCount مهام بانتظار موافقتك على إنهائها',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Icon(
            Icons.keyboard_arrow_down_outlined,
            size: 16,
            color: Colors.orange,
          ),
        ],
      ),
    ),
  );
}
