import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_routes.dart';
import '../../../domain/entities/shift.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/shift_controller.dart';

class _CreateShiftDialog extends StatefulWidget {
  final ShiftController controller;

  const _CreateShiftDialog({required this.controller});

  @override
  State<_CreateShiftDialog> createState() => _CreateShiftDialogState();
}

class _CreateShiftDialogState extends State<_CreateShiftDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _startTimeController;
  late final TextEditingController _endTimeController;
  late final TextEditingController _gracePeriodController;
  late final TextEditingController _descriptionController;
  late final GlobalKey<FormState> _formKey;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _startTimeController = TextEditingController();
    _endTimeController = TextEditingController();
    _gracePeriodController = TextEditingController();
    _descriptionController = TextEditingController();
    _formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    _gracePeriodController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState?.validate() != true) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final bool success = await widget.controller.createShift(
        name: _nameController.text.trim(),
        startTime: _startTimeController.text.trim(),
        endTime: _endTimeController.text.trim(),
        gracePeriodMinutes: _gracePeriodController.text.trim().isNotEmpty
            ? int.tryParse(_gracePeriodController.text.trim())
            : null,
        description: _descriptionController.text.trim().isNotEmpty
            ? _descriptionController.text.trim()
            : null,
      );

      if (mounted) {
        Navigator.of(context).pop(success);
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Shift created successfully')),
          );
        }
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create Shift'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Shift Name',
                  hintText: 'e.g., Morning Shift',
                ),
                validator: (String? value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Shift name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _startTimeController,
                decoration: const InputDecoration(
                  labelText: 'Start Time (HH:mm)',
                  hintText: '09:00',
                ),
                validator: (String? value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Start time is required';
                  }
                  if (!RegExp(r'^\d{2}:\d{2}$').hasMatch(value)) {
                    return 'Invalid time format (use HH:mm)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _endTimeController,
                decoration: const InputDecoration(
                  labelText: 'End Time (HH:mm)',
                  hintText: '17:00',
                ),
                validator: (String? value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'End time is required';
                  }
                  if (!RegExp(r'^\d{2}:\d{2}$').hasMatch(value)) {
                    return 'Invalid time format (use HH:mm)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _gracePeriodController,
                decoration: const InputDecoration(
                  labelText: 'Grace Period (minutes, optional)',
                  hintText: '15',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description (optional)',
                ),
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: _isSubmitting
              ? null
              : () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isSubmitting ? null : _handleSubmit,
          child: _isSubmitting
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Create'),
        ),
      ],
    );
  }
}

class ShiftsPage extends StatelessWidget {
  const ShiftsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ShiftController controller = Get.find<ShiftController>();
    final AuthController authController = Get.find<AuthController>();
    final String? userRole = authController.session.value?.user.role;
    final bool isAdmin = userRole == 'admin';
    final bool isManager = userRole == 'manager';
    final bool canAccess = isAdmin || isManager;

    if (!canAccess) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Access denied. Admin/Manager only.')),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: isAdmin
            ? <Widget>[
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => _showCreateShiftDialog(context, controller),
                ),
              ]
            : null,
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.shifts.isEmpty) {
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
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: controller.loadShifts,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (controller.shifts.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Icon(Icons.access_time, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                Text(
                  'No shifts yet',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  isAdmin
                      ? 'Create your first shift to get started'
                      : 'No shifts available',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.loadShifts,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.shifts.length,
            itemBuilder: (BuildContext context, int index) {
              final Shift shift = controller.shifts[index];
              return _buildShiftCard(context, shift, controller, isAdmin);
            },
          ),
        );
      }),
    );
  }

  Widget _buildShiftCard(
    BuildContext context,
    Shift shift,
    ShiftController controller,
    bool isAdmin,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => Get.toNamed(
          AppRoutes.shiftDetail.replaceAll(':id', shift.id.toString()),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          shift.name,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${shift.startTime} - ${shift.endTime}',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                  if (shift.isActive)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green),
                      ),
                      child: const Text(
                        'ACTIVE',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: const Text(
                        'INACTIVE',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  if (isAdmin)
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () =>
                          _confirmDeleteShift(context, shift, controller),
                    ),
                ],
              ),
              if (shift.gracePeriodMinutes != null) ...[
                const SizedBox(height: 8),
                Text(
                  'Grace period: ${shift.gracePeriodMinutes} minutes',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                ),
              ],
              if (shift.users.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  '${shift.users.length} assigned users',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showCreateShiftDialog(
    BuildContext context,
    ShiftController controller,
  ) async {
    await showDialog<bool>(
      context: context,
      builder: (BuildContext context) =>
          _CreateShiftDialog(controller: controller),
    );
  }

  Future<void> _confirmDeleteShift(
    BuildContext context,
    Shift shift,
    ShiftController controller,
  ) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Delete Shift'),
        content: Text('Are you sure you want to delete "${shift.name}"?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final bool success = await controller.deleteShift(shift.id);
      if (context.mounted && success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Shift deleted successfully')),
        );
      }
    }
  }
}
