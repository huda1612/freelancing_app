import 'package:flutter/material.dart';
import 'package:freelancing_platform/views/user_request_section/freelancer_request/freelancer_request_controller/skill_controller.dart';
import 'package:freelancing_platform/views/user_request_section/freelancer_request/freelancer_request_widgets/skill_tile.dart';
import 'package:get/get.dart';

class ProfileSkillsScreen extends StatelessWidget {
  ProfileSkillsScreen({super.key});

  final SkillController controller = Get.put(SkillController());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("الملف المهني"),
          bottom: const TabBar(
            tabs: [
              Tab(text: "المعلومات"),
              Tab(text: "المهارات"),
            ],
          ),
        ),

        body: TabBarView(
          children: [
            // ---------------------- Tab 1 ----------------------
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      labelText: "التخصص",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: "المسمى الوظيفي",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: "نبذة",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),

            // ---------------------- Tab 2 ----------------------
           Obx(() {
  return ListView.builder(
    padding: const EdgeInsets.all(16),
    itemCount: controller.skills.length,
    itemBuilder: (context, index) {
      final skill = controller.skills[index];

      return SkillTile(
        title: skill.name,
        subSkills: skill.subSkills,
        isExpanded: skill.expanded,
        selectedSubSkills: skill.selectedSubSkills,
        onToggle: () => controller.toggleSkill(index),
        onSubSkillToggle: (sub) => controller.toggleSubSkill(index, sub),
      );
    },
  );
})

          ],
        ),
      ),
    );
  }
}
