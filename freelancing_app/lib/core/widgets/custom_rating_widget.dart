import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freelancing_platform/core/constants/app_colors.dart';
import 'package:freelancing_platform/core/constants/app_routes.dart';
import 'package:freelancing_platform/core/constants/app_spaces.dart';
import 'package:freelancing_platform/core/constants/app_text_styles.dart';
import 'package:freelancing_platform/core/widgets/custom_button.dart';
import 'package:freelancing_platform/core/widgets/custom_loading.dart';
import 'package:freelancing_platform/models/user_collections/rating_model.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';

class CustomRatingWidget extends StatefulWidget {
  final RatingModel? ratingModel;
  // final Function(RatingModel)? onRatingSubmit;
  final Function(
    double professionalism,
    double communication,
    double punctuality,
    double quality,
    double workAgain,
    String? comment,
  )? onRatingSubmit;

  final String? projectName;
  final String? category;
  final String? formattedDate;
  final String? projectStatus; // مكتمل – مسحوب

  final bool showViewProfile;
  final bool isLoading;

  const CustomRatingWidget(
      {super.key,
      this.ratingModel,
      this.onRatingSubmit,
      this.projectName,
      this.category,
      this.formattedDate,
      this.projectStatus,
      this.showViewProfile = true,
      this.isLoading = false});

  @override
  State<CustomRatingWidget> createState() => _CustomRatingWidgetState();
}

class _CustomRatingWidgetState extends State<CustomRatingWidget> {
  late double _professionalism;
  late double _communication;
  late double _punctuality;
  late double _quality;
  late double _workAgain;

  String? _comment;

  bool get _isReadOnly => widget.ratingModel != null;

  final List<String> _titles = [
    "الاحترافية بالتعامل",
    "التواصل و المتابعة",
    "الالتزام بالوقت",
    "جودة العمل",
    "التعامل مرة أخرى",
  ];

  @override
  void initState() {
    super.initState();

    if (_isReadOnly) {
      _professionalism = widget.ratingModel!.professionalism;
      _communication = widget.ratingModel!.communication;
      _punctuality = widget.ratingModel!.punctuality;
      _quality = widget.ratingModel!.quality;
      _workAgain = widget.ratingModel!.workAgain;
      _comment = widget.ratingModel!.comment;
    } else {
      _professionalism = 0;
      _communication = 0;
      _punctuality = 0;
      _quality = 0;
      _workAgain = 0;
      _comment = null;
    }
  }

  // -------------------------------
  //   تحديث التقييم
  // -------------------------------
  void _updateRating(int index, double value) {
    if (_isReadOnly) return;

    setState(() {
      switch (index) {
        case 0:
          _professionalism = value;
          break;
        case 1:
          _communication = value;
          break;
        case 2:
          _punctuality = value;
          break;
        case 3:
          _quality = value;
          break;
        case 4:
          _workAgain = value;
          break;
      }
    });
  }

  // -------------------------------
  //   بناء الودجيت
  // -------------------------------
  @override
  Widget build(BuildContext context) {
    return widget.isLoading
        ? CustomLoading()
        : Container(
            padding: EdgeInsets.all(AppSpaces.paddingMedium),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                SizedBox(height: AppSpaces.heightSmall),
                ...List.generate(
                    5,
                    (i) =>
                        // buildRatingRow(
                        //     title: _titles[i],
                        //     value: _getValue(i),
                        //     isReadOnly: _isReadOnly,
                        //     onRatingUpdate: _updateRating,
                        //     index: i)),
                        _buildRatingRow(i)),
                SizedBox(height: 12.h),
                _isReadOnly ? _buildCommentView() : _buildCommentInput(),
                if (!_isReadOnly) ...[
                  SizedBox(height: AppSpaces.heightMedium),
                  CustomButton(
                      text: "إرسال التقييم",
                      onTap: () => widget.onRatingSubmit != null
                          ? widget.onRatingSubmit!(
                              _professionalism,
                              _communication,
                              _punctuality,
                              _quality,
                              _workAgain,
                              _comment,
                            )
                          : null,
                      color: AppColors.purple,
                      prefix: const Icon(
                        Icons.rate_review_rounded,
                        color: AppColors.white,
                      ),
                      noShadow: true)
                ]
              ],
            ),
          );
  }

  // -------------------------------
  //   رأس البطاقة + حالة المشروع
  // -------------------------------
  Widget _buildHeader() {
    final avg = _isReadOnly
        ? widget.ratingModel!.averageRating
        : _calculateTempAverage();

    // ألوان الحالة
    Color statusBg(String? status) {
      if (status == "completed") return Colors.green.withOpacity(0.15);
      if (status == "withdrawn") return Colors.red.withOpacity(0.15);
      return Colors.grey.withOpacity(0.15);
    }

    Color statusText(String? status) {
      if (status == "completed") return Colors.green[700]!;
      if (status == "withdrawn") return Colors.red[700]!;
      return Colors.grey[700]!;
    }

    String statusLabel(String? status) {
      if (status == "completed") return "مكتمل";
      if (status == "withdrawn") return "مسحوب";
      return "غير معروف";
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // معلومات المشروع + الحالة
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  widget.projectName ?? "اسم المشروع",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(width: 8),

                // مربع حالة المشروع
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusBg(widget.projectStatus),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    statusLabel(widget.projectStatus),
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: statusText(widget.projectStatus),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 3),
            Text(
              widget.category ?? "الاختصاص",
              style: TextStyle(fontSize: 13.sp, color: Colors.grey),
            ),
            const SizedBox(height: 3),
            Text(
              widget.formattedDate ?? "",
              style: TextStyle(fontSize: 12.sp, color: Colors.grey),
            ),
            const SizedBox(height: 3),
            if (widget.showViewProfile == true && widget.ratingModel != null)
              InkWell(
                onTap: () {
                  Get.toNamed(
                    AppRoutes.userProfile,
                    arguments: {'userId': widget.ratingModel!.fromUserId},
                  );
                },
                child: Row(
                  children: [
                    Icon(Icons.person_outline,
                        size: 16, color: AppColors.purple),
                    SizedBox(width: 4.w),
                    Text(
                      "عرض بروفايل المقيم",
                      style: AppTextStyles.link,
                    ),
                  ],
                ),
              ),
          ],
        ),

        // متوسط التقييم
        Row(
          children: [
            Icon(Icons.star, color: AppColors.purple, size: 20),
            const SizedBox(width: 4),
            Text(
              avg.toStringAsFixed(1),
              style: TextStyle(
                fontSize: 16,
                color: AppColors.purple,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  double _calculateTempAverage() {
    return (_professionalism +
            _communication +
            _punctuality +
            _quality +
            _workAgain) /
        5;
  }

  // -------------------------------
  //   صفوف النجوم
  // -------------------------------
  Widget _buildRatingRow(int index) {
    final value = _getValue(index);

    return
        //  Padding(
        //   padding: const EdgeInsets.symmetric(vertical: 6),
        //   child:
        Row(
      children: [
        Expanded(
          child: Text(
            _titles[index],
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Row(children: [
          ...List.generate(5, (i) {
            final starValue = (i + 1).toDouble();
            final selected = starValue <= value;

            return IconButton(
              onPressed:
                  _isReadOnly ? null : () => _updateRating(index, starValue),
              icon: Icon(
                Icons.star,
                size: 26.w,
                color: selected ? Colors.amber : Colors.grey[300],
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            );
          }),
          Text(
            value.toString(),
            style: AppTextStyles.link.copyWith(
                color: value != 0 ? Colors.amber : Colors.grey[300],
                fontSize: 10.sp),
          )
        ]),
      ],
      // ),
    );
  }

  double _getValue(int index) {
    switch (index) {
      case 0:
        return _professionalism;
      case 1:
        return _communication;
      case 2:
        return _punctuality;
      case 3:
        return _quality;
      case 4:
        return _workAgain;
      default:
        return 0;
    }
  }

  // -------------------------------
  //   التعليق
  // -------------------------------
  Widget _buildCommentInput() {
    // return CustomTextField(
    //   keyboardType: TextInputType.multiline,
    //   hintText: "اكتب تعليقاً (اختياري)",

    //   onChanged: (v) {
    //     _comment = v;
    //     // _notifyRatingChanged();
    //   },
    // );
    return TextField(
      maxLines: 2,
      decoration: InputDecoration(
        hintText: "اكتب تعليقاً (اختياري)",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onChanged: (v) {
        _comment = v;
        // _notifyRatingChanged();
      },
    );
  }

  Widget _buildCommentView() {
    if (_comment == null || _comment!.isEmpty) {
      return const SizedBox();
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "التعليق: ",
          style: const TextStyle(fontSize: 16),
        ),
        // CircleAvatar(
        //   radius: 18,
        //   backgroundColor: AppColors.veryLightPurple,
        //   child: Icon(Icons.person_outline, size: 18, color: AppColors.purple),
        // ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            _comment!,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}
