import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freelancing_platform/core/widgets/custom_date_field.dart';
import 'package:freelancing_platform/core/widgets/custom_loading.dart';
import 'package:freelancing_platform/views/user_request_section/request_controller/freelancer_request_controller.dart';
import 'package:get/get.dart';

class CertificateItemWidget extends StatelessWidget {
  final int index;
  CertificateItemWidget({super.key, required this.index});

  final controller = Get.find<FreelancerRequestController>();

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

      final file = item["localImage"] as File?;
      final uploading = item["uploading"] == true;

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
                    await controller.pickAndUploadImage(index, "certificate");
                    // String url = await controller.uploadImage();
                    // item["image"] = url;
                    // controller.validateCertificate(index);
                    // controller.certItems.refresh();
                  },
                  child: Container(
                    width: 70,
                    height: 70,
                    color: Colors.grey.shade200,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        if (file != null)
                          Image.file(file, fit: BoxFit.cover)
                        else if (imageUrl.isNotEmpty)
                          CachedNetworkImage(
                            imageUrl: imageUrl,
                            placeholder: (context, url) =>
                                const CustomLoading(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                            fit: BoxFit.cover,
                          )
                        else
                          const Icon(Icons.add_a_photo),
                        if (uploading) const CustomLoading(),
                      ],
                    ),
                    // child: imageUrl.isEmpty
                    //     ? Icon(Icons.add_a_photo)
                    //     : Image.network(imageUrl, fit: BoxFit.cover),
                  ),
                ),

                SizedBox(width: 12),

                // عنوان
                Expanded(
                  child: TextFormField(
                    initialValue: item["title"] as String,
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
                  onPressed: (controller.certItems.length < 3)
                      ? () {}
                      : () => controller.removeCertificateItem(index),
                ),
              ],
            ),

            TextFormField(
              initialValue: item["description"] as String,
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
              CustomDateField(
                  label: " تاريخ الحصول",
                  value: item["date"] as Timestamp?,
                  onChanged: (ts) {
                    controller.certItems[index]["date"] = ts;
                    controller.certItems.refresh();
                  }),
              TextFormField(
                initialValue: item["source"] as String?,
                decoration: InputDecoration(labelText: "مصدر الشهادة"),
                onChanged: (v) => item["source"] = v,
              ),
              TextFormField(
                initialValue: item["url"] as String,
                decoration: InputDecoration(labelText: "رابط التحقق"),
                onChanged: (v) => item["url"] = v,
              ),
              TextFormField(
                initialValue: item["id"] as String,
                decoration: InputDecoration(labelText: "رقم التحقق"),
                onChanged: (v) => item["id"] = v,
              ),
              SizedBox(height: 8),
              Text("المهارات المرتبطة:",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Wrap(
                spacing: 8,
                children: controller.selectedSkills.map((skill) {
                  final selected = skills.contains(skill);
                  return ChoiceChip(
                    label: Text(skill),
                    selected: selected,
                    onSelected: (_) =>
                        controller.toggleRelatedSkill(index, skill),
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
