import 'package:get/get.dart';

import '../../domain/entities/user_request.dart';
import '../../domain/usecases/approve_request_usecase.dart';
import '../../domain/usecases/create_request_usecase.dart';
import '../../domain/usecases/get_all_requests_usecase.dart';
import '../../domain/usecases/get_my_requests_usecase.dart';
import '../../domain/usecases/get_request_by_id_usecase.dart';
import 'auth_controller.dart';

class RequestController extends GetxController {
  RequestController({
    required this.getMyRequestsUseCase,
    required this.getAllRequestsUseCase,
    required this.createRequestUseCase,
    required this.approveRequestUseCase,
    required this.getRequestByIdUseCase,
  });

  final GetMyRequestsUseCase getMyRequestsUseCase;
  final GetAllRequestsUseCase getAllRequestsUseCase;
  final CreateRequestUseCase createRequestUseCase;
  final ApproveRequestUseCase approveRequestUseCase;
  final GetRequestByIdUseCase getRequestByIdUseCase;

  final RxList<UserRequest> myRequests = <UserRequest>[].obs;
  final RxList<UserRequest> pendingApprovals = <UserRequest>[].obs;
  final Rx<UserRequest?> selectedRequest = Rx<UserRequest?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isSubmitting = false.obs;
  final RxnString errorMessage = RxnString();

  bool get canApprove {
    final authController = Get.find<AuthController>();
    final user = authController.session.value?.user;
    return user?.isAdmin == true || user?.isManager == true;
  }

  Future<void> loadMyRequests() async {
    try {
      isLoading.value = true;
      errorMessage.value = null;
      final List<UserRequest> requests = await getMyRequestsUseCase();
      myRequests.assignAll(requests);
    } catch (error) {
      errorMessage.value = error.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadPendingApprovals() async {
    if (!canApprove) return;
    try {
      final List<UserRequest> approvals = await getAllRequestsUseCase();
      pendingApprovals.assignAll(approvals.where((request) => request.isPending));
    } catch (error) {
      errorMessage.value = error.toString();
    }
  }

  Future<void> submitRequest(CreateRequestParams params) async {
    try {
      isSubmitting.value = true;
      final UserRequest created = await createRequestUseCase(params);
      myRequests.insert(0, created);
    } catch (error) {
      errorMessage.value = error.toString();
      rethrow;
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> approveRequest(ApproveRequestParams params) async {
    if (!canApprove) return;
    try {
    final UserRequest updated = await approveRequestUseCase(params);
    final int index = pendingApprovals.indexWhere((request) => request.id == updated.id);
    if (index != -1) {
      pendingApprovals[index] = updated;
      if (!updated.isPending) {
        pendingApprovals.removeAt(index);
      }
    }
    final int myIndex = myRequests.indexWhere((request) => request.id == updated.id);
    if (myIndex != -1) {
      myRequests[myIndex] = updated;
      }
    } catch (error) {
      errorMessage.value = error.toString();
      rethrow; // Re-throw to let the UI handle it
    }
  }

  Future<void> loadRequestById(int requestId) async {
    try {
      isLoading.value = true;
      errorMessage.value = null;
      final UserRequest request = await getRequestByIdUseCase(requestId);
      selectedRequest.value = request;
    } catch (error) {
      errorMessage.value = error.toString();
    } finally {
      isLoading.value = false;
    }
  }
}

