import 'package:get/get.dart';

import '../../domain/entities/attendance_summary_overview.dart';
import '../../domain/entities/my_attendance_record.dart';
import '../../domain/entities/my_summary.dart';
import '../../domain/entities/online_attendance_status.dart';
import '../../domain/usecases/get_my_attendance_history_usecase.dart';
import '../../domain/usecases/get_my_summary_usecase.dart';
import '../../domain/usecases/get_my_full_summary_usecase.dart';
import '../../domain/usecases/get_online_status_usecase.dart';
import '../../domain/usecases/online_check_in_usecase.dart';
import '../../domain/usecases/online_check_out_usecase.dart';
import 'auth_controller.dart';

class SelfAttendanceController extends GetxController {
  SelfAttendanceController({
    required this.getOnlineStatusUseCase,
    required this.getMySummaryUseCase,
    required this.getMyFullSummaryUseCase,
    required this.getMyAttendanceHistoryUseCase,
    required this.onlineCheckInUseCase,
    required this.onlineCheckOutUseCase,
  });

  final GetOnlineStatusUseCase getOnlineStatusUseCase;
  final GetMySummaryUseCase getMySummaryUseCase;
  final GetMyFullSummaryUseCase getMyFullSummaryUseCase;
  final GetMyAttendanceHistoryUseCase getMyAttendanceHistoryUseCase;
  final OnlineCheckInUseCase onlineCheckInUseCase;
  final OnlineCheckOutUseCase onlineCheckOutUseCase;

  final Rx<OnlineAttendanceStatus?> onlineStatus = Rx<OnlineAttendanceStatus?>(
    null,
  );
  final Rx<AttendanceSummaryOverview?> mySummary =
      Rx<AttendanceSummaryOverview?>(null);
  final Rx<MySummary?> fullMySummary = Rx<MySummary?>(null);
  final RxList<MyAttendanceRecord> history = <MyAttendanceRecord>[].obs;

  DateTime? summaryFromDate;
  DateTime? summaryToDate;

  final RxBool isStatusLoading = false.obs;
  final RxBool isSummaryLoading = false.obs;
  final RxBool isHistoryLoading = false.obs;
  final RxBool isCheckInProcessing = false.obs;
  final RxBool isCheckOutProcessing = false.obs;
  final RxnString errorMessage = RxnString();

  bool get isEmployee {
    final user = Get.find<AuthController>().session.value?.user;
    // Allow both employees and admins to access employee features
    // Admins can also be employees and should have access to their own attendance
    return user != null && (user.isEmployee || user.isAdmin);
  }

  @override
  void onInit() {
    super.onInit();
    if (isEmployee) {
      refreshAll();
    }
  }

  Future<void> refreshAll() async {
    await Future.wait(<Future<void>>[
      loadOnlineStatus(),
      loadSummary(),
      loadHistory(),
    ]);
  }

  Future<void> loadOnlineStatus() async {
    if (!isEmployee) return;
    try {
      isStatusLoading.value = true;
      final OnlineAttendanceStatus status = await getOnlineStatusUseCase();
      onlineStatus.value = status;
    } catch (error) {
      errorMessage.value = error.toString();
    } finally {
      isStatusLoading.value = false;
    }
  }

  Future<void> loadSummary() async {
    if (!isEmployee) return;
    try {
      isSummaryLoading.value = true;
      final AttendanceSummaryOverview summary = await getMySummaryUseCase(
        from: summaryFromDate,
        to: summaryToDate,
      );
      mySummary.value = summary;

      // Also load full summary
      final MySummary fullSummary = await getMyFullSummaryUseCase(
        from: summaryFromDate,
        to: summaryToDate,
      );
      fullMySummary.value = fullSummary;
    } catch (error) {
      errorMessage.value = error.toString();
    } finally {
      isSummaryLoading.value = false;
    }
  }

  Future<void> loadSummaryWithDates(DateTime? from, DateTime? to) async {
    summaryFromDate = from;
    summaryToDate = to;
    await loadSummary();
  }

  Future<void> loadHistory() async {
    if (!isEmployee) return;
    try {
      isHistoryLoading.value = true;
      final List<MyAttendanceRecord> records =
          await getMyAttendanceHistoryUseCase(limit: 10);
      history.assignAll(records);
    } catch (error) {
      errorMessage.value = error.toString();
    } finally {
      isHistoryLoading.value = false;
    }
  }

  Future<void> checkIn() async {
    if (!isEmployee) return;

    // Ensure online status is loaded
    if (onlineStatus.value == null) {
      await loadOnlineStatus();
    }

    // Check if user can check in
    final status = onlineStatus.value;
    if (status?.canCheckIn != true) {
      Get.snackbar(
        'Cannot Check In',
        'You cannot check in at this time. Please check your attendance status.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isCheckInProcessing.value = true;

      // Call the online check-in API endpoint
      await onlineCheckInUseCase();

      // Show success message
      Get.snackbar(
        'Check-in Successful',
        'You have been checked in successfully.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );

      // Refresh status and summary
      await loadOnlineStatus();
      await loadSummary();
      await loadHistory();
    } catch (error) {
      errorMessage.value = error.toString();
      Get.snackbar(
        'Error',
        'Failed to check in: ${error.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isCheckInProcessing.value = false;
    }
  }

  Future<void> checkOut() async {
    if (!isEmployee) return;

    // Ensure online status is loaded
    if (onlineStatus.value == null) {
      await loadOnlineStatus();
    }

    // Check if user can check out
    final status = onlineStatus.value;
    if (status?.canCheckOut != true) {
      Get.snackbar(
        'Cannot Check Out',
        'You cannot check out at this time. Please check your attendance status.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isCheckOutProcessing.value = true;

      // Call the online check-out API endpoint
      await onlineCheckOutUseCase();

      // Show success message
      Get.snackbar(
        'Check-out Successful',
        'You have been checked out successfully.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );

      // Refresh status and summary
      await loadOnlineStatus();
      await loadSummary();
      await loadHistory();
    } catch (error) {
      errorMessage.value = error.toString();
      final String message = error.toString();
      if (message.toLowerCase().contains('check-in') &&
          message.toLowerCase().contains('first')) {
        Get.snackbar(
          'Cannot Check Out',
          'Please check in first, then try to check out.',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to check out: ${error.toString()}',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
      // Refresh status so buttons reflect the current allowed action
      await loadOnlineStatus();
    } finally {
      isCheckOutProcessing.value = false;
    }
  }
}
