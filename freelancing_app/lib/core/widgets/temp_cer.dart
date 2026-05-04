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

// class ProfileCertificateTile extends StatefulWidget {
//   const ProfileCertificateTile({
//     super.key,
//     required this.certificate,
//     required this.isOwnProfile,
//     required this.onSave,
//     required this.onDelete,
//   });

//   final CertificateModel certificate;
//   final bool isOwnProfile;

//   /// بيرجع الداتا المعدلة كاملة
//   final Function(Map<String, dynamic> data) onSave;
//   final VoidCallback onDelete;

//   @override
//   State<ProfileCertificateTile> createState() => _ProfileCertificateTileState();
// }

// class _ProfileCertificateTileState extends State<ProfileCertificateTile> {
//   late Map<String, dynamic> draft;
//   bool isEditing = false;

//   @override
//   void initState() {
//     super.initState();

//     draft = {
//       "title": widget.certificate.title,
//       "source": widget.certificate.source,
//       "description": widget.certificate.description,
//       "credentialID": widget.certificate.credentialID,
//       "credentialURL": widget.certificate.credentialURL,
//       "date": widget.certificate.date,
//     };
//   }

//   void toggleEdit() {
//     setState(() {
//       isEditing = !isEditing;
//     });
//   }

//   void updateField(String key, dynamic value) {
//     setState(() {
//       draft[key] = value;
//     });
//   }

//   void save() {
//     widget.onSave(draft);
//     setState(() => isEditing = false);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 10),
//       decoration: BoxDecoration(
//         color: AppColors.owhite,
//         borderRadius: BorderRadius.circular(14),
//       ),
//       child: Theme(
//         data: ThemeData(dividerColor: Colors.transparent),
//         child: ExpansionTile(
//           tilePadding: const EdgeInsets.symmetric(
//             horizontal: AppSpaces.smallHorizontalPadding,
//             vertical: AppSpaces.smallVerticalSpacing,
//           ),
//           childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),

//           leading: _buildImage(),

//           // ================= TITLE =================
//           title: isEditing
//               ? _editField(
//                   initialValue: draft["title"],
//                   onChanged: (v) => updateField("title", v),
//                 )
//               : Text(
//                   draft["title"],
//                   style:
//                       AppTextStyles.inputLabel.copyWith(color: AppColors.black),
//                 ),

//           // ================= SOURCE =================
//           subtitle: isEditing
//               ? _editField(
//                   initialValue: draft["source"],
//                   onChanged: (v) => updateField("source", v),
//                 )
//               : Text(
//                   draft["source"] ?? 'لا يوجد مصدر محدد',
//                   style: AppTextStyles.link,
//                 ),

//           children: [
//             _section("الوصف", "description"),
//             _section("رقم التحقق", "credentialID"),
//             _section("رابط التحقق", "credentialURL"),
//             const SizedBox(height: 6),
//             _titleText("تاريخ الحصول"),
//             isEditing
//                 ? CustomDateField(
//                     label: "",
//                     value: draft["date"],
//                     onChanged: (ts) {
//                       updateField("date", ts);
//                     },
//                   )
//                 : Text(
//                     draft["date"] == null
//                         ? 'لا يوجد تاريخ'
//                         : AppDateFormatter.ymd(draft["date"]),
//                     style: AppTextStyles.body.copyWith(
//                       color: AppColors.black,
//                     ),
//                   ),
//             const SizedBox(height: 8),
//             _titleText("المهارات المرتبطة"),
//             SkillsCards(skills: widget.certificate.skills),
//             const SizedBox(height: 12),
//             if (widget.isOwnProfile) _actions(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _section(String title, String key) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _titleText(title),
//         isEditing
//             ? _editField(
//                 initialValue: draft[key] ?? '',
//                 onChanged: (v) => updateField(key, v),
//               )
//             : Text(
//                 (draft[key] == null || draft[key].toString().isEmpty)
//                     ? 'لا يوجد $title'
//                     : draft[key],
//                 style: AppTextStyles.body.copyWith(color: AppColors.black),
//               ),
//         const SizedBox(height: 8),
//       ],
//     );
//   }

//   Widget _editField({
//     required String initialValue,
//     required ValueChanged<String> onChanged,
//   }) {
//     return TextFormField(
//       initialValue: initialValue,
//       onChanged: onChanged,
//       decoration: const InputDecoration(isDense: true),
//     );
//   }

//   Widget _buildImage() {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(10),
//       child: Container(
//         width: 52.w,
//         height: 52.h,
//         decoration: BoxDecoration(gradient: AppColors.gradientColor),
//         child: widget.certificate.imageURL != null &&
//                 widget.certificate.imageURL!.isNotEmpty
//             ? CachedNetworkImage(
//                 imageUrl: widget.certificate.imageURL!,
//                 placeholder: (context, url) => const CustomLoading(),
//                 errorWidget: (context, url, error) => const Icon(Icons.error),
//                 fit: BoxFit.cover,
//               )
//             : const Icon(Icons.workspace_premium, color: Colors.white),
//       ),
//     );
//   }

//   Widget _actions() {
//     return Row(
//       children: [
//         if (isEditing) ...[
//           IconButton(
//             icon: const Icon(Icons.check, color: Colors.green),
//             onPressed: save,
//           ),
//           IconButton(
//             icon: const Icon(Icons.close, color: Colors.red),
//             onPressed: toggleEdit,
//           ),
//         ] else ...[
//           IconButton(
//             icon: const Icon(Icons.edit),
//             onPressed: toggleEdit,
//           ),
//           IconButton(
//             icon: const Icon(Icons.delete),
//             onPressed: widget.onDelete,
//           ),
//         ],
//       ],
//     );
//   }

//   Widget _titleText(String t) {
//     return Text(
//       t,
//       style: AppTextStyles.subheading.copyWith(
//         color: AppColors.darkPurple,
//       ),
//     );
//   }
// }
