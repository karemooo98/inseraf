import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../domain/entities/shift.dart';
import '../../../domain/entities/shift_user.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/shift_controller.dart';

class ShiftDetailPage extends StatelessWidget {
  const ShiftDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final int shiftId = int.parse(Get.parameters['id']!);
    final ShiftController controller = Get.find<ShiftController>();
    final AuthController authController = Get.find<AuthController>();
    final bool isAdmin = authController.session.value?.user?.role == 'admin';

    // Load shift details on first build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadShiftById(shiftId);
    });

    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(controller.selectedShift.value?.name ?? 'Shift Details')),
        actions: isAdmin
            ? <Widget>[
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _showEditShiftDialog(context, controller),
                ),
              ]
            : null,
      ),
      body: Obx(
        () {
          if (controller.isLoading.value && controller.selectedShift.value == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final Shift? shift = controller.selectedShift.value;
          if (shift == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Icon(Icons.error_outline, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    controller.errorMessage.value.isEmpty
                        ? 'Shift not found'
                        : controller.errorMessage.value,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => controller.loadShiftById(shiftId),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => controller.loadShiftById(shiftId),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: <Widget>[
                _buildShiftInfoCard(context, shift),
                const SizedBox(height: 16),
                _buildUsersSection(context, shift, controller, isAdmin),
              ],
            ),
          );
        },
      ),
      floatingActionButton: Obx(() {
        final Shift? shift = controller.selectedShift.value;
        if (shift == null || !isAdmin) return const SizedBox.shrink();

        return FloatingActionButton.extended(
          onPressed: () => _showAssignUsersDialog(context, shift, controller),
          icon: const Icon(Icons.person_add),
          label: const Text('Assign Users'),
        );
      }),
    );
  }

  Widget _buildShiftInfoCard(BuildContext context, Shift shift) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Shift Information',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            _buildInfoRow(context, 'Name', shift.name),
            _buildInfoRow(context, 'Time', '${shift.startTime} - ${shift.endTime}'),
            if (shift.gracePeriodMinutes != null)
              _buildInfoRow(context, 'Grace Period', '${shift.gracePeriodMinutes} minutes'),
            _buildInfoRow(
              context,
              'Status',
              shift.isActive ? 'Active' : 'Inactive',
              valueColor: shift.isActive ? Colors.green : Colors.grey,
            ),
            if (shift.description != null && shift.description!.isNotEmpty)
              _buildInfoRow(context, 'Description', shift.description!),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    String label,
    String value, {
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: valueColor,
                    fontWeight: valueColor != null ? FontWeight.bold : null,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUsersSection(
    BuildContext context,
    Shift shift,
    ShiftController controller,
    bool isAdmin,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Assigned Users (${shift.users.length})',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            if (shift.users.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('No users assigned to this shift'),
              )
            else
              ...shift.users.map(
                (ShiftUser user) => ListTile(
                  leading: CircleAvatar(
                    child: Text(user.name[0].toUpperCase()),
                  ),
                  title: Text(user.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(user.email),
                      if (user.effectiveFrom != null || user.effectiveTo != null)
                        Text(
                          '${user.effectiveFrom ?? 'N/A'} - ${user.effectiveTo ?? 'Ongoing'}',
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                    ],
                  ),
                  trailing: isAdmin
                      ? IconButton(
                          icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                          onPressed: () => _confirmRemoveUser(
                            context,
                            shift,
                            user.id,
                            controller,
                          ),
                        )
                      : null,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _showEditShiftDialog(
    BuildContext context,
    ShiftController controller,
  ) async {
    final Shift? shift = controller.selectedShift.value;
    if (shift == null) return;

    final TextEditingController nameController = TextEditingController(text: shift.name);
    final TextEditingController startTimeController = TextEditingController(text: shift.startTime);
    final TextEditingController endTimeController = TextEditingController(text: shift.endTime);
    final TextEditingController gracePeriodController = TextEditingController(
      text: shift.gracePeriodMinutes?.toString() ?? '',
    );
    final TextEditingController descriptionController = TextEditingController(
      text: shift.description ?? '',
    );
    bool isActive = shift.isActive;
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    final bool? result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) => AlertDialog(
          title: const Text('Edit Shift'),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Shift Name'),
                    validator: (String? value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Shift name is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: startTimeController,
                    decoration: const InputDecoration(labelText: 'Start Time (HH:mm)'),
                    validator: (String? value) {
                      if (value != null && value.isNotEmpty && !RegExp(r'^\d{2}:\d{2}$').hasMatch(value)) {
                        return 'Invalid time format';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: endTimeController,
                    decoration: const InputDecoration(labelText: 'End Time (HH:mm)'),
                    validator: (String? value) {
                      if (value != null && value.isNotEmpty && !RegExp(r'^\d{2}:\d{2}$').hasMatch(value)) {
                        return 'Invalid time format';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: gracePeriodController,
                    decoration: const InputDecoration(labelText: 'Grace Period (minutes)'),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: descriptionController,
                    decoration: const InputDecoration(labelText: 'Description'),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 12),
                  CheckboxListTile(
                    title: const Text('Active'),
                    value: isActive,
                    onChanged: (bool? value) => setState(() => isActive = value ?? false),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            Obx(
              () => ElevatedButton(
                onPressed: controller.isUpdatingShift.value
                    ? null
                    : () async {
                        if (formKey.currentState?.validate() == true) {
                          final bool success = await controller.updateShift(
                            shiftId: shift.id,
                            name: nameController.text.trim(),
                            startTime: startTimeController.text.trim(),
                            endTime: endTimeController.text.trim(),
                            gracePeriodMinutes: gracePeriodController.text.trim().isNotEmpty
                                ? int.tryParse(gracePeriodController.text.trim())
                                : null,
                            description: descriptionController.text.trim().isNotEmpty
                                ? descriptionController.text.trim()
                                : null,
                            isActive: isActive,
                          );
                          if (context.mounted) {
                            Navigator.of(context).pop(success);
                            if (success) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Shift updated successfully')),
                              );
                            }
                          }
                        }
                      },
                child: controller.isUpdatingShift.value
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Update'),
              ),
            ),
          ],
        ),
      ),
    );

    if (result == true) {
      nameController.dispose();
      startTimeController.dispose();
      endTimeController.dispose();
      gracePeriodController.dispose();
      descriptionController.dispose();
    }
  }

  Future<void> _showAssignUsersDialog(
    BuildContext context,
    Shift shift,
    ShiftController controller,
  ) async {
    final TextEditingController userIdsController = TextEditingController();
    DateTime? effectiveFrom;
    DateTime? effectiveTo;
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    final bool? result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) => AlertDialog(
          title: const Text('Assign Users'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  controller: userIdsController,
                  decoration: const InputDecoration(
                    labelText: 'User IDs (comma-separated)',
                    hintText: '1, 2, 3',
                  ),
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'User IDs are required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    effectiveFrom == null
                        ? 'Effective From (optional)'
                        : DateFormat('MMM d, yyyy').format(effectiveFrom!),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now().subtract(const Duration(days: 365)),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (picked != null) {
                        setState(() => effectiveFrom = picked);
                      }
                    },
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    effectiveTo == null
                        ? 'Effective To (optional)'
                        : DateFormat('MMM d, yyyy').format(effectiveTo!),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now().subtract(const Duration(days: 365)),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (picked != null) {
                        setState(() => effectiveTo = picked);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            Obx(
              () => ElevatedButton(
                onPressed: controller.isLoading.value
                    ? null
                    : () async {
                        if (formKey.currentState?.validate() == true) {
                          final List<int> userIds = userIdsController.text
                              .split(',')
                              .map((String id) => int.tryParse(id.trim()))
                              .whereType<int>()
                              .toList();
                          if (userIds.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Invalid user IDs')),
                            );
                            return;
                          }
                          final bool success = await controller.assignUsers(
                            shiftId: shift.id,
                            userIds: userIds,
                            effectiveFrom: effectiveFrom != null
                                ? DateFormat('yyyy-MM-dd').format(effectiveFrom!)
                                : null,
                            effectiveTo: effectiveTo != null
                                ? DateFormat('yyyy-MM-dd').format(effectiveTo!)
                                : null,
                          );
                          if (context.mounted) {
                            Navigator.of(context).pop(success);
                            if (success) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Users assigned successfully')),
                              );
                            }
                          }
                        }
                      },
                child: controller.isLoading.value
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Assign'),
              ),
            ),
          ],
        ),
      ),
    );

    if (result == true) {
      userIdsController.dispose();
    }
  }

  Future<void> _confirmRemoveUser(
    BuildContext context,
    Shift shift,
    int userId,
    ShiftController controller,
  ) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Remove User'),
        content: const Text('Are you sure you want to remove this user from the shift?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Remove'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final bool success = await controller.removeUser(
        shiftId: shift.id,
        userId: userId,
      );
      if (context.mounted && success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User removed successfully')),
        );
      }
    }
  }
}

