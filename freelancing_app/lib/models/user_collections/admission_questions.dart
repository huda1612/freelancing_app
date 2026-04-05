class AdmissionQuestionModel {
  final String id;
  final String question;
  final List<String> options;
  final int correctAnswerIndex;
  final String targetRole; // "freelancer" أو "client"

  AdmissionQuestionModel({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    required this.targetRole,
  });

  // 🔹 تحويل Object إلى Map (للتخزين في Firestore)
  Map<String, dynamic> toMap() {
    return {
      'question': question,
      'options': options,
      'correctAnswerIndex': correctAnswerIndex,
      'targetRole': targetRole,
    };
  }

  // 🔹 تحويل من Firestore إلى Object
  factory AdmissionQuestionModel.fromMap(Map<String, dynamic> map, String docId) {
    return AdmissionQuestionModel(
      id: docId,
      question: map['question'] ?? '',
      options: List<String>.from(map['options'] ?? []),
      correctAnswerIndex: map['correctAnswerIndex'] ?? 0,
      targetRole: map['targetRole'] ?? '',
    );
  }
}