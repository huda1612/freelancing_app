import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:freelancing_platform/core/classes/status_classes.dart';
import 'package:freelancing_platform/core/classes/user_session.dart';
import 'package:freelancing_platform/core/constants/app_routes.dart';
import 'package:freelancing_platform/data/project_service.dart';
import 'package:freelancing_platform/data/services/specializations_skills_service.dart';
import 'package:freelancing_platform/models/project_collections/project_model.dart';
import 'package:freelancing_platform/models/skill_collections/specialization_model.dart';
import 'package:get/get.dart';

class CreateProjectController extends GetxController {
  static const int maxProjectSkills = 30;
  final formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final budgetController = TextEditingController();
  final durationController = TextEditingController();

  final pageState = StatusClasses.isloading.obs;
  final submitLoading = false.obs;
  final selectedSpecialization = RxnString();
  final selectedSkills = <String>[].obs;
  final allSpecializations = <SpecializationModel>[].obs;

  final SpecialSkillsService _specialSkillsService = SpecialSkillsService();
  final ProjectService _projectService = ProjectService();

  @override
  void onInit() {
    super.onInit();
    fetchSpecializations();
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    budgetController.dispose();
    durationController.dispose();
    super.onClose();
  }

  Future<void> fetchSpecializations() async {
    pageState.value = StatusClasses.isloading;
    final Either<StatusClasses, List<SpecializationModel>> response =
        await _specialSkillsService.getAllSpecializations();

    response.fold((left) {
      pageState.value = left;
    }, (right) {
      allSpecializations.value = right;
      pageState.value = StatusClasses.success;
    });
  }

  Future<void> openSkillsSelection() async {
    final slug = selectedSpecialization.value;
    if (slug == null || slug.isEmpty) {
      Get.snackbar('تنبيه', 'اختر التصنيف أولاً لاقتراح المهارات المناسبة');
      return;
    }

    final result = await Get.toNamed(
      AppRoutes.skillsSelection,
      arguments: {
        'oldSkills': selectedSkills.toList(),
        'specailization': slug,
      },
    );

    if (result is List) {
      final normalized = result.map((e) => e.toString()).toSet().toList();
      if (normalized.length > maxProjectSkills) {
        selectedSkills.value = normalized.take(maxProjectSkills).toList();
        Get.snackbar(
          'تنبيه',
          'الحد الأقصى للمهارات هو $maxProjectSkills مهارة',
        );
        return;
      }
      selectedSkills.value = normalized;
    }
  }

  void removeSkill(String skill) {
    selectedSkills.remove(skill);
  }

  String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName مطلوب';
    }
    return null;
  }

  String? validateBudget(String? value) {
    final emptyError = validateRequired(value, 'الميزانية');
    if (emptyError != null) return emptyError;
    // final parsed = double.tryParse(value!.trim());
    final parsed = double.tryParse(_normalizeNumbers(value!.trim()));
    if (parsed == null || parsed <= 0) {
      return 'الميزانية يجب أن تكون رقمًا أكبر من 0';
    }
    return null;
  }

  String? validateDuration(String? value) {
    final emptyError = validateRequired(value, 'مدة التنفيذ');
    if (emptyError != null) return emptyError;
    // final parsed = int.tryParse(value!.trim());
    final parsed = double.tryParse(_normalizeNumbers(value!.trim()));
    if (parsed == null || parsed <= 0) {
      return 'مدة التنفيذ يجب أن تكون رقمًا صحيحًا أكبر من 0';
    }
    return null;
  }

  Future<void> submitProject() async {
    final special = selectedSpecialization.value;
    if (special == null || special.isEmpty) {
      Get.snackbar('خطأ', 'يرجى اختيار تصنيف المشروع');
      return;
    }

    final isValid = formKey.currentState?.validate() ?? false;
    if (!isValid) {
      Get.snackbar('خطأ', 'يرجى تعبئة الحقول الإلزامية بشكل صحيح');
      return;
    }
    if (selectedSkills.isEmpty) {
      Get.snackbar('خطأ', 'اختر مهارة واحدة على الأقل');
      return;
    }
    if (selectedSkills.length > maxProjectSkills) {
      Get.snackbar('خطأ', 'لا يمكن اختيار أكثر من $maxProjectSkills مهارة');
      return;
    }

    if (UserSession.uid == null) {
      Get.snackbar('Unauthorized', 'يجب تسجيل الدخول أولاً');
      Get.offAllNamed(AppRoutes.login);
      return;
    }

    submitLoading.value = true;
    final project = ProjectModel(
      id: '',
      clientId: UserSession.uid!,
      title: titleController.text.trim(),
      description: descriptionController.text.trim(),
      skillsRequired: selectedSkills.toList(),
      budget: double.parse(_normalizeNumbers(budgetController.text.trim())),
      durationDays:
          int.parse(_normalizeNumbers(durationController.text.trim())),
      createdAt: null,
    );

    final response = await _projectService.addProject(project);
    submitLoading.value = false;

    if (response == StatusClasses.success) {
      Get.snackbar('نجاح', 'تم إنشاء المشروع بنجاح');
      _clearForm();
      return;
    }

    Get.snackbar('خطأ', response.message ?? 'فشل إنشاء المشروع');
  }

  String _normalizeNumbers(String input) {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

    for (int i = 0; i < arabic.length; i++) {
      input = input.replaceAll(arabic[i], english[i]);
    }

    return input;
  }

  void _clearForm() {
    titleController.clear();
    descriptionController.clear();
    budgetController.clear();
    durationController.clear();
    selectedSpecialization.value = null;
    selectedSkills.clear();
  }
}
