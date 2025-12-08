import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../domain/entities/user_summary.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/report_controller.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ReportController controller = Get.find<ReportController>();
    final AuthController authController = Get.find<AuthController>();
    final String? userRole = authController.session.value?.user.role;
    final bool isAdmin = userRole == 'admin';

    if (!isAdmin) {
      return Scaffold(
        appBar: AppBar(title: const Text('Reports')),
        body: const Center(child: Text('Access denied. Admin only.')),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Reports'),
        actions: <Widget>[
          Obx(() => _buildSearchIcon(context, controller)),
          IconButton(
            icon: const Icon(Icons.date_range),
            tooltip: 'Select Date Range',
            onPressed: () => _showDateRangePicker(context, controller),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  controller.errorMessage.value,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: controller.loadAllUsersSummary,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (controller.userSummaries.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Icon(Icons.bar_chart, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                Text(
                  'No data available',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Select a date range to view reports',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.loadAllUsersSummary,
          child: Column(
            children: <Widget>[
              // Search field
              Obx(() => _buildSearchField(context, controller)),
              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _buildDateRangeHeader(context, controller),
                      const SizedBox(height: 20),
                      _buildSummaryCards(context, controller),
                      const SizedBox(height: 24),
                      _buildSectionTitle(context, 'User Summaries'),
                      const SizedBox(height: 12),
                      if (controller.filteredSummaries.isEmpty)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: Column(
                              children: <Widget>[
                                Icon(
                                  Icons.search_off,
                                  size: 64,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No users found',
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(color: Colors.grey[600]),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Try adjusting your search',
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(color: Colors.grey[500]),
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        ...controller.filteredSummaries.map(
                          (UserSummary summary) => _buildUserSummaryCard(
                            context,
                            summary,
                            controller,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildDateRangeHeader(
    BuildContext context,
    ReportController controller,
  ) {
    final DateFormat dateFormat = DateFormat('MMM d, yyyy');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(
                Icons.calendar_today,
                size: 18,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 12),
              Text(
                '${dateFormat.format(controller.selectedFromDate.value)} - ${dateFormat.format(controller.selectedToDate.value)}',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          IconButton(
            icon: Icon(
              Icons.edit,
              size: 20,
              color: Theme.of(context).colorScheme.primary,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () => _showDateRangePicker(context, controller),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchIcon(BuildContext context, ReportController controller) {
    final bool isSearchActive =
        controller.searchQuery.value.isNotEmpty &&
        controller.searchQuery.value.trim().isNotEmpty;

    return IconButton(
      icon: Icon(
        isSearchActive ? Icons.search : Icons.search_outlined,
        color: isSearchActive ? Theme.of(context).colorScheme.primary : null,
      ),
      tooltip: 'Search',
      onPressed: () {
        // Toggle search field visibility
        if (controller.searchQuery.value.isEmpty ||
            controller.searchQuery.value.trim().isEmpty) {
          // Show search field - trigger with a space so it's not empty but also not visible
          // We'll handle this in _buildSearchField
          controller.searchQuery.value = ' ';
        } else {
          // Clear search
          controller.searchQuery.value = '';
        }
      },
    );
  }

  Widget _buildSearchField(BuildContext context, ReportController controller) {
    // Show search field if query is not empty (including single space for initial show)
    if (controller.searchQuery.value.isEmpty) {
      return const SizedBox.shrink();
    }

    return _SearchTextField(controller: controller);
  }

  Widget _buildSummaryCards(BuildContext context, ReportController controller) {
    final List<UserSummary> summaries = controller.filteredSummaries;
    final double totalWorked = summaries.fold<double>(
      0,
      (double sum, UserSummary s) => sum + (s.totalWorkedHours ?? 0),
    );
    final double totalMissing = summaries.fold<double>(
      0,
      (double sum, UserSummary s) => sum + (s.totalMissingHours ?? 0),
    );
    final double totalOvertime = summaries.fold<double>(
      0,
      (double sum, UserSummary s) => sum + (s.totalOvertimeHours ?? 0),
    );
    final int totalAbsent = summaries.fold<int>(
      0,
      (int sum, UserSummary s) => sum + (s.absentDays ?? 0),
    );

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool isNarrow = constraints.maxWidth < 520;
        final double itemWidth = isNarrow
            ? constraints.maxWidth
            : (constraints.maxWidth - 12) / 2;

        final List<Widget> cards = <Widget>[
          _buildStatCard(
            context,
            'Worked',
            '${totalWorked.toStringAsFixed(1)}',
            'h',
            Icons.access_time,
            fixedWidth: itemWidth,
          ),
          _buildStatCard(
            context,
            'Overtime',
            '${totalOvertime.toStringAsFixed(1)}',
            'h',
            Icons.trending_up,
            fixedWidth: itemWidth,
          ),
          _buildStatCard(
            context,
            'Missing',
            '${totalMissing.toStringAsFixed(1)}',
            'h',
            Icons.warning_amber,
            fixedWidth: itemWidth,
          ),
          _buildStatCard(
            context,
            'Absent',
            totalAbsent.toString(),
            'days',
            Icons.event_busy,
            fixedWidth: itemWidth,
          ),
        ];

        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: cards,
        );
      },
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    String unit,
    IconData icon, {
    double? fixedWidth,
  }) {
    final Color primaryColor = Theme.of(context).colorScheme.primary;

    return Container(
      width: fixedWidth,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: primaryColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: primaryColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: primaryColor, size: 18),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                value,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              const SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Text(
                  unit,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: primaryColor.withValues(alpha: 0.7),
                    fontWeight: FontWeight.w500,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey[600],
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: Colors.grey[800],
        ),
      ),
    );
  }

  Widget _buildUserSummaryCard(
    BuildContext context,
    UserSummary summary,
    ReportController controller,
  ) {
    final Color primaryColor = Theme.of(context).colorScheme.primary;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: InkWell(
        onTap: () => _showUserReportDetails(context, summary, controller),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          summary.name,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        if (summary.employeeNumber != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            'Emp #${summary.employeeNumber}',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right, color: Colors.grey[400], size: 20),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: <Widget>[
                  Expanded(
                    child: _buildMetricChip(
                      context,
                      'Worked',
                      '${(summary.totalWorkedHours ?? 0).toStringAsFixed(1)}h',
                      primaryColor,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildMetricChip(
                      context,
                      'Overtime',
                      '${(summary.totalOvertimeHours ?? 0).toStringAsFixed(1)}h',
                      primaryColor,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildMetricChip(
                      context,
                      'Missing',
                      '${(summary.totalMissingHours ?? 0).toStringAsFixed(1)}h',
                      primaryColor,
                    ),
                  ),
                ],
              ),
              if (summary.absentDays != null && summary.absentDays! > 0) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(Icons.event_busy, size: 14, color: Colors.red[700]),
                      const SizedBox(width: 6),
                      Text(
                        '${summary.absentDays} absent day${summary.absentDays! > 1 ? 's' : ''}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.red[700],
                          fontWeight: FontWeight.w500,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricChip(
    BuildContext context,
    String label,
    String value,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
      ),
      child: Column(
        children: <Widget>[
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showDateRangePicker(
    BuildContext context,
    ReportController controller,
  ) async {
    final DateTime now = DateTime.now();
    final DateTime firstDate = now.subtract(const Duration(days: 365));
    final DateTime lastDate = now;

    // Clamp the initial dates to ensure they're within valid range
    final DateTime initialStart =
        controller.selectedFromDate.value.isBefore(firstDate)
        ? firstDate
        : controller.selectedFromDate.value.isAfter(lastDate)
        ? lastDate
        : controller.selectedFromDate.value;

    final DateTime initialEnd =
        controller.selectedToDate.value.isBefore(firstDate)
        ? firstDate
        : controller.selectedToDate.value.isAfter(lastDate)
        ? lastDate
        : controller.selectedToDate.value;

    // Ensure end is not before start
    final DateTime clampedEnd = initialEnd.isBefore(initialStart)
        ? initialStart
        : initialEnd;

    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: firstDate,
      lastDate: lastDate,
      initialDateRange: DateTimeRange(start: initialStart, end: clampedEnd),
    );
    if (picked != null) {
      controller.updateDateRange(picked.start, picked.end);
    }
  }

  Future<void> _showUserReportDetails(
    BuildContext context,
    UserSummary summary,
    ReportController controller,
  ) async {
    await controller.loadUserReport(summary.userId);
    if (context.mounted) {
      await showDialog(
        context: context,
        builder: (BuildContext context) => Obx(() {
          final Map<String, dynamic>? report = controller.userReport.value;
          if (controller.isLoading.value) {
            return const AlertDialog(
              content: SizedBox(
                height: 100,
                child: Center(child: CircularProgressIndicator()),
              ),
            );
          }
          if (report == null) {
            return AlertDialog(
              title: Text(summary.name),
              content: const Text('No detailed report available.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Close'),
                ),
              ],
            );
          }
          return AlertDialog(
            title: Text(summary.name),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  _buildReportDetailRow(
                    'Total Worked Hours',
                    '${summary.totalWorkedHours?.toStringAsFixed(1) ?? '0'}h',
                  ),
                  _buildReportDetailRow(
                    'Total Missing Hours',
                    '${summary.totalMissingHours?.toStringAsFixed(1) ?? '0'}h',
                  ),
                  _buildReportDetailRow(
                    'Total Overtime Hours',
                    '${summary.totalOvertimeHours?.toStringAsFixed(1) ?? '0'}h',
                  ),
                  if (summary.effectiveMissingHours != null)
                    _buildReportDetailRow(
                      'Effective Missing Hours',
                      '${summary.effectiveMissingHours!.toStringAsFixed(1)}h',
                    ),
                  if (summary.effectiveOvertimeHours != null)
                    _buildReportDetailRow(
                      'Effective Overtime Hours',
                      '${summary.effectiveOvertimeHours!.toStringAsFixed(1)}h',
                    ),
                  if (summary.overtimeAmountIqd != null)
                    _buildReportDetailRow(
                      'Overtime Amount (IQD)',
                      '${summary.overtimeAmountIqd}',
                    ),
                  if (summary.absentDays != null)
                    _buildReportDetailRow(
                      'Absent Days',
                      '${summary.absentDays}',
                    ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ],
          );
        }),
      );
    }
  }

  Widget _buildReportDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }
}

class _SearchTextField extends StatefulWidget {
  const _SearchTextField({required this.controller});

  final ReportController controller;

  @override
  State<_SearchTextField> createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<_SearchTextField> {
  late TextEditingController _textController;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    // Initialize with current value if any
    if (widget.controller.searchQuery.value.isNotEmpty &&
        widget.controller.searchQuery.value.trim().isNotEmpty) {
      _textController.text = widget.controller.searchQuery.value;
      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Sync controller value with reactive value
    if (!_isInitialized && widget.controller.searchQuery.value.isNotEmpty) {
      final String value = widget.controller.searchQuery.value.trim();
      if (value.isNotEmpty && _textController.text != value) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _textController.text = value;
            _isInitialized = true;
          }
        });
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: TextField(
        controller: _textController,
        autofocus: !_isInitialized, // Autofocus when first opened
        decoration: InputDecoration(
          hintText: 'Search by name or employee number...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _textController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _textController.clear();
                    widget.controller.searchQuery.value = '';
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 2,
            ),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
        onChanged: (String value) {
          widget.controller.searchQuery.value = value;
          setState(() {}); // Update suffix icon visibility
        },
      ),
    );
  }
}
