// class UserPointedActions {
//   // =========================
//   // 👤 Profile / Onboarding
//   // =========================
//   static const String registerAccount = "REGISTER_ACCOUNT";
//   static const String completeProfile = "COMPLETE_PROFILE";
//   static const String addProfilePhoto = "ADD_PROFILE_PHOTO";
//   static const String addSkill = "ADD_SKILL";

//   // =========================
//   // 👨‍💻 Freelancer Growth
//   // =========================
//   static const String submitOffer = "SUBMIT_OFFER";
//   static const String offerAccepted = "OFFER_ACCEPTED";
//   static const String completeProjectFreelancer = "COMPLETE_PROJECT";

//   static const String addWorkSample = "ADD_WORK_SAMPLE";
//   static const String addCertificate = "ADD_CERTIFICATE";

//   static const String receiveReview = "RECEIVE_REVIEW";
//   static const String receiveHighRating = "RECEIVE_HIGH_RATING";

//   // =========================
//   // 👤 Client Activity
//   // =========================
//   static const String createProject = "CREATE_PROJECT";
//   static const String acceptOffer = "ACCEPT_OFFER";
//   static const String completeProjectClient = "COMPLETE_PROJECT_CLIENT";

//   static const String giveReview = "GIVE_REVIEW";

//   // =========================
//   // 💬 Engagement
//   // =========================
//   static const String startChat = "START_CHAT";
//   // static const String sendImage = "SEND_IMAGE";
// }

class PointedAction {
  final String type;
  final int points;
  const PointedAction._(this.type, this.points);

  static const registerAccount = PointedAction._("isloading", 1);
  static const completeProfile = PointedAction._("idle", 1);
  static const addProfilePhoto = PointedAction._("success", 1);
  //هون لازم حط كل الاكشنز اللي مكتوبه فوق وحدد النقاط الموافقه الها
  // بصير لما بضيف اكشن بمرر للتابع اللي بالسيرفس الاكشن من هون و هو بياخد منها النقاط واسم الاكشن
  //--------------------- custom action---------------------
  factory PointedAction.customError(int points) =>
      PointedAction._("customError", points);
}
