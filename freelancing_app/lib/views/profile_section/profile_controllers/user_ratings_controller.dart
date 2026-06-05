import 'package:freelancing_platform/core/classes/status_classes.dart';
import 'package:freelancing_platform/data/services/rating_service.dart';
import 'package:freelancing_platform/models/user_collections/rating_model.dart';
import 'package:get/get.dart';

class UserRatingsController extends GetxController {
  StatusClasses pageState = StatusClasses.isloading;
  List<RatingModel> ratings = <RatingModel>[];
  final RatingService _ratingService = RatingService();
  String? userId;
  String? userFullName;
  double? ratingAvg;
  @override
  void onInit() {
    userId = Get.arguments?["userId"];
    userFullName = Get.arguments?["fullName"];
    if (Get.arguments?["ratingAvg"] is double) {
      ratingAvg = Get.arguments?["ratingAvg"] as double;
    }
    // ratingAvg = Get.arguments?["ratingAvg"] is double ? Get.arguments?["ratingAvg"] as double : null;

    if (userId == null) {
      pageState = StatusClasses.customError("فشل تحميل بيانات المستخدم");
      update();
      return;
    }
    loadRatings();
    super.onInit();
  }

  /// تحميل التقييمات
  Future<void> loadRatings() async {
    if (userId == null) return;
    final res = await _ratingService.getAllUserRatings(uId: userId!);
    res.fold((e) {
      pageState = e;
      update();
    }, (list) {
      ratings.assignAll(list);
      pageState = StatusClasses.success;
      update();
    });
  }

  // List<RatingModel> dummyRatings = [
  //   RatingModel(
  //     id: 'rating_1',
  //     fromUserId: 'user_123',
  //     projectId: 'project_456',
  //     professionalism: 5.0,
  //     communication: 4.0,
  //     punctuality: 5.0,
  //     quality: 4.0,
  //     workAgain: 5.0,
  //     projectName: "تصميم فيديو ومونتاج",
  //     category: "مونتاج",
  //     comment: "احترافية وسرعة في العمل.",
  //     projectStatus: "completed",
  //   ),
  //   RatingModel(
  //     id: 'rating_2',
  //     fromUserId: 'user_789',
  //     projectId: 'project_101',
  //     professionalism: 4.0,
  //     communication: 5.0,
  //     punctuality: 4.0,
  //     quality: 5.0,
  //     workAgain: 4.0,
  //     projectName: "تصميم شعار",
  //     category: "جرافيك",
  //     comment: "تجربة ممتازة جداً.",
  //     projectStatus: "withdrawn",
  //   ),
  // ];
}
