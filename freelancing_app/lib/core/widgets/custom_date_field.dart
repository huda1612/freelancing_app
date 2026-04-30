import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// value = القيمة الحالية للتاريخ
//// تستخدم لعرض التاريخ داخل الـ widget
// بدونها ما في state
// widget يرجع القيمة الجديدة عبر onChanged
// أنت المسؤول عن التخزين
class CustomDateField extends StatelessWidget {
  final String label;
  final Timestamp? value;
  final Function(Timestamp) onChanged;

  const CustomDateField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: value?.toDate() ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      final timestamp = Timestamp.fromDate(
        DateTime(picked.year, picked.month, picked.day),
      );

      onChanged(timestamp);
    }
  }

  @override
  Widget build(BuildContext context) {
    String text = "اختر التاريخ";

    if (value != null) {
      final date = value!.toDate();
      text = "${date.day}/${date.month}/${date.year}";
    }

    return InkWell(
      onTap: () => _pickDate(context),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        child: Text(text),
      ),
    );
  }
}