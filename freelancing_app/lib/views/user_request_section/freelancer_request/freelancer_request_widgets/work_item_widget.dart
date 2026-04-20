import 'package:flutter/material.dart';
import 'package:freelancing_platform/views/user_request_section/freelancer_request/freelancer_request_controller/work_cert_controller.dart';
import 'package:get/get.dart';


class WorkItemWidget extends StatelessWidget {
  final int index;
  WorkItemWidget({super.key, required this.index});

  final controller = Get.find<WorkCertController>();

  @override
  Widget build(BuildContext context) {
    

    return Obx(() {
      final item = controller.workItems[index];

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
                    controller.validateWork(index);
                    controller.workItems.refresh();
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
                    decoration: InputDecoration(labelText: "عنوان العمل"),
                    onChanged: (v) {
                      item["title"] = v;
                      controller.validateWork(index);
                    },
                  ),
                ),

                // حذف
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => controller.removeWorkItem(index),
                ),
              ],
            ),

            TextField(
              decoration: InputDecoration(labelText: "الوصف"),
              onChanged: (v) {
                item["description"] = v;
                controller.validateWork(index);
              },
            ),
          ],
        ),
      );
    });
  }
}
