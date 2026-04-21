import 'package:freelancing_platform/models/skill_collections/new_skill_model.dart';

class SpecializationModel {
  final String name;
  final String slug; //ملاحظه : هاد نفسه الاي دي
  final List<SubspecialModel> subspecializations;

  SpecializationModel({
    required this.name,
    required this.slug,
    this.subspecializations = const [],
  });

  factory SpecializationModel.fromMap(
    Map<String, dynamic> map, {
    String? idSlug,
  }) {
    return SpecializationModel(
      name: map['name'] ?? '',
      slug: map['slug'] ?? idSlug ?? '',
      subspecializations: (map['subSpecializations'] as List<dynamic>? ?? [])
          .map<SubspecialModel>(
            (e) => SubspecialModel.fromMap(e),
          )
          .toList(),
    );
  }
}
