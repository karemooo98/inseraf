import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controllers/attendance_controller.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  late final AttendanceController controller;
  final DateFormat _dateFormat = DateFormat('EEEE, MMM d, yyyy');

  @override
  void initState() {
    super.initState();
    controller = Get.find<AttendanceController>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.refreshForDate(controller.selectedDate.value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance'),
      ),
      body: Obx(
        () => Column(
          children: <Widget>[
            _buildDatePicker(context),
            Expanded(
              child: controller.isAttendanceLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : controller.attendanceByDate.isEmpty
                      ? const Center(child: Text('No records for this date'))
                      : ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemCount: controller.attendanceByDate.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemBuilder: (BuildContext context, int index) {
                            final record = controller.attendanceByDate[index];
                            return Card(
                              child: ListTile(
                                leading: CircleAvatar(
                                  child: Text(record.userName.substring(0, 1).toUpperCase()),
                                ),
                                title: Text(record.userName),
                                subtitle: Text(
                                  'In: ${record.firstCheckIn ?? '--'}  Out: ${record.lastCheckOut ?? '--'}',
                                ),
                                trailing: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text('${record.workedHours ?? 0} h'),
                                    const SizedBox(height: 4),
                                    Text(
                                      record.status ?? 'unknown',
                                      style: TextStyle(
                                        color: record.status == 'present'
                                            ? Colors.green
                                            : Colors.orange,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text('Selected date', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(_dateFormat.format(controller.selectedDate.value)),
            ],
          ),
          FilledButton.icon(
            onPressed: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: controller.selectedDate.value,
                firstDate: DateTime.now().subtract(const Duration(days: 365)),
                lastDate: DateTime.now().add(const Duration(days: 30)),
              );
              if (picked != null) {
                controller.refreshForDate(picked);
              }
            },
            icon: const Icon(Icons.calendar_today),
            label: const Text('Change'),
          ),
        ],
      ),
    );
  }
}




