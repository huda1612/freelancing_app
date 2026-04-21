import 'package:flutter/material.dart';
import 'package:freelancing_platform/views/user_request_section/request_controller/work_cert_controller.dart';
import 'package:get/get.dart';

class CertificateItemWidget extends StatelessWidget {
  final int index;
  CertificateItemWidget({super.key, required this.index});

  final controller = Get.find<WorkCertController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (index < 0 || index >= controller.certItems.length) {
        return const SizedBox.shrink();
      }
      final item = controller.certItems[index];
       final isValid = item["valid"] == true;
      final isExpanded = item["expanded"] == true;
      final imageUrl = (item["image"] ?? "").toString();
      final skills = (item["skills"] as List?) ?? const [];


      return Container(
        margin: EdgeInsets.only(bottom: 16),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isValid ? Colors.green : Colors.grey.shade300,
            width: isValid ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                // صورة
                GestureDetector(
                  onTap: () async {
                    String url = await controller.uploadImage();
                    item["image"] = url;
                    controller.validateCertificate(index);
                    controller.certItems.refresh();
                  },
                  child: Container(
                    width: 70,
                    height: 70,
                    color: Colors.grey.shade200,
                    child: imageUrl.isEmpty
                        ? Icon(Icons.add_a_photo)
                        : Image.network(imageUrl, fit: BoxFit.cover),
                  ),
                ),

                SizedBox(width: 12),

                // عنوان
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(labelText: "عنوان الشهادة"),
                    onChanged: (v) {
                      item["title"] = v;
                      controller.validateCertificate(index);
                    },
                  ),
                ),

                // حذف
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => controller.removeCertificateItem(index),
                ),
              ],
            ),

            TextField(
              decoration: InputDecoration(labelText: "الوصف"),
              onChanged: (v) {
                item["description"] = v;
                controller.validateCertificate(index);
              },
            ),

            // زر التوسيع
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => controller.toggleExpand(index),
                child: Text(isExpanded ? "إخفاء التفاصيل" : "إظهار التفاصيل"),
              ),
            ),

             if (isExpanded) ...[
              TextField(
                decoration: InputDecoration(labelText: "تاريخ الحصول"),
                onChanged: (v) => item["date"] = v,
              ),
              TextField(
                decoration: InputDecoration(labelText: "رابط التحقق"),
                onChanged: (v) => item["url"] = v,
              ),
              TextField(
                decoration: InputDecoration(labelText: "رقم التحقق"),
                onChanged: (v) => item["id"] = v,
              ),

              SizedBox(height: 8),
              Text("المهارات المرتبطة:", style: TextStyle(fontWeight: FontWeight.bold)),

              Wrap(
                spacing: 8,
                children: controller.selectedSubSkills.map((skill) {
 final selected = skills.contains(skill);                   return ChoiceChip(
                    label: Text(skill),
                    selected: selected,
                    onSelected: (_) => controller.toggleSkill(index, skill),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      );
    });
  }
}
