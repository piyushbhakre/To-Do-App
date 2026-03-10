import 'package:flutter/material.dart';
import 'package:herody_assignment/features/home/task_model.dart';
import 'package:herody_assignment/features/home/viewmodel.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final HomeViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = HomeViewModel()..initialize();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  Future<void> _openAddTaskDialog() async {
    final result = await showDialog<_TaskFormResult>(
      context: context,
      builder: (_) => const _TaskEditorDialog(
        title: 'Add Task',
        primaryActionLabel: 'Add',
      ),
    );

    if (result == null) {
      return;
    }

    await _viewModel.addTask(
      title: result.title,
      description: result.description,
    );
  }

  Future<void> _openEditTaskDialog(TaskModel task) async {
    final result = await showDialog<_TaskFormResult>(
      context: context,
      builder: (_) => _TaskEditorDialog(
        title: 'Edit Task',
        initialTitle: task.title,
        initialDescription: task.description,
        primaryActionLabel: 'Save',
      ),
    );

    if (result == null) {
      return;
    }

    await _viewModel.editTask(
      taskId: task.id,
      title: result.title,
      description: result.description,
    );
  }

  Future<void> _confirmDeleteTask(String taskId) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete task'),
        content: const Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      await _viewModel.deleteTask(taskId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _viewModel,
      builder: (context, _) {
        final colorScheme = Theme.of(context).colorScheme;
        final tasks = _viewModel.tasks;
        final completedCount = tasks.where((task) => task.isCompleted).length;
        final pendingCount = tasks.length - completedCount;
        final username = _viewModel.user?.username.trim();
        final appBarUsername =
            username == null || username.isEmpty ? 'User' : username;

        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leadingWidth: 90,
            leading: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Home',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
            ),
            centerTitle: true,
            title: Text(
              appBarUsername,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            actions: [
              IconButton(
                onPressed: _viewModel.isTaskLoading ? null : _viewModel.fetchTasks,
                icon: const Icon(Icons.refresh),
                tooltip: 'Refresh tasks',
              ),
              IconButton(
                onPressed: () async {
                  await _viewModel.logout();
                },
                icon: const Icon(Icons.logout),
                tooltip: 'Logout',
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: _viewModel.isActionInProgress ? null : _openAddTaskDialog,
            icon: const Icon(Icons.add),
            label: const Text('Add Task'),
          ),
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colorScheme.surface,
                  colorScheme.surfaceContainerHighest.withValues(alpha: 0.28),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  if (_viewModel.isActionInProgress)
                    const LinearProgressIndicator(minHeight: 2),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: _viewModel.fetchTasks,
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(16),
                        children: [
                          Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 900),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  _SummaryCard(
                                    username: appBarUsername,
                                    pendingCount: pendingCount,
                                    completedCount: completedCount,
                                  ),
                                  if (_viewModel.profileErrorMessage != null ||
                                      _viewModel.taskErrorMessage != null) ...[
                                    const SizedBox(height: 12),
                                    _ErrorBanner(
                                      message:
                                          '${_viewModel.profileErrorMessage ?? ''} ${_viewModel.taskErrorMessage ?? ''}'
                                              .trim(),
                                    ),
                                  ],
                                  const SizedBox(height: 12),
                                  _TaskSection(
                                    tasks: tasks,
                                    isLoading: _viewModel.isTaskLoading,
                                    onToggle: _viewModel.toggleTask,
                                    onEdit: _openEditTaskDialog,
                                    onDelete: _confirmDeleteTask,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.username,
    required this.pendingCount,
    required this.completedCount,
  });

  final String username;
  final int pendingCount;
  final int completedCount;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            colorScheme.primaryContainer,
            colorScheme.secondaryContainer,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome, $username',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            'Manage your day with clear priorities.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _StatChip(
                label: 'Pending',
                count: pendingCount,
                backgroundColor: colorScheme.tertiaryContainer,
              ),
              _StatChip(
                label: 'Completed',
                count: completedCount,
                backgroundColor: colorScheme.primary.withValues(alpha: 0.15),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.label,
    required this.count,
    required this.backgroundColor,
  });

  final String label;
  final int count;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$count',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
      ),
      padding: const EdgeInsets.all(12),
      child: Text(
        message,
        style: const TextStyle(color: Colors.red),
      ),
    );
  }
}

class _TaskSection extends StatelessWidget {
  const _TaskSection({
    required this.tasks,
    required this.isLoading,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  final List<TaskModel> tasks;
  final bool isLoading;
  final Future<void> Function(TaskModel task) onToggle;
  final Future<void> Function(TaskModel task) onEdit;
  final Future<void> Function(String taskId) onDelete;

  @override
  Widget build(BuildContext context) {
    if (isLoading && tasks.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 36),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (tasks.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
          child: Column(
            children: [
              Icon(
                Icons.task_alt_rounded,
                size: 36,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 10),
              const Text(
                'No tasks yet.\nTap "Add Task" to create one.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: tasks.length,
      separatorBuilder: (_, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final task = tasks[index];
        final textStyle = task.isCompleted
            ? const TextStyle(decoration: TextDecoration.lineThrough)
            : null;

        return Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 4,
            ),
            leading: Checkbox(
              value: task.isCompleted,
              onChanged: (_) => onToggle(task),
            ),
            title: Text(task.title, style: textStyle),
            subtitle: task.description.trim().isEmpty
                ? null
                : Text(task.description, style: textStyle),
            trailing: Wrap(
              spacing: 2,
              children: [
                IconButton(
                  onPressed: () => onEdit(task),
                  icon: const Icon(Icons.edit_outlined),
                  tooltip: 'Edit',
                ),
                IconButton(
                  onPressed: () => onDelete(task.id),
                  icon: const Icon(Icons.delete_outline),
                  tooltip: 'Delete',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _TaskEditorDialog extends StatefulWidget {
  const _TaskEditorDialog({
    required this.title,
    required this.primaryActionLabel,
    this.initialTitle = '',
    this.initialDescription = '',
  });

  final String title;
  final String primaryActionLabel;
  final String initialTitle;
  final String initialDescription;

  @override
  State<_TaskEditorDialog> createState() => _TaskEditorDialogState();
}

class _TaskEditorDialogState extends State<_TaskEditorDialog> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle);
    _descriptionController =
        TextEditingController(text: widget.initialDescription);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit() {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      setState(() {
        _errorMessage = 'Task title is required.';
      });
      return;
    }

    Navigator.of(context).pop(
      _TaskFormResult(
        title: title,
        description: _descriptionController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: 10),
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _submit,
          child: Text(widget.primaryActionLabel),
        ),
      ],
    );
  }
}

class _TaskFormResult {
  const _TaskFormResult({
    required this.title,
    required this.description,
  });

  final String title;
  final String description;
}
