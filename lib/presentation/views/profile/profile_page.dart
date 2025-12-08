import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../controllers/profile_controller.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.find<ProfileController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('My Profile')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final user = controller.profile.value;
        if (user == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Icon(Symbols.person, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                Text(
                  'Profile not found',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: controller.loadProfile,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (controller.errorMessage.value != null &&
            controller.errorMessage.value!.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  controller.errorMessage.value ?? 'Unknown error',
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: controller.loadProfile,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 20),
              // Avatar
              CircleAvatar(
                radius: 45,
                backgroundColor: Colors.grey.shade200,
                child: Icon(
                  Symbols.account_circle,
                  size: 70,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 16),
              // Name
              Text(
                user.name,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              // Email
              Text(
                user.email,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
              ),
              const SizedBox(height: 8),
              // Role Badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: user.isAdmin
                      ? Colors.red.shade50
                      : user.isManager
                      ? Colors.blue.shade50
                      : Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: user.isAdmin
                        ? Colors.red.shade200
                        : user.isManager
                        ? Colors.blue.shade200
                        : Colors.green.shade200,
                    width: 1,
                  ),
                ),
                child: Text(
                  user.role.toUpperCase(),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: user.isAdmin
                        ? Colors.red.shade700
                        : user.isManager
                        ? Colors.blue.shade700
                        : Colors.green.shade700,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // Information Card
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: Colors.grey.shade200, width: 1),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: <Widget>[
                      _buildInfoRow(
                        context,
                        icon: Symbols.badge,
                        label: 'Employee Number',
                        value: user.employeeNumber?.toString() ?? 'N/A',
                      ),
                      const Divider(height: 32),
                      _buildInfoRow(
                        context,
                        icon: Symbols.email,
                        label: 'Email',
                        value: user.email,
                      ),
                      const Divider(height: 32),
                      _buildInfoRow(
                        context,
                        icon: Symbols.work,
                        label: 'Role',
                        value: user.role.toUpperCase(),
                      ),
                      const Divider(height: 32),
                      _buildInfoRow(
                        context,
                        icon: Symbols.check_circle,
                        label: 'Status',
                        value: user.isActive ? 'Active' : 'Inactive',
                        valueColor: user.isActive ? Colors.green : Colors.grey,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Edit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () =>
                      _showUpdateProfileDialog(context, controller, user),
                  icon: const Icon(Symbols.edit, size: 18),
                  label: const Text('Edit Profile'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 18, color: Colors.grey.shade700),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: valueColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _showUpdateProfileDialog(
    BuildContext context,
    ProfileController controller,
    user,
  ) async {
    final TextEditingController nameController = TextEditingController(
      text: user.name,
    );
    final TextEditingController emailController = TextEditingController(
      text: user.email,
    );
    final TextEditingController passwordController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Update Profile'),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name *',
                    prefixIcon: Icon(Symbols.person),
                  ),
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Name is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email *',
                    prefixIcon: Icon(Symbols.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Email is required';
                    }
                    if (!GetUtils.isEmail(value)) {
                      return 'Invalid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    labelText: 'New Password (optional)',
                    prefixIcon: Icon(Symbols.lock),
                    helperText: 'Leave empty to keep current password',
                  ),
                  obscureText: true,
                ),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          Obx(
            () => FilledButton(
              onPressed: controller.isUpdating.value
                  ? null
                  : () async {
                      if (formKey.currentState?.validate() == true) {
                        final bool success = await controller.updateProfile(
                          name: nameController.text,
                          email: emailController.text,
                          password: passwordController.text.isNotEmpty
                              ? passwordController.text
                              : null,
                        );
                        if (context.mounted) {
                          Navigator.of(context).pop();
                          if (success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Profile updated successfully'),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  controller.errorMessage.value != null
                                      ? controller.errorMessage.value!
                                      : 'Failed to update profile',
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      }
                    },
              child: controller.isUpdating.value
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
    );

    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
  }
}
