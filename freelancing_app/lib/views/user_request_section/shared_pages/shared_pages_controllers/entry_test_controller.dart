// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:freelancing_platform/core/classes/firebase_crud.dart';
// import 'package:freelancing_platform/core/classes/status_classes.dart';
// import 'package:freelancing_platform/core/classes/user_session.dart';
// import 'package:freelancing_platform/core/constants/app_routes.dart';
// import 'package:freelancing_platform/core/constants/collections_names.dart';
// import 'package:freelancing_platform/models/user_collections/admission_questions.dart';
// import 'package:get/get.dart';

// class EntryTestController extends GetxController {
//   List<AdmissionQuestionModel> questions = [];
//   StatusClasses testPageState = StatusClasses.isloading;
//   Map<int, int> answers = {};

//   @override
//   void onInit() {
//     Future.wait([fetchQuestions()]);
//     super.onInit();
//   }

//   Future<void> fetchQuestions() async {
//     testPageState = StatusClasses.isloading;
//     update();
//     final query = FirebaseFirestore.instance
//         .collection(CollectionsNames.admission_questions)
//         .where("targetRole", isEqualTo: UserSession.role);
//     final response = await FirebaseCrud.runGetQuery(
//         query: query,
//         fromMap: (data, id) => AdmissionQuestionModel.fromMap(data, id));
//     response.fold((errorState) {
//       testPageState = errorState;
//       update();
//     }, (data) {
//       questions = data;
//       testPageState = StatusClasses.success;
//       update();
//     });
//   }

//   void istestCorrect() async {
//     for (int i = 0; i < questions.length; i++) {
//       final selectedAnswer = answers[i];

//       // إذا ما جاوب أصلاً أو الجواب غلط
//       if (selectedAnswer == null ||
//           selectedAnswer != questions[i].correctAnswerIndex) {
//         Get.snackbar("اجابات خاطئة",
//             "يوجد لديك اجابات خاطئة لايمكنك الاستمرار ، الرجاء تصحيح جميع الاجابات");
//         return;
//       }
//     }
//     //هون لازم يتم ارسال الطلب والانتقال لصفحة تم التقديم وتعديل الحاله للمستخدم
//     // await sendRequest();
//     Get.offAllNamed(AppRoutes.pending);
//     return; // كل الإجابات صحيح
//   }

//   void selectAnswer(int questionIndex, int answerIndex) {
//     answers[questionIndex] = answerIndex;
//     update(); // GetX
//   }

//   Future sendRequest() async{

//   }
// }
