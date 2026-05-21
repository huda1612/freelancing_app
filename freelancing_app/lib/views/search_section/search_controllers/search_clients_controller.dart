import 'package:dartz/dartz.dart';
import 'package:freelancing_platform/core/classes/status_classes.dart';
import 'package:freelancing_platform/core/classes/user_session.dart';
import 'package:freelancing_platform/core/constants/app_routes.dart';
import 'package:freelancing_platform/core/constants/data_constsnats/user_roles.dart';
import 'package:freelancing_platform/data/services/user_service.dart';
import 'package:freelancing_platform/models/user_collections/user_model.dart';
import 'package:get/get.dart';

class SearchClientsController extends GetxController {
  final UserService _userService = UserService();

  final pageState = StatusClasses.isloading.obs;
  final users = <UserModel>[].obs;
  final searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchSuggestedClients();
  }

  List<UserModel> get filteredUsers {
    final query = searchQuery.value.trim().toLowerCase();
    final currentUid = UserSession.uid ?? '';
    final baseUsers =
        users.where((u) => u.uid.trim() != currentUid.trim()).toList();
    if (query.isEmpty) return baseUsers;

    return baseUsers.where((user) {
      final fullName = '${user.fname} ${user.lname}'.trim().toLowerCase();
      final username = user.username.toLowerCase();
      return fullName.contains(query) || username.contains(query);
    }).toList();
  }

  Future<void> fetchSuggestedClients() async {
    pageState.value = StatusClasses.isloading;

    final uid = UserSession.uid;
    if (uid == null) {
      pageState.value = StatusClasses.unauthorized;
      return;
    }

    final currentUserResponse = await _userService.fetchUserData2(uid);
    final String? countryCode = currentUserResponse.fold((_) => null, (u) => u.countryCode);

    final Either<StatusClasses, List<UserModel>> response =
        await _userService.fetchUsersByRole(
      role: UserRole.client,
      countryCode: countryCode,
    );

    response.fold((error) {
      pageState.value = error;
    }, (results) {
      final filtered = results.where((u) => u.uid != uid).toList()
        ..sort((a, b) => b.rating.compareTo(a.rating));
      users.assignAll(filtered);
      pageState.value = StatusClasses.success;
    });
  }

  void onSearchChanged(String value) {
    searchQuery.value = value;
  }

  void openProfile(UserModel user) {
    if (user.uid.trim() == (UserSession.uid ?? '').trim()) return;
    Get.toNamed(
      AppRoutes.userProfile,
      arguments: {'userId': user.uid},
    );
  }
}
