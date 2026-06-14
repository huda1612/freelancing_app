import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:freelancing_platform/core/classes/status_classes.dart';
import 'package:freelancing_platform/core/constants/app_routes.dart';
import 'package:freelancing_platform/core/services/navigation_service.dart';
import 'package:freelancing_platform/data/services/project_service.dart';
import 'package:freelancing_platform/data/services/specializations_skills_service.dart';
import 'package:freelancing_platform/models/project_collections/project_model.dart';
import 'package:freelancing_platform/models/skill_collections/specialization_model.dart';
import 'package:get/get.dart';

class BrowseProjectsController extends GetxController {
  final pageState = StatusClasses.isloading.obs;
  final projects = <ProjectModel>[].obs;

  // قائمة الاختصاصات
  final allSpecializations = <SpecializationModel>[].obs;
  final searchQuery = ''.obs;
  final selectedSpecialization = RxnString();

  // هي بتحدد المشاريع اللي رح تظهر بالقائمه بالصفحه
  List<ProjectModel> get filteredProjects {
    final query = searchQuery.value.trim().toLowerCase();
    final specializationFilter = selectedSpecialization.value;

    return projects.where((project) {
      // اول شي بشوف اذا هالمشروع بوافق التخصص المختار ولا لا
      final matchesSpecialization = specializationFilter == null ||
          specializationFilter.isEmpty ||
          project.category.slug == specializationFilter;
      //لو ما بوافقه ما بدنا ياه
      if (!matchesSpecialization) return false;
      // لو بوافقه منكمل

      // اذا مافي شي مكتوب بالبحث فكل شي بوافق الاختصاص بدنا ياه
      if (query.isEmpty) return true;

      final title = project.title.toLowerCase();
      final description = project.description.toLowerCase();
      final category = project.category.name.toLowerCase();
      final skills = project.skillsRequired.map((e) => e.toLowerCase());
      // لو موجود كلمة البحث بالعنوان او الوصف او التصنيف او المهارات فبدنا ياه للمشروع
      return title.contains(query) ||
          description.contains(query) ||
          category.contains(query) ||
          skills.any((skill) => skill.contains(query));
    }).toList();
  }

  @override
  void onInit() {
    super.onInit();
    fetchOpenProjectAndSpec();
  }

  Future<void> fetchOpenProjectAndSpec() async {
    pageState.value = StatusClasses.isloading;

    final Either<StatusClasses, List<ProjectModel>> projectsResponse =
        await ProjectService().getOpenProjects();
    final Either<StatusClasses, List<SpecializationModel>> specsResponse =
        await SpecialSkillsService().getAllSpecializations();

    projectsResponse.fold((left) {
      pageState.value = left;
    }, (right) {
      right.sort((a, b) {
        final aMs = a.createdAt?.millisecondsSinceEpoch ?? 0;
        final bMs = b.createdAt?.millisecondsSinceEpoch ?? 0;
        return bMs.compareTo(aMs);
      });
      projects.assignAll(right);

      specsResponse.fold((_) {
        allSpecializations.clear();
      }, (specs) {
        final sorted = List<SpecializationModel>.from(specs)
          ..sort((a, b) => a.name.compareTo(b.name));
        allSpecializations.assignAll(sorted);
      });

      // if (selectedSpecialization.value != null &&
      //     !allSpecializations
      //         .any((s) => s.slug == selectedSpecialization.value)) {
      //   selectedSpecialization.value = null;
      // }
      pageState.value = StatusClasses.success;
    });
  }

  onProjectTab(ProjectModel project) async {
    final result = await NavigationService.toNamed(AppRoutes.projectDetails,
        arguments: {"project": project, "projectId": project.id});
    if (result == true) {
      await fetchOpenProjectAndSpec();
    }
  }

  void onSearchChanged(String value) {
    searchQuery.value = value;
  }

  void selectSpecializationFilter(String? specialization) {
    selectedSpecialization.value = specialization;
  }
}
