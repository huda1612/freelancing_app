import 'package:cloud_firestore/cloud_firestore.dart';

class OfferModel {
  final String id;
  final String freelancerId;
  final double price;
  final int durationDays;
  final String proposalText;
  final Timestamp? createdAt;

  OfferModel({
    required this.id,
    required this.freelancerId,
    required this.price,
    required this.durationDays,
    this.proposalText = '',
    this.createdAt,
  });

  // 🔹 تحويل من Object إلى Map
  Map<String, dynamic> toMap() {
    return {
      'freelancerId': freelancerId,
      'price': price,
      'duration_days': durationDays,
      'proposal_text': proposalText,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }

  // 🔹 تحويل من Map إلى Object
  factory OfferModel.fromMap(Map<String, dynamic> map, String docId) {
    return OfferModel(
      id: docId,
      freelancerId: map['freelancerId'] ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      durationDays: map['duration_days'] ?? 0,
      proposalText: map['proposal_text'] ?? '',
      createdAt:
          map['createdAt'] is Timestamp ? map['createdAt'] as Timestamp : null,
    );
  }
}
