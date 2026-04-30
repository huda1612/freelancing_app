import 'package:cloud_firestore/cloud_firestore.dart';

class AppDateFormatter {
  /// 1) تاريخ قياسي: 2026-04-25
  static String ymd(Timestamp? ts) {
    if (ts == null) return "لا يوجد تاريخ محدد";
    final d = ts.toDate();
    return "${d.year}-${_two(d.month)}-${_two(d.day)}";
  }

  /// 2) تاريخ + وقت: 2026-04-25 11:07
  static String ymdHm(Timestamp? ts) {
    if (ts == null) return "لا يوجد تاريخ محدد";
    final d = ts.toDate();
    return "${d.year}-${_two(d.month)}-${_two(d.day)} "
        ", ${_two(d.hour)}:${_two(d.minute)}";
  }

  /// 3) شكل جميل بالعربي: 25 أبريل 2026
  static String pretty(Timestamp? ts) {
    if (ts == null) return "لا يوجد تاريخ محدد";
    final d = ts.toDate();
    return "${d.day} ${_monthAr(d.month)} ${d.year}";
  }

  /// 4) “منذ …” (time ago)
  static String timeAgo(Timestamp? ts) {
    if (ts == null) return "لا يوجد تاريخ محدد";
    final now = DateTime.now();
    final d = ts.toDate();
    final diff = now.difference(d);

    if (diff.inSeconds < 60) return "منذ ثوانٍ";
    if (diff.inMinutes < 60) return "منذ ${diff.inMinutes} دقيقة";
    if (diff.inHours < 24) return "منذ ${diff.inHours} ساعة";
    if (diff.inDays < 7) return "منذ ${diff.inDays} يوم";

    // fallback: تاريخ جميل
    return pretty(ts);
  }

  // -------- helpers --------
  static String _two(int n) => n.toString().padLeft(2, '0');

  static String _monthAr(int m) {
    const months = [
      "يناير",
      "فبراير",
      "مارس",
      "أبريل",
      "مايو",
      "يونيو",
      "يوليو",
      "أغسطس",
      "سبتمبر",
      "أكتوبر",
      "نوفمبر",
      "ديسمبر"
    ];
    return months[m - 1];
  }
}
