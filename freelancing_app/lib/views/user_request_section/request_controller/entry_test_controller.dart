import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freelancing_platform/core/classes/firebase_crud.dart';
import 'package:freelancing_platform/core/classes/status_classes.dart';
import 'package:freelancing_platform/core/classes/user_session.dart';
import 'package:freelancing_platform/core/constants/collections_names.dart';
import 'package:freelancing_platform/core/constants/user_roles.dart';
import 'package:freelancing_platform/models/user_collections/admission_questions.dart';
import 'package:freelancing_platform/views/user_request_section/request_controller/client_request_controller.dart';
import 'package:freelancing_platform/views/user_request_section/request_controller/freelancer_request_controller.dart';
import 'package:get/get.dart';

//انتهى
class EntryTestController extends GetxController {
  //متغيرات اختبار القبول
  List<AdmissionQuestionModel> questions = [];
  StatusClasses testPageState = StatusClasses.isloading;
  Map<int, int> answers = {};

  @override
  void onInit() {
    super.onInit();

    //احضار البيانات من السيرفر وتجهيزها بالمتغيرات
    Future.wait([fetchQuestions()]);
  }

  Future<void> fetchQuestions() async {
    testPageState = StatusClasses.isloading;
    update();
    final query = FirebaseFirestore.instance
        .collection(CollectionsNames.admissionQuestions)
        .where("targetRole", isEqualTo: UserSession.role);
    final response = await FirebaseCrud.runGetQuery(
        query: query,
        fromMap: (data, id) => AdmissionQuestionModel.fromMap(data, id));
    response.fold((errorState) {
      testPageState = errorState;
      Get.snackbar(
          errorState.type, errorState.message ?? "حدث خطأ في جلب الاسئلة");
      update();
    }, (data) {
      questions = data;
      testPageState = StatusClasses.success;
      update();
    });
  }

  void istestCorrect() async {
    for (int i = 0; i < questions.length; i++) {
      final selectedAnswer = answers[i];

      // إذا ما جاوب أصلاً أو الجواب غلط
      if (selectedAnswer == null ||
          selectedAnswer != questions[i].correctAnswerIndex) {
        Get.snackbar("اجابات خاطئة",
            "يوجد لديك اجابات خاطئة لايمكنك الاستمرار ، الرجاء تصحيح جميع الاجابات");
        return;
      }
    }
    testPageState = StatusClasses.isloading;
    update();
    //هون لازم يتم ارسال الطلب والانتقال لصفحة تم التقديم وتعديل الحاله للمستخدم
    await finishExam();
    testPageState = StatusClasses.idle;
    update();
    return; // كل الإجابات صحيح
  }

  void selectAnswer(int questionIndex, int answerIndex) {
    answers[questionIndex] = answerIndex;
    update(); // GetX
  }

  //بيستدعي ارسال الطلب حسب نوع المستخدم
  Future<void> finishExam() async {
    if (UserSession.role == UserRole.freelancer) {
      final request = Get.find<FreelancerRequestController>();
      await request.sendRequest();
    } else if (UserSession.role == UserRole.client) {
      final request = Get.find<ClientRequestController>();
      await request.sendRequest();
    }
  }
}
