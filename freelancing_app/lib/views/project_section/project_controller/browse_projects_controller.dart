import 'package:dartz/dartz.dart';
import 'package:freelancing_platform/core/classes/status_classes.dart';
import 'package:freelancing_platform/data/project_service.dart';
import 'package:freelancing_platform/data/services/specializations_skills_service.dart';
import 'package:freelancing_platform/models/project_collections/project_model.dart';
import 'package:freelancing_platform/models/skill_collections/specialization_model.dart';
import 'package:get/get.dart';

class BrowseProjectsController extends GetxController {
  final ProjectService _projectService = ProjectService();
  final SpecialSkillsService _specialSkillsService = SpecialSkillsService();

  final pageState = StatusClasses.isloading.obs;
  final projects = <ProjectModel>[].obs;
  /// قائمة الاختصاصات من Firebase (نفس مصدر صفحة إنشاء المشروع).
  final allSpecializations = <SpecializationModel>[].obs;
  final searchQuery = ''.obs;
  final selectedSpecialization = RxnString();

  List<ProjectModel> get filteredProjects {
    final query = searchQuery.value.trim().toLowerCase();
    final specializationFilter = selectedSpecialization.value;

    return projects.where((project) {
      final matchesSpecialization = specializationFilter == null ||
          specializationFilter.isEmpty ||
          project.specialization == specializationFilter;
      if (!matchesSpecialization) return false;

      if (query.isEmpty) return true;

      final title = project.title.toLowerCase();
      final description = project.description.toLowerCase();
      final specialization = project.specialization.toLowerCase();
      final skills = project.skillsRequired.map((e) => e.toLowerCase());

      return title.contains(query) ||
          description.contains(query) ||
          specialization.contains(query) ||
          skills.any((skill) => skill.contains(query));
    }).toList();
  }

  @override
  void onInit() {
    super.onInit();
    fetchOpenProjects();
  }

  Future<void> fetchOpenProjects() async {
    pageState.value = StatusClasses.isloading;

    final Either<StatusClasses, List<ProjectModel>> projectsResponse =
        await _projectService.getOpenProjects();
    final Either<StatusClasses, List<SpecializationModel>> specsResponse =
        await _specialSkillsService.getAllSpecializations();

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

      if (selectedSpecialization.value != null &&
          !allSpecializations
              .any((s) => s.slug == selectedSpecialization.value)) {
        selectedSpecialization.value = null;
      }
      pageState.value = StatusClasses.success;
    });
  }

  void onSearchChanged(String value) {
    searchQuery.value = value;
  }

  void selectSpecializationFilter(String? specialization) {
    selectedSpecialization.value = specialization;
  }
}
