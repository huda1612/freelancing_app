import 'package:flutter/material.dart';
import 'package:freelancing_platform/models/user_collections/users_requests_model.dart';

class RequestShortcut extends StatelessWidget {
  final String id;
  final RequestStatus requestStatus;
  final String usrename;
  final date;
  const RequestShortcut({
    super.key,
    required this.id,
    required this.requestStatus,
    required this.usrename,
    this.date,
  });
  @override
  Widget build(BuildContext context) {
    return Card();
  }
}
