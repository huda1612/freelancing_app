// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:freelancing_platform/core/classes/app_date_formatter.dart';
// import 'package:freelancing_platform/core/constants/app_colors.dart';
// import 'package:freelancing_platform/core/constants/app_spaces.dart';
// import 'package:freelancing_platform/core/constants/app_text_styles.dart';
// import 'package:freelancing_platform/core/widgets/custom_date_field.dart';
// import 'package:freelancing_platform/core/widgets/custom_loading.dart';
// import 'package:freelancing_platform/models/user_collections/certificate_model.dart';
// import 'package:freelancing_platform/views/profile_section/profile_widgets/certificate_skill_card.dart';

// class ProfileCertificateTile extends StatelessWidget {
//   const ProfileCertificateTile(
//       {super.key,
//       required this.certificate,
//       required this.isEditing,
//       this.isOwnProfile = false,
//       required this.onChanged,
//       required this.onEdit,
//       required this.onSave,
//       required this.onDelete,
//       this.date});

//   final CertificateModel certificate;
//   final bool isEditing;
//   final bool isOwnProfile;
//   final Timestamp? date;
//   final Function(String key, String value) onChanged;

//   final VoidCallback onEdit;
//   final VoidCallback onSave;
//   final VoidCallback onDelete;

//   @override
//   Widget build(BuildContext context) {
//     //متغير لعرض التاريخ بالحقل كشكل بس
//     // Timestamp? choosenDate = certificate.date ;
//     return Container(
//       margin: const EdgeInsets.only(bottom: 10),
//       decoration: BoxDecoration(
//         color: AppColors.owhite,
//         borderRadius: BorderRadius.circular(14),
//       ),
//       child: Theme(
//         data: ThemeData(dividerColor: Colors.transparent),
//         child: ExpansionTile(
//             expandedCrossAxisAlignment: CrossAxisAlignment.start,
//             tilePadding: const EdgeInsets.symmetric(
//                 horizontal: AppSpaces.smallHorizontalPadding,
//                 vertical: AppSpaces.smallVerticalSpacing),
//             childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
//             leading: _buildImage(),
//             // ================= TITLE =================
//             title: isEditing
//                 ? _editField(
//                     initialValue: certificate.title,
//                     onChanged: (v) => onChanged('title', v),
//                   )
//                 : Text(
//                     certificate.title,
//                     style: AppTextStyles.inputLabel
//                         .copyWith(color: AppColors.black),
//                   ),

//             // ================= SOURCE =================
//             subtitle: isEditing
//                 ? _editField(
//                     initialValue: certificate.source ?? '',
//                     onChanged: (v) => onChanged('source', v),
//                   )
//                 : Text(
//                     certificate.source ?? 'اضغط لعرض التفاصيل',
//                     style: AppTextStyles.link,
//                   ),
//             children: [
//               _section("الوصف", certificate.description, 'description'),
//               _section("رقم التحقق", certificate.credentialID, 'credentialID'),
//               _section(
//                   "رابط التحقق", certificate.credentialURL, 'credentialURL'),
//               const SizedBox(height: 6),

//               // Align(
//               //     alignment: Alignment.centerRight,
//               //     child: _titleText("الوصف :")),
//               // Text(
//               //   (certificate.description ?? '').isEmpty
//               //       ? 'لا يوجد تفاصيل متاحة.'
//               //       : certificate.description!,
//               //   style: AppTextStyles.body.copyWith(color: AppColors.black),
//               // // ),
//               // _titleText("رقم التحقق :"),
//               // Text(
//               //   (certificate.credentialID ?? '').isEmpty
//               //       ? 'لا يوجد رقم تحقق .'
//               //       : certificate.credentialID!,
//               //   style: AppTextStyles.body.copyWith(color: AppColors.black),
//               // ),
//               // _titleText("رابط التحقق :"),
//               // Text(
//               //   (certificate.credentialURL ?? '').isEmpty
//               //       ? 'لا يوجد رابط تحقق .'
//               //       : certificate.credentialURL!,
//               //   style: AppTextStyles.body.copyWith(color: AppColors.black),
//               // ),
//               // _titleText("تاريخ الحصول :"),
//               // Text(
//               //   (certificate.date == null)
//               //       ? 'لا يوجد رابط تحقق .'
//               //       : AppDateFormatter.ymd(certificate.date!),
//               //   style: AppTextStyles.body.copyWith(color: AppColors.black),
//               // ),
//               _titleText("تاريخ الحصول"),
//               isEditing
//                   ? CustomDateField(
//                       label: "",
//                       value: date ??
//                           certificate
//                               .date, //لازم مرره يمكن من برا ليتغير هالحقل بس اختار شي تاريخ جديد
//                       onChanged: (ts) {
//                         onChanged("date", ts.toDate().toIso8601String());
//                       })
//                   : Text(
//                       certificate.date == null
//                           ? 'لا يوجد تاريخ'
//                           : AppDateFormatter.ymd(certificate.date!),
//                       style:
//                           AppTextStyles.body.copyWith(color: AppColors.black),
//                     ),

//               _titleText("المهارات المرتبطة"),
//               SkillsCards(skills: certificate.skills),

//               const SizedBox(height: 12),

//               if (isOwnProfile) _actions(),
//             ]),
//       ),
//     );
//   }

//   Widget _buildImage() {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(10),
//       child: Container(
//         width: 52.w,
//         height: 52.h,
//         decoration: BoxDecoration(gradient: AppColors.gradientColor),
//         child: certificate.imageURL != null &&
//                 certificate.imageURL!.trim().isNotEmpty
//             ? CachedNetworkImage(
//                 imageUrl: certificate.imageURL!,
//                 placeholder: (context, url) => const CustomLoading(),
//                 errorWidget: (context, url, error) => const Icon(Icons.error),
//                 fit: BoxFit.cover,
//               )
//             : const Icon(Icons.workspace_premium, color: Colors.white),
//       ),
//     );
//   }

//   Widget _editField({
//     required String initialValue,
//     required ValueChanged<String> onChanged,
//   }) {
//     return TextFormField(
//       initialValue: initialValue,
//       onChanged: onChanged,
//       decoration: const InputDecoration(
//         isDense: true,
//       ),
//     );
//   }

//   Widget _section(String title, String? value, String key) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _titleText(title),

//         isEditing
//             ? _editField(
//                 initialValue: value ?? '',
//                 onChanged: (v) => onChanged(key, v),
//               )
//             : Text(
//                 (value == null || value.isEmpty) ? 'لا يوجد $title' : value,
//                 style: AppTextStyles.body.copyWith(color: AppColors.black),
//               ),
//         // Text(
//         //   (certificate.credentialID ?? '').isEmpty
//         //       ? 'لا يوجد رقم تحقق .'
//         //       : certificate.credentialID!,
//         //   style: AppTextStyles.body.copyWith(color: AppColors.black),
//         const SizedBox(height: 8),
//       ],
//     );
//   }

//   // ================= ACTIONS =================
//   Widget _actions() {
//     if (!isOwnProfile) return const SizedBox.shrink();

//     return Row(
//       children: [
//         if (isEditing) ...[
//           IconButton(
//             icon: const Icon(Icons.check, color: Colors.green),
//             onPressed: onSave,
//           ),
//           IconButton(
//             icon: const Icon(Icons.close, color: Colors.red),
//             onPressed: onEdit,
//           ),
//         ] else ...[
//           IconButton(
//             icon: const Icon(Icons.edit),
//             onPressed: onEdit,
//           ),
//           IconButton(
//             icon: const Icon(Icons.delete),
//             onPressed: onDelete,
//           ),
//         ],
//       ],
//     );
//   }
// }

// Widget _titleText(String t) {
//   return Text(
//     t,
//     style: AppTextStyles.subheading.copyWith(color: AppColors.darkPurple),
//   );
// }

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freelancing_platform/core/classes/app_date_formatter.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/constants/app_spaces.dart';
import 'package:freelancing_platform/core/constants/app_text_styles.dart';
import 'package:freelancing_platform/core/widgets/custom_empty_data_text.dart';
import 'package:freelancing_platform/core/widgets/custom_date_field.dart';
import 'package:freelancing_platform/core/widgets/custom_loading.dart';
import 'package:freelancing_platform/core/widgets/custom_snackbar.dart';
import 'package:freelancing_platform/models/user_collections/certificate_model.dart';
import 'package:freelancing_platform/views/profile_section/profile_widgets/certificate_skill_card.dart';

class ProfileCertificateTile extends StatefulWidget {
  const ProfileCertificateTile({
    super.key,
    required this.certificate,
    required this.isOwnProfile,
    this.onSave,
    this.onDelete,
    this.allSkills,
    this.onPickImage,
    this.isNewCertificate = false,
    this.isLoading = false,
  });

  final CertificateModel certificate;
  final bool isOwnProfile;
  final bool isNewCertificate;
  final bool isLoading;

  /// بيرجع الداتا المعدلة كاملة
  final Function(Map<String, dynamic> data)? onSave;
  final VoidCallback? onDelete;
  final Future<File?> Function()? onPickImage;
  // final Future<File?> Function()? pickImage;
  final List<String>? allSkills;

  @override
  State<ProfileCertificateTile> createState() => _ProfileCertificateTileState();
}

class _ProfileCertificateTileState extends State<ProfileCertificateTile> {
  late Map<String, dynamic> draft;
  bool isEditing = false;

  @override
  void initState() {
    if (widget.isNewCertificate) {
      isEditing = true;
    }

    super.initState();
    draft = {
      "title": widget.certificate.title,
      "source": widget.certificate.source ?? "",
      "description": widget.certificate.description ?? "",
      "credentialID": widget.certificate.credentialID ?? "",
      "credentialURL": widget.certificate.credentialURL ?? "",
      "date": widget.certificate.date,
      "skills": List.from(widget.certificate.skills),
      "imageURL": widget.certificate.imageURL,
      "newImageFlie": null
    };
  }

  void toggleEdit() {
    setState(() {
      isEditing = !isEditing;
    });
  }

  void updateField(String key, dynamic value) {
    // setState(() {
    draft[key] = value;
    // });
    if (key == 'date') {
      setState(() {});
    }
  }

  void save() {
    if (widget.onSave == null) {
      return;
    }
    widget.onSave!(draft);
    setState(() => isEditing = false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.owhite,
        borderRadius: BorderRadius.circular(14),
      ),
      child: widget.isLoading
          ? CustomLoading()
          : Theme(
              data: ThemeData(dividerColor: Colors.transparent),
              child: ExpansionTile(
                tilePadding: const EdgeInsets.symmetric(
                  horizontal: AppSpaces.smallHorizontalPadding,
                  vertical: AppSpaces.smallVerticalSpacing,
                ),
                childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),

                leading: _buildImage(),

                // ================= TITLE =================
                title: isEditing
                    ? _editField(
                        hintText: "ادخل عنوان الشهادة",
                        initialValue: draft["title"],
                        onChanged: (v) => updateField("title", v),
                      )
                    : Text(
                        widget.certificate.title,
                        // draft["title"],
                        style: AppTextStyles.inputLabel
                            .copyWith(color: AppColors.black),
                      ),

                // ================= SOURCE =================
                subtitle: isEditing
                    ? _editField(
                        hintText: "ادخل مصدر الشهادة ",
                        initialValue: draft["source"],
                        onChanged: (v) => updateField("source", v),
                      )
                    : Text(
                        // draft["source"] ?? 'لا يوجد مصدر محدد',
                        !(widget.certificate.source == null ||
                                widget.certificate.source!.trim().isEmpty)
                            ? widget.certificate.source!
                            : 'لا يوجد مصدر محدد',
                        style: AppTextStyles.link,
                      ),

                children: [
                  TextButton(
                    onPressed: () => _showImageDialog(),
                    child: Text(
                      "عرض الصورة",
                      style: AppTextStyles.link,
                    ),
                  ),
                  _section("الوصف", "description"),
                  _section("رقم التحقق", "credentialID"),
                  _section("رابط التحقق", "credentialURL"),
                  const SizedBox(height: 6),
                  _titleText("تاريخ الحصول"),
                  isEditing
                      ? CustomDateField(
                          label: "",
                          value: draft["date"],
                          onChanged: (ts) {
                            updateField("date", ts);
                          },
                        )
                      : Align(
                          alignment: Alignment.topRight,
                          child: Text(
                            draft["date"] == null
                                ? 'لا يوجد تاريخ'
                                : AppDateFormatter.ymd(draft["date"]),
                            style: AppTextStyles.body.copyWith(
                              color: AppColors.black,
                            ),
                          ),
                        ),
                  const SizedBox(height: 8),
                  _titleText("المهارات المرتبطة"),
                  _skillsSection(),
                  // SkillsCards(skills: widget.certificate.skills),
                  const SizedBox(height: 12),
                  if (widget.isOwnProfile) _actions(),
                ],
              ),
            ),
    );
  }

  Widget _skillsSection() {
    return !isEditing
        ? SkillsCards(skills: widget.certificate.skills)
        : widget.allSkills != null
            ? Wrap(
                spacing: 8,
                children: widget.allSkills!.map((skill) {
                  final selected = (draft["skills"] as List).contains(skill);
                  return ChoiceChip(
                    label: Text(skill),
                    selected: selected,
                    onSelected: (_) => _toggleRelatedSkill(skill),
                  );
                }).toList(),
              )
            : SizedBox.shrink();
  }

  void _toggleRelatedSkill(String skill) {
    final skills = (draft["skills"] as List).cast<String>();

    if (skills.contains(skill)) {
      skills.remove(skill);
    } else {
      skills.add(skill);
    }
    setState(() {});
  }

  Widget _section(String title, String key) {
    String? val;
    switch (key) {
      case 'description':
        val = !(widget.certificate.description == null ||
                widget.certificate.description!.trim().isEmpty)
            ? widget.certificate.description
            : "لا يوجد وصف";
        break;
      case 'credentialID':
        val = !(widget.certificate.credentialID == null ||
                widget.certificate.credentialID!.trim().isEmpty)
            ? widget.certificate.credentialID
            : "لا يوجد رقم تحقق";
        break;
      case 'credentialURL':
        val = !(widget.certificate.credentialURL == null ||
                widget.certificate.credentialURL!.trim().isEmpty)
            ? widget.certificate.credentialURL
            : "لا يوجد رابط تحقق";
        break;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _titleText(title),
        isEditing
            ? _editField(
                initialValue: draft[key] ?? '',
                onChanged: (v) => updateField(key, v),
              )
            : Text(
                val ?? "",

                // (draft[key] == null || draft[key].toString().isEmpty)
                //     ? 'لا يوجد $title'
                //     : draft[key],
                style: AppTextStyles.body.copyWith(color: AppColors.black),
              ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _editField(
      {required String initialValue,
      required ValueChanged<String> onChanged,
      String? hintText}) {
    return TextFormField(
      initialValue: initialValue,
      onChanged: onChanged,
      decoration: InputDecoration(
        isDense: true,
        hintText: hintText,
        hintStyle: TextStyle(
          color: AppColors.grey,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildImage() {
    bool urlNotEmpty = widget.certificate.imageURL != null &&
        widget.certificate.imageURL!.isNotEmpty;
    // bool imageExist = urlNotEmpty ||  draft["newImageFlie"] != null ;
    Widget finalImage = !isEditing
        ? (urlNotEmpty
            ? CachedNetworkImage(
                imageUrl: widget.certificate.imageURL!,
                placeholder: (context, url) => const CustomLoading(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                fit: BoxFit.cover,
              )
            : const Icon(Icons.workspace_premium, color: Colors.white))
        : (draft["newImageFlie"] != null
            ? Image.file(draft["newImageFlie"], fit: BoxFit.cover)
            : urlNotEmpty
                ? CachedNetworkImage(
                    imageUrl: widget.certificate.imageURL!,
                    placeholder: (context, url) => const CustomLoading(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    fit: BoxFit.cover,
                  )
                : const Icon(Icons.add_a_photo_rounded, color: Colors.white));

    return GestureDetector(
      onTap: isEditing ? _pickImage : null,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: 52.w,
          height: 52.h,
          decoration: BoxDecoration(gradient: AppColors.gradientColor),
          child: finalImage,
        ),
      ),
    );
  }

  void _showImageDialog() {
    bool urlNotEmpty = widget.certificate.imageURL != null &&
        widget.certificate.imageURL!.isNotEmpty;
    // bool imageExist = urlNotEmpty ||  draft["newImageFlie"] != null ;
    Widget finalImage = !isEditing
        ? (urlNotEmpty
            ? CachedNetworkImage(
                imageUrl: widget.certificate.imageURL!,
                placeholder: (context, url) => const CustomLoading(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                fit: BoxFit.cover,
              )
            : customEmptyMessage(message: "لا يوجد صورة"))
        : (draft["newImageFlie"] != null
            ? Image.file(draft["newImageFlie"], fit: BoxFit.cover)
            : urlNotEmpty
                ? CachedNetworkImage(
                    imageUrl: widget.certificate.imageURL!,
                    placeholder: (context, url) => const CustomLoading(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    fit: BoxFit.cover,
                  )
                : customEmptyMessage(message: "لا يوجد صورة"));
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(
          children: [
            /// الصورة الكبيرة
            ClipRRect(borderRadius: BorderRadius.circular(16), child: finalImage
                //  CachedNetworkImage(
                //   imageUrl: imageUrl,
                //   placeholder: (context, url) => const SizedBox(
                //     height: 200,
                //     child: Center(child: CustomLoading()),
                //   ),
                //   errorWidget: (context, url, error) =>
                //       const Icon(Icons.error, color: Colors.white),
                //   fit: BoxFit.contain,
                // ),
                ),

            /// زر اغلاق
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    if (widget.onPickImage == null) return;
    draft["newImageFlie"] = await widget.onPickImage!();
    if (draft["newImageFlie"] == null) {
      customSnackbar(message: "لم يتم اختيار الصوره");
      return;
    }
    setState(() {});
  }

  Widget _actions() {
    return widget.isNewCertificate
        ? Center(
            child: ElevatedButton(
              onPressed: () {
                if (widget.onSave != null) {
                  widget.onSave!(draft);
                }
              },
              child: Text("إضافة الشهادة"),
            ),
          )
        : Row(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isEditing) ...[
                IconButton(
                  icon: const Icon(Icons.check, color: AppColors.green),
                  onPressed: save,
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: AppColors.red),
                  onPressed: toggleEdit,
                ),
              ] else ...[
                IconButton(
                  icon: const Icon(Icons.edit, color: AppColors.purple),
                  onPressed: toggleEdit,
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: AppColors.red),
                  onPressed: widget.onDelete,
                ),
              ],
            ],
          );
  }

  Widget _titleText(String t) {
    return Align(
      alignment: Alignment.topRight,
      child: Text(
        t,
        style: AppTextStyles.subheading.copyWith(
          color: AppColors.darkPurple,
        ),
      ),
    );
  }
}
