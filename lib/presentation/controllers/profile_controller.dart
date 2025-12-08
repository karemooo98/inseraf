import 'package:get/get.dart';

import '../../domain/entities/auth_session.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/fetch_profile_usecase.dart';
import '../../domain/usecases/update_profile_usecase.dart';
import 'auth_controller.dart';

class ProfileController extends GetxController {
  ProfileController({
    required this.fetchProfileUseCase,
    required this.updateProfileUseCase,
  });

  final FetchProfileUseCase fetchProfileUseCase;
  final UpdateProfileUseCase updateProfileUseCase;

  final Rx<User?> profile = Rx<User?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isUpdating = false.obs;
  final RxnString errorMessage = RxnString();

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  Future<void> loadProfile() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final User user = await fetchProfileUseCase();
      profile.value = user;
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateProfile({
    String? name,
    String? email,
    String? password,
    List<String>? weekendDays,
  }) async {
    try {
      isUpdating.value = true;
      errorMessage.value = '';
      final User updatedUser = await updateProfileUseCase(
        name: name,
        email: email,
        password: password,
        weekendDays: weekendDays,
      );
      profile.value = updatedUser;

      // Update auth session
      final AuthController authController = Get.find<AuthController>();
      if (authController.session.value != null) {
        authController.session.value = AuthSession(
          token: authController.session.value!.token,
          user: updatedUser,
        );
      }

      return true;
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      isUpdating.value = false;
    }
  }
}
