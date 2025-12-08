import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../domain/entities/user_summary.dart';
import '../../domain/usecases/get_all_users_summary_report_usecase.dart';
import '../../domain/usecases/get_user_report_usecase.dart';

class ReportController extends GetxController {
  ReportController({
    required GetAllUsersSummaryReportUseCase getAllUsersSummaryReportUseCase,
    required GetUserReportUseCase getUserReportUseCase,
  }) : _getAllUsersSummaryReportUseCase = getAllUsersSummaryReportUseCase,
       _getUserReportUseCase = getUserReportUseCase;

  final GetAllUsersSummaryReportUseCase _getAllUsersSummaryReportUseCase;
  final GetUserReportUseCase _getUserReportUseCase;

  final RxList<UserSummary> userSummaries = <UserSummary>[].obs;
  final Rx<Map<String, dynamic>?> userReport = Rx<Map<String, dynamic>?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final Rx<DateTime> selectedFromDate = DateTime.now().obs;
  final Rx<DateTime> selectedToDate = DateTime.now().obs;
  final RxString searchQuery = ''.obs;
  
  // Filtered summaries based on search query
  List<UserSummary> get filteredSummaries {
    final String query = searchQuery.value.trim();
    if (query.isEmpty) {
      return userSummaries;
    }
    
    final String lowerQuery = query.toLowerCase();
    return userSummaries.where((UserSummary summary) {
      // Search by name
      if (summary.name.toLowerCase().contains(lowerQuery)) {
        return true;
      }
      
      // Search by employee number
      if (summary.employeeNumber != null &&
          summary.employeeNumber!.toLowerCase().contains(lowerQuery)) {
        return true;
      }
      
      return false;
    }).toList();
  }

  @override
  void onInit() {
    super.onInit();
    // Default to last 30 days
    final DateTime now = DateTime.now();
    selectedFromDate.value = now.subtract(const Duration(days: 30));
    selectedToDate.value = now;
    loadAllUsersSummary();
  }

  Future<void> loadAllUsersSummary() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      if (kDebugMode) {
        debugPrint('=== Loading Reports (loadAllUsersSummary) ===');
        debugPrint('Calling GetAllUsersSummaryReportUseCase');
        debugPrint('From: ${selectedFromDate.value}');
        debugPrint('To: ${selectedToDate.value}');
      }
      
      final List<UserSummary> result = await _getAllUsersSummaryReportUseCase(
        from: selectedFromDate.value,
        to: selectedToDate.value,
      );
      
      if (kDebugMode) {
        debugPrint('Reports loaded: ${result.length} items');
      }
      
      userSummaries.value = result;
      
      if (kDebugMode && result.isEmpty) {
        debugPrint('WARNING: Reports list is empty');
      }
    } catch (e, stackTrace) {
      if (kDebugMode) {
        debugPrint('Error loading reports: $e');
        debugPrint('Stack trace: $stackTrace');
      }
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadUserReport(int userId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final Map<String, dynamic> result = await _getUserReportUseCase(
        userId: userId,
        from: selectedFromDate.value,
        to: selectedToDate.value,
      );
      userReport.value = result;
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }

  void updateDateRange(DateTime from, DateTime to) {
    selectedFromDate.value = from;
    selectedToDate.value = to;
    loadAllUsersSummary();
  }
}
