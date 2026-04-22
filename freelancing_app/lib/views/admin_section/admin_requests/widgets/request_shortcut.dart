import 'package:flutter/material.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/constants/app_spaces.dart';
import 'package:freelancing_platform/models/user_collections/users_requests_model.dart';
import 'package:freelancing_platform/views/admin_section/admin_requests/widgets/request_type.dart';

class RequestShortcut extends StatelessWidget {
  final String id;
  final RequestStatus requestStatus;
  final String usrename;
  final VoidCallback? onTab;

  final String date;
  const RequestShortcut({
    super.key,
    required this.id,
    required this.requestStatus,
    required this.usrename,
    required this.onTab,
    required this.date,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTab,
      child: Container(
        padding: EdgeInsets.all(AppSpaces.paddingMedium),
        margin: EdgeInsets.only(
            top: AppSpaces.marginMedium,
            left: AppSpaces.marginMedium,
            right: AppSpaces.marginMedium),
        decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppSpaces.radiusSmall),
            border: Border.all(color: AppColors.grey)),
        child: Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              RequestType(
                requestStatus,
              ),
              Text(
                "created At : day/month/year",
              ),
            ]),
            Divider(
              color: AppColors.grey,
              thickness: 1,
            ),
            Row(
              children: [Icon(Icons.list_alt), Text(usrename)],
            )
          ],
        ),
      ),
    );
  }
}
