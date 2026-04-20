import 'package:flutter/material.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/constants/app_spaces.dart';
import 'package:freelancing_platform/core/widgets/base_screen.dart';
import 'package:freelancing_platform/core/widgets/custom_button.dart';
import 'package:freelancing_platform/core/widgets/get_rerponse_handler.dart';
import 'package:freelancing_platform/views/user_request_section/freelancer_request/freelancer_request_controller/request_controller.dart';
import 'package:freelancing_platform/views/user_request_section/shared_pages/shared_pages_controllers/entry_test_controller.dart';
import 'package:freelancing_platform/views/user_request_section/shared_pages/shared_pages_widgets/question_card.dart';
import 'package:get/get.dart';

class EntryTestView extends StatelessWidget {
  const EntryTestView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      body: SafeArea(
        child: GetBuilder<RequestController>(
            // init: EntryTestController(),
            init: Get.find<RequestController>(),
            builder: (controller) {
              return UiStateHandler(
                status: controller.testPageState,
                fetchDataFun: controller.fetchQuestions,
                child: Column(
                  children: [
                    // Header
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.person_search_rounded,
                          color: AppColors.purple,
                          size: 40,
                        ),
                      ),
                    ),

                    // Questions List
                    Expanded(
                      child: controller.questions.isEmpty
                          ? Text("لا يوجد اسئلة")
                          : Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: ListView.builder(
                                itemCount: controller.questions.length,
                                itemBuilder: (context, index) {
                                  return QuestionCard(
                                      question:
                                          controller.questions[index].question,
                                      options:
                                          controller.questions[index].options,
                                      selectedIndex:
                                          controller.answers[index] ?? -1,
                                      onOptionSelected: (selected) {
                                        controller.selectAnswer(
                                            index, selected);
                                      });
                                },
                              ),
                            ),
                    ),

                    // Next Button
                    Padding(
                      padding: EdgeInsets.all(AppSpaces.paddingLarge),
                      child: SizedBox(
                          width: double.infinity,
                          child: CustomButton(
                              text: "التالي", onTap: controller.istestCorrect)
                          // ElevatedButton(
                          //   onPressed: () {
                          //     // Handle next action
                          //   },
                          //   style: ElevatedButton.styleFrom(
                          //     backgroundColor: Colors.white,
                          //     foregroundColor: AppColors.purple,
                          //     padding: const EdgeInsets.symmetric(vertical: 16),
                          //     shape: RoundedRectangleBorder(
                          //       borderRadius: BorderRadius.circular(16),
                          //     ),
                          //     elevation: 2,
                          //   ),
                          //   child: const Text(
                          //     'التالي',
                          //     style: TextStyle(
                          //       fontSize: 18,
                          //       fontWeight: FontWeight.bold,
                          //     ),
                          //   ),
                          // ),
                          ),
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
