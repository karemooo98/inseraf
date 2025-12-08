import 'package:get/get.dart';

import '../../domain/entities/attendance_record.dart';
import '../../domain/entities/attendance_summary.dart';
import '../../domain/entities/user_summary.dart';
import '../../domain/usecases/get_all_users_summary_usecase.dart';
import '../../domain/usecases/get_attendance_by_date_usecase.dart';
import '../../domain/usecases/get_attendance_summary_usecase.dart';
import '../../domain/usecases/get_my_attendance_usecase.dart';
import '../../domain/usecases/update_attendance_usecase.dart';

class AttendanceController extends GetxController {
  AttendanceController({
    required this.getAttendanceByDateUseCase,
    required this.getAttendanceSummaryUseCase,
    required this.getMyAttendanceUseCase,
    required this.getAllUsersSummaryUseCase,
    required this.updateAttendanceUseCase,
  });

  final GetAttendanceByDateUseCase getAttendanceByDateUseCase;
  final GetAttendanceSummaryUseCase getAttendanceSummaryUseCase;
  final GetMyAttendanceUseCase getMyAttendanceUseCase;
  final GetAllUsersSummaryUseCase getAllUsersSummaryUseCase;
  final UpdateAttendanceUseCase updateAttendanceUseCase;

  final Rx<DateTime> selectedDate = DateTime.now().obs;
  final RxList<AttendanceRecord> attendanceByDate = <AttendanceRecord>[].obs;
  final Rx<AttendanceSummary?> summary = Rx<AttendanceSummary?>(null);
  final RxList<AttendanceRecord> myRecentAttendance = <AttendanceRecord>[].obs;
  final RxList<UserSummary> allUsersSummary = <UserSummary>[].obs;

  final RxBool isAttendanceLoading = false.obs;
  final RxBool isSummaryLoading = false.obs;
  final RxBool isOverviewLoading = false.obs;
  final RxBool isUpdating = false.obs;
  final RxnString errorMessage = RxnString();

  Future<void> refreshForDate(DateTime date) async {
    selectedDate.value = date;
    await Future.wait(<Future<void>>[
      loadAttendanceForDate(),
      loadAttendanceSummary(),
    ]);
  }

  Future<void> loadAttendanceForDate() async {
    try {
      isAttendanceLoading.value = true;
      errorMessage.value = null;
      final List<AttendanceRecord> records =
          await getAttendanceByDateUseCase(selectedDate.value);
      attendanceByDate.assignAll(records);
    } catch (error) {
      errorMessage.value = error.toString();
    } finally {
      isAttendanceLoading.value = false;
    }
  }

  Future<void> loadAttendanceSummary() async {
    try {
      isSummaryLoading.value = true;
      final AttendanceSummary data = await getAttendanceSummaryUseCase(selectedDate.value);
      summary.value = data;
    } catch (error) {
      errorMessage.value = error.toString();
    } finally {
      isSummaryLoading.value = false;
    }
  }

  Future<void> loadMyRecentAttendance() async {
    try {
      final List<AttendanceRecord> data = await getMyAttendanceUseCase(limit: 10);
      myRecentAttendance.assignAll(data);
    } catch (error) {
      errorMessage.value = error.toString();
    }
  }

  Future<void> loadAllUsersSummary({DateTime? from, DateTime? to}) async {
    try {
      isOverviewLoading.value = true;
      final List<UserSummary> data =
          await getAllUsersSummaryUseCase(from: from, to: to);
      allUsersSummary.assignAll(data);
    } catch (error) {
      errorMessage.value = error.toString();
    } finally {
      isOverviewLoading.value = false;
    }
  }

  Future<void> updateAttendance({
    required int userId,
    required String date,
    required String status,
    String? checkIn,
    String? checkOut,
    String? hoursAdjustmentType,
    double? hoursAdjustment,
    String? reason,
  }) async {
    try {
      isUpdating.value = true;
      errorMessage.value = null;
      await updateAttendanceUseCase(
        userId: userId,
        date: date,
        status: status,
        checkIn: checkIn,
        checkOut: checkOut,
        hoursAdjustmentType: hoursAdjustmentType,
        hoursAdjustment: hoursAdjustment,
        reason: reason,
      );
      // Refresh the attendance list after update
      await refreshForDate(selectedDate.value);
    } catch (error) {
      errorMessage.value = error.toString();
      rethrow;
    } finally {
      isUpdating.value = false;
    }
  }
}




