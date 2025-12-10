import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_routes.dart';
import '../../../domain/entities/team.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/team_controller.dart';

class TeamsPage extends StatelessWidget {
  const TeamsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TeamController controller = Get.find<TeamController>();
    final AuthController authController = Get.find<AuthController>();
    final String? userRole = authController.session.value?.user?.role;
    final bool isAdmin = userRole == 'admin';
    final bool isManager = userRole == 'manager';
    final bool canAccess = isAdmin || isManager;

    if (!canAccess) {
      return Scaffold(
        appBar: AppBar(title: const Text('Teams')),
        body: const Center(
          child: Text('Access denied. Admin/Manager only.'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: isAdmin
            ? <Widget>[
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => _showCreateTeamDialog(context, controller),
                ),
              ]
            : null,
      ),
      body: Obx(
        () {
          if (controller.isLoading.value && controller.teams.isEmpty) {
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
                    onPressed: controller.loadTeams,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (controller.teams.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Icon(Icons.groups, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    'No teams yet',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isAdmin
                        ? 'Create your first team to get started'
                        : 'You are not assigned to any teams',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: controller.loadTeams,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: controller.teams.length,
              itemBuilder: (BuildContext context, int index) {
                final Team team = controller.teams[index];
                return _buildTeamCard(context, team, controller, isAdmin);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildTeamCard(
    BuildContext context,
    Team team,
    TeamController controller,
    bool isAdmin,
  ) {
    return Card(
        color: Colors.grey.shade100,
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => Get.toNamed(
          AppRoutes.teamDetail.replaceAll(':id', team.id.toString()),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      team.name,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  if (isAdmin)
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () => _confirmDeleteTeam(context, team, controller),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: <Widget>[
                  Icon(Icons.people, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    '${team.members.length} members',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                  const SizedBox(width: 16),
                  Icon(Icons.task, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    '${team.tasks.length} tasks',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showCreateTeamDialog(
    BuildContext context,
    TeamController controller,
  ) async {
    final TextEditingController nameController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    final bool? result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Create Team'),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Team Name',
              hintText: 'Enter team name',
            ),
            validator: (String? value) {
              if (value == null || value.trim().isEmpty) {
                return 'Team name is required';
              }
              return null;
            },
            autofocus: true,
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          Obx(
            () => ElevatedButton(
              onPressed: controller.isCreatingTeam.value
                  ? null
                  : () async {
                      if (formKey.currentState?.validate() == true) {
                        final bool success = await controller.createTeam(
                          nameController.text.trim(),
                        );
                        if (context.mounted) {
                          Navigator.of(context).pop(success);
                          if (success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Team created successfully')),
                            );
                          }
                        }
                      }
                    },
              child: controller.isCreatingTeam.value
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Create'),
            ),
          ),
        ],
      ),
    );

    if (result == true) {
      nameController.dispose();
    }
  }

  Future<void> _confirmDeleteTeam(
    BuildContext context,
    Team team,
    TeamController controller,
  ) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Delete Team'),
        content: Text('Are you sure you want to delete "${team.name}"?'),
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
      final bool success = await controller.deleteTeam(team.id);
      if (context.mounted && success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Team deleted successfully')),
        );
      }
    }
  }
}

