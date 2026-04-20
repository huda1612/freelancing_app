import 'package:flutter/material.dart';
import 'package:freelancing_platform/views/user_request_section/freelancer_request/freelancer_request_controller/work_cert_controller.dart';
import 'package:get/get.dart';

class CertificateItemWidget extends StatelessWidget {
  final int index;
  CertificateItemWidget({super.key, required this.index});

  final controller = Get.find<WorkCertController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final item = controller.certItems[index];

      return Container(
        margin: EdgeInsets.only(bottom: 16),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: item["valid"] ? Colors.green : Colors.grey.shade300,
            width: item["valid"] ? 2 : 1,
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
                    child: item["image"] == ""
                        ? Icon(Icons.add_a_photo)
                        : Image.network(item["image"], fit: BoxFit.cover),
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
                child: Text(item["expanded"] ? "إخفاء التفاصيل" : "إظهار التفاصيل"),
              ),
            ),

            if (item["expanded"]) ...[
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
                  final selected = item["skills"].contains(skill);
                  return ChoiceChip(
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
