import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:intl/intl.dart';

import '../../../domain/entities/attendance_record.dart';
import '../../../domain/entities/attendance_summary.dart';
import '../../controllers/attendance_controller.dart';

class AttendanceManagementPage extends StatefulWidget {
  const AttendanceManagementPage({super.key});

  @override
  State<AttendanceManagementPage> createState() =>
      _AttendanceManagementPageState();
}

class _AttendanceManagementPageState extends State<AttendanceManagementPage> {
  late final AttendanceController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<AttendanceController>();
    // Always refresh data when page opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.refreshForDate(DateTime.now());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Attendance Management'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () => _showDatePicker(context, controller),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isAttendanceLoading.value ||
            controller.isSummaryLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.value != null &&
            controller.errorMessage.value!.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red[300],
                ),
                const SizedBox(height: 16),
                Text(
                  controller.errorMessage.value ?? 'Unknown error',
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => controller.refreshForDate(
                    controller.selectedDate.value,
                  ),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => controller.refreshForDate(
            controller.selectedDate.value,
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildDateHeader(context, controller),
                const SizedBox(height: 20),
                _buildSummaryCards(context, controller),
                const SizedBox(height: 24),
                _buildSectionTitle(context, 'All Employees'),
                const SizedBox(height: 12),
                _buildAttendanceList(context, controller),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildDateHeader(
    BuildContext context,
    AttendanceController controller,
  ) {
    final DateFormat dateFormat = DateFormat('EEEE, MMM d, yyyy');
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
                dateFormat.format(controller.selectedDate.value),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
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
            onPressed: () => _showDatePicker(context, controller),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards(
    BuildContext context,
    AttendanceController controller,
  ) {
    final AttendanceSummary? summary = controller.summary.value;
    if (summary == null) {
      return const SizedBox.shrink();
    }

    final Color primaryColor = Theme.of(context).colorScheme.primary;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool isNarrow = constraints.maxWidth < 520;
        final double itemWidth =
            isNarrow ? constraints.maxWidth : (constraints.maxWidth - 12) / 2;

        final List<Widget> cards = <Widget>[
          _buildStatCard(
            context,
            'Present',
            summary.present.toString(),
            'employees',
            Icons.check_circle,
            primaryColor,
            width: itemWidth,
          ),
          _buildStatCard(
            context,
            'Absent',
            summary.absent.toString(),
            'employees',
            Icons.event_busy,
            primaryColor,
            width: itemWidth,
          ),
          _buildStatCard(
            context,
            'Missing Checkout',
            summary.missingCheckout.toString(),
            'employees',
            Icons.warning_amber,
            primaryColor,
            width: itemWidth,
          ),
          _buildStatCard(
            context,
            'Left Early',
            summary.leftEarly.toString(),
            'employees',
            Icons.trending_down,
            primaryColor,
            width: itemWidth,
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
    IconData icon,
    Color color, {
    double? width,
  }) {
  ) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
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
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 18),
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
                      color: color,
                    ),
              ),
              const SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Text(
                  unit,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: color.withValues(alpha: 0.7),
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

  Widget _buildAttendanceList(
    BuildContext context,
    AttendanceController controller,
  ) {
    final List<AttendanceRecord> records = controller.attendanceByDate;

    if (records.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: <Widget>[
            Icon(
              Icons.info_outline,
              size: 48,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No attendance records for this date',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: records
          .map((AttendanceRecord record) => _buildEmployeeCard(context, record))
          .toList(),
    );
  }

  Widget _buildEmployeeCard(BuildContext context, AttendanceRecord record) {
    final Map<String, dynamic> badge = _statusBadge(record);
    final String idLabel = record.userEmployeeNumber?.isNotEmpty == true
        ? record.userEmployeeNumber!
        : record.userId.toString();

    return InkWell(
      onTap: () => _showEditAttendanceDialog(context, record),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CircleAvatar(
            radius: 20,
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: Text(
              record.userName.isNotEmpty
                  ? record.userName[0].toUpperCase()
                  : '?',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Emp #$idLabel',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  record.userName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: <Widget>[
                    _subInfo(Symbols.login, _formatTime(record.firstCheckIn)),
                    _subInfo(Symbols.logout, _formatTime(record.lastCheckOut)),
                    _subInfo(
                      Symbols.timer,
                      _formatDuration(record.workedHours),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              const SizedBox(height: 6),
              Text(
                '${record.workedHours?.toStringAsFixed(1) ?? '0'}h',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: badge['color'] as Color,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  badge['label'] as String,
                  style: TextStyle(
                    color: badge['textColor'] as Color,
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      ),
    );
  }

  Future<void> _showEditAttendanceDialog(
    BuildContext context,
    AttendanceRecord record,
  ) async {
    final DateFormat dateFormat = DateFormat('MMM d, yyyy');
    final DateFormat timeFormat = DateFormat('HH:mm');
    String selectedStatus = record.status ?? 'present';
    final bool isNewRecord = record.id == null;

    // Parse existing times or use empty strings
    String checkInTime = '';
    String checkOutTime = '';
    if (record.firstCheckIn != null && record.firstCheckIn!.isNotEmpty) {
      try {
        // Try to parse as time-only string (HH:mm)
        final RegExp timePattern = RegExp(r'^(\d{1,2}):(\d{2})$');
        final Match? match = timePattern.firstMatch(record.firstCheckIn!);
        if (match != null) {
          checkInTime = record.firstCheckIn!;
        } else {
          // Try to parse as full datetime
          final DateTime? dt = DateTime.tryParse(record.firstCheckIn!);
          if (dt != null) {
            checkInTime = timeFormat.format(dt);
          }
        }
      } catch (_) {
        // Keep empty if parsing fails
      }
    }
    if (record.lastCheckOut != null && record.lastCheckOut!.isNotEmpty) {
      try {
        final RegExp timePattern = RegExp(r'^(\d{1,2}):(\d{2})$');
        final Match? match = timePattern.firstMatch(record.lastCheckOut!);
        if (match != null) {
          checkOutTime = record.lastCheckOut!;
        } else {
          final DateTime? dt = DateTime.tryParse(record.lastCheckOut!);
          if (dt != null) {
            checkOutTime = timeFormat.format(dt);
          }
        }
      } catch (_) {
        // Keep empty if parsing fails
      }
    }

    final TextEditingController checkInController =
        TextEditingController(text: checkInTime);
    final TextEditingController checkOutController =
        TextEditingController(text: checkOutTime);
    final TextEditingController hoursAdjustmentController =
        TextEditingController(text: '0');
    final TextEditingController reasonController = TextEditingController();
    String? hoursAdjustmentType;

    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text('Edit Attendance'),
                IconButton(
                  icon: const Icon(Icons.close),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            content: SizedBox(
              width: double.maxFinite,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                  Text(
                    '${dateFormat.format(DateTime.parse(record.date))} - ${record.userName}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  if (isNewRecord) ...[
                    const SizedBox(height: 8),
                    Text(
                      'New Record',
                      style: TextStyle(
                        color: Colors.red[700],
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  Text(
                    'Status',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: selectedStatus,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[50],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    items: <String>[
                      'present',
                      'absent',
                      'day_off',
                      'on_leave',
                      'partial',
                      'late',
                      'missing_checkout',
                      'overnight',
                      'still_working',
                    ].map<DropdownMenuItem<String>>((String value) {
                      String displayName = value;
                      switch (value) {
                        case 'day_off':
                          displayName = 'Day Off';
                          break;
                        case 'on_leave':
                          displayName = 'On Leave';
                          break;
                        case 'missing_checkout':
                          displayName = "Didn't Check Out";
                          break;
                        case 'still_working':
                          displayName = 'Still Working';
                          break;
                        default:
                          displayName = value
                              .split('_')
                              .map((String word) =>
                                  word[0].toUpperCase() + word.substring(1))
                              .join(' ');
                      }
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(displayName),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          selectedStatus = newValue;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  // Check In field
                  Text(
                    'Check In',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: checkInController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[50],
                      hintText: '--:--',
                      prefixIcon: const Icon(Icons.access_time, size: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    keyboardType: TextInputType.datetime,
                    onTap: () async {
                      final TimeOfDay? picked = await showTimePicker(
                        context: context,
                        initialTime: checkInController.text.isNotEmpty
                            ? _parseTime(checkInController.text)
                            : TimeOfDay.now(),
                      );
                      if (picked != null) {
                        setState(() {
                          checkInController.text =
                              '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  // Check Out field
                  Text(
                    'Check Out',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: checkOutController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[50],
                      hintText: '--:--',
                      prefixIcon: const Icon(Icons.access_time, size: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    keyboardType: TextInputType.datetime,
                    onTap: () async {
                      final TimeOfDay? picked = await showTimePicker(
                        context: context,
                        initialTime: checkOutController.text.isNotEmpty
                            ? _parseTime(checkOutController.text)
                            : TimeOfDay.now(),
                      );
                      if (picked != null) {
                        setState(() {
                          checkOutController.text =
                              '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  // Hours Adjustment section
                  Text(
                    'Hours Adjustment',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: DropdownButtonFormField<String>(
                          value: hoursAdjustmentType,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey[50],
                            hintText: 'Type',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.primary,
                                width: 2,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                          items: <String>['add', 'subtract']
                              .map<DropdownMenuItem<String>>(
                                (String value) => DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value == 'add' ? 'Add' : 'Subtract',
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              hoursAdjustmentType = newValue;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          controller: hoursAdjustmentController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey[50],
                            hintText: '0',
                            suffixText: 'Hours',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.primary,
                                width: 2,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                          keyboardType: TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Reason field
                  Text(
                    'Reason',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: reasonController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[50],
                      hintText: 'Enter reason for this change...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    maxLines: 3,
                  ),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: controller.isUpdating.value
                    ? null
                    : () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              Obx(
                () => FilledButton(
                  onPressed: controller.isUpdating.value
                      ? null
                      : () async {
                          Navigator.of(context).pop();
                          await _updateAttendance(
                            record,
                            selectedStatus,
                            checkInController.text.trim(),
                            checkOutController.text.trim(),
                            hoursAdjustmentType,
                            double.tryParse(
                              hoursAdjustmentController.text.trim(),
                            ),
                            reasonController.text.trim(),
                          );
                        },
                  child: controller.isUpdating.value
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text('Save'),
                ),
              ),
            ],
            );
          },
        );
      },
    ).whenComplete(() {
      // Ensure controllers are disposed even if dialog is dismissed unexpectedly
      checkInController.dispose();
      checkOutController.dispose();
      hoursAdjustmentController.dispose();
      reasonController.dispose();
    });
  }

  Future<void> _updateAttendance(
    AttendanceRecord record,
    String status,
    String checkIn,
    String checkOut,
    String? hoursAdjustmentType,
    double? hoursAdjustment,
    String reason,
  ) async {
    try {
      final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
      await controller.updateAttendance(
        userId: record.userId,
        date: dateFormat.format(DateTime.parse(record.date)),
        status: status,
        checkIn: checkIn.isNotEmpty ? checkIn : null,
        checkOut: checkOut.isNotEmpty ? checkOut : null,
        hoursAdjustmentType: hoursAdjustmentType,
        hoursAdjustment: hoursAdjustment,
        reason: reason.isNotEmpty ? reason : null,
      );
      if (mounted) {
        Get.snackbar(
          'Success',
          'Attendance updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
        );
      }
    } catch (e) {
      if (mounted) {
        Get.snackbar(
          'Error',
          'Failed to update attendance: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
        );
      }
    }
  }

  TimeOfDay _parseTime(String timeString) {
    try {
      final List<String> parts = timeString.split(':');
      if (parts.length == 2) {
        return TimeOfDay(
          hour: int.parse(parts[0]),
          minute: int.parse(parts[1]),
        );
      }
    } catch (_) {
      // Return current time if parsing fails
    }
    return TimeOfDay.now();
  }

  Widget _subInfo(IconData icon, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(icon, size: 14, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(
          value,
          style: TextStyle(color: Colors.grey[700], fontSize: 12),
        ),
      ],
    );
  }

  Map<String, dynamic> _statusBadge(AttendanceRecord record) {
    String label = 'Present';
    Color background = Colors.green.shade100;
    Color textColor = Colors.green.shade800;

    if (record.lastCheckOut == null && record.firstCheckIn != null) {
      label = 'In Progress';
      background = Colors.blue.shade100;
      textColor = Colors.blue.shade800;
    } else if ((record.missingHours ?? 0) > 0.1) {
      label = 'Late';
      background = Colors.orange.shade100;
      textColor = Colors.orange.shade800;
    } else if ((record.status ?? '') != 'present') {
      label = record.status?.toUpperCase() ?? 'Status';
      background = Colors.grey.shade200;
      textColor = Colors.grey.shade800;
    } else {
      label = 'On Time';
      background = Colors.green.shade100;
      textColor = Colors.green.shade800;
    }

    return <String, dynamic>{
      'label': label,
      'color': background,
      'textColor': textColor,
    };
  }

  String _formatTime(String? value) {
    if (value == null || value.isEmpty) return '--';

    // Try to parse as full datetime string (e.g., "2025-11-17 08:30:00")
    DateTime? dateTime = DateTime.tryParse(value);

    // If parsing fails, try to parse as time-only string (e.g., "08:30")
    if (dateTime == null) {
      final RegExp timePattern = RegExp(r'^(\d{1,2}):(\d{2})$');
      final Match? match = timePattern.firstMatch(value.trim());
      if (match != null) {
        final int hour = int.parse(match.group(1)!);
        final int minute = int.parse(match.group(2)!);
        dateTime = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          hour,
          minute,
        );
      }
    }

    if (dateTime == null) return value;

    return DateFormat('hh:mm a').format(dateTime);
  }

  String _formatDuration(double? hours) {
    if (hours == null) return '--';
    if (hours < 1) {
      final int minutes = (hours * 60).round();
      return '${minutes}m';
    }
    return '${hours.toStringAsFixed(1)}h';
  }

  Future<void> _showDatePicker(
    BuildContext context,
    AttendanceController controller,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: controller.selectedDate.value,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      await controller.refreshForDate(picked);
    }
  }
}

