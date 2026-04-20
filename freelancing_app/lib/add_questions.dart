// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:freelancing_platform/core/constants/collections_names.dart';
// import 'package:freelancing_platform/models/user_collections/admission_questions.dart';

// Future<void> addQuestions() async {
//   final questions = [
//     {
//       "question": "كيف تتعامل مع client يطلب تعديلات كثيرة خارج نطاق الاتفاق؟",
//       "options": [
//         "أرفض التعديلات نهائيًا مهما كانت صغيرة",
//         "أنفذ التعديلات مجانًا لضمان رضا ال client",
//         "أوضح لل client أن أي تعديل جديد له تكلفة إضافية حسب الاتفاق المسبق",
//         "أتجاهل طلبه وأعتبر المشروع منتهيًا",
//       ],
//       "correctAnswerIndex": 2,
//       "targetRole": "freelancer",
//     },
//     {
//       "question":
//           "ما هو تصرفك المناسب عند تأخر ال client في تزويدك بمتطلبات المشروع؟",
//       "options": [
//         "أوقف العمل تمامًا حتى يرسل المتطلبات دون متابعته",
//         "أتواصل مع ال client بشكل مهني لأذكرّه بالمطلوب وأحدثه عن أثر التأخير على الجدول الزمني",
//         "أكمل العمل بناءً على افتراضات من عندي",
//         "أرفع شكوى إلى إدارة التطبيق فورًا",
//       ],
//       "correctAnswerIndex": 1,
//       "targetRole": "freelancer",
//     },
//     {
//       "question":
//           "أي من هذه الممارسات تساعدك في الحصول على تقييمات إيجابية متكررة؟",
//       "options": [
//         "أقبل أي سعر يطلبه ال client حتى لو كان قليلًا",
//         "أسلم العمل قبل الموعد المحدد مع جودة أقل",
//         "أتواصل بوضوح، وأسلم العمل في وقته، وأطلب تأكيد رضا العميل",
//         "أتجنب الرد على استفسارات العميل لأوفر وقتًا",
//       ],
//       "correctAnswerIndex": 2,
//       "targetRole": "freelancer",
//     },
//     {
//       "question": "كيف تتعامل مع مشروع تجد نفسك غير مؤهل له بشكل كافٍ؟",
//       "options": [
//         "أتقدم له على أي حال وأتعلم أثناء العمل",
//         "أعتذر بأدب عن عدم التقدم، أو أقترح جزءًا فقط أستطيع تنفيذه",
//         "أستخدم أعمال غيري وأقدمها على أنها لي",
//       ],
//       "correctAnswerIndex": 1,
//       "targetRole": "freelancer",
//     },
//   ];
//   for (var q in questions) {
//     await FirebaseFirestore.instance
//         .collection(CollectionsNames.admission_questions).add(q);
//   }
// }
