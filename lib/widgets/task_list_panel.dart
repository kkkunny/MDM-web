import 'package:flutter/material.dart';
import 'package:mdm/constants/colors.dart';
import 'package:mdm/constants/styles.dart';
import 'package:mdm/constants/strings.dart';
import 'package:mdm/providers/task_provider.dart';
import 'package:mdm/providers/theme_provider.dart';
import 'package:mdm/widgets/common/app_button.dart';
import 'package:mdm/widgets/common/app_dialog.dart';
import 'package:mdm/widgets/task_card.dart';
import 'package:provider/provider.dart';

class TaskListPanel extends StatelessWidget {
  const TaskListPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Container(
      color: isDark ? AppColors.background : AppColors.lightBackground,
      child: Column(
        children: [
          _buildToolbar(context),
          Expanded(child: _buildTaskList(context)),
        ],
      ),
    );
  }

  Widget _buildToolbar(BuildContext context) {
    return Consumer2<TaskProvider, ThemeProvider>(
      builder: (context, provider, themeProvider, _) {
        final isDark = themeProvider.isDarkMode;
        return Container(
          padding: const EdgeInsets.all(AppStyles.paddingXLarge),
          decoration: BoxDecoration(
            color: isDark ? AppColors.surface : AppColors.lightSurface,
            border: Border(
              bottom: BorderSide(
                color: isDark
                    ? AppColors.white.withValues(alpha: 0.1)
                    : AppColors.lightDivider,
              ),
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(child: _buildSearchBar(context, provider, isDark)),
                  const SizedBox(width: AppStyles.paddingLarge),
                  _buildAddButton(context),
                ],
              ),
              if (provider.hasSelection) ...[
                const SizedBox(height: AppStyles.paddingLarge),
                _buildSelectionToolbar(context, provider, isDark),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildSearchBar(
    BuildContext context,
    TaskProvider provider,
    bool isDark,
  ) {
    return Container(
      height: AppStyles.inputHeight,
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.white.withValues(alpha: 0.05)
            : AppColors.lightSurfaceLight,
        borderRadius: BorderRadius.circular(AppStyles.borderRadiusMedium),
        border: Border.all(
          color: isDark
              ? AppColors.white.withValues(alpha: 0.1)
              : AppColors.lightDivider,
        ),
      ),
      child: TextField(
        onChanged: provider.setSearchQuery,
        style: TextStyle(color: isDark ? AppColors.white : AppColors.lightText),
        decoration: InputDecoration(
          hintText: AppStrings.searchDownloads,
          hintStyle: TextStyle(
            color: isDark ? AppColors.white40 : AppColors.lightTextSecondary,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: isDark ? AppColors.white40 : AppColors.lightTextSecondary,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppStyles.paddingLarge,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return AppButton.primary(
      text: AppStrings.addTask,
      icon: Icons.add_rounded,
      onPressed: () => _showAddTaskDialog(context),
    );
  }

  Widget _buildSelectionToolbar(
    BuildContext context,
    TaskProvider provider,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppStyles.paddingLarge,
        vertical: AppStyles.paddingMedium,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppStyles.borderRadiusMedium),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Text(
            '${provider.selectedTaskIds.length} ${AppStrings.selected}',
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          _buildToolbarButton(
            icon: Icons.pause_rounded,
            label: AppStrings.pauseAll,
            onTap: () => provider.pauseSelected(),
            isDark: isDark,
          ),
          const SizedBox(width: AppStyles.paddingMedium),
          _buildToolbarButton(
            icon: Icons.delete_rounded,
            label: AppStrings.delete,
            color: AppColors.error,
            onTap: () => _showDeleteConfirmDialog(context, provider),
            isDark: isDark,
          ),
          const SizedBox(width: AppStyles.paddingMedium),
          _buildToolbarButton(
            icon: Icons.close_rounded,
            label: AppStrings.cancel,
            onTap: () => provider.clearSelection(),
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildToolbarButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color color = AppColors.white70,
    bool isDark = true,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppStyles.paddingMedium,
            vertical: AppStyles.paddingSmall,
          ),
          child: Row(
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 6),
              Text(label, style: TextStyle(color: color, fontSize: 13)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTaskList(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        if (provider.error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  size: 64,
                  color: AppColors.white30,
                ),
                const SizedBox(height: AppStyles.paddingLarge),
                Text(
                  AppStrings.failedToLoadTasks,
                  style: TextStyle(
                    color: AppColors.white50,
                    fontSize: AppStyles.fontSizeLarge,
                  ),
                ),
                const SizedBox(height: AppStyles.spacingSmall),
                TextButton(
                  onPressed: () => provider.fetchTasks(),
                  child: const Text(AppStrings.retry),
                ),
              ],
            ),
          );
        }

        if (provider.tasks.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.download_done_rounded,
                  size: 80,
                  color: AppColors.white30,
                ),
                const SizedBox(height: AppStyles.paddingXLarge),
                Text(
                  AppStrings.noDownloadsYet,
                  style: TextStyle(
                    color: AppColors.white50,
                    fontSize: AppStyles.fontSizeXLarge,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: AppStyles.spacingSmall),
                Text(
                  AppStrings.clickAddTask,
                  style: TextStyle(
                    color: AppColors.white30,
                    fontSize: AppStyles.fontSizeMedium,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(AppStyles.paddingXLarge),
          itemCount: provider.tasks.length,
          itemBuilder: (context, index) {
            final task = provider.tasks[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: AppStyles.paddingMedium),
              child: TaskCard(
                task: task,
                isSelected: provider.selectedTaskIds.contains(task.id),
                onTap: () => provider.toggleSelection(task.id),
                onPause: () => provider.pauseTask(task.id),
                onResume: () => provider.resumeTask(task.id),
                onDelete: () =>
                    _showDeleteSingleConfirmDialog(context, provider, task.id),
                onRetry: () => provider.retryTask(task.id),
              ),
            );
          },
        );
      },
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    final urlController = TextEditingController();
    final fileNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppStyles.borderRadiusXLarge),
        ),
        title: const Text(
          AppStrings.addNewDownload,
          style: TextStyle(color: AppColors.white),
        ),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: urlController,
                style: const TextStyle(color: AppColors.white),
                decoration: InputDecoration(
                  labelText: AppStrings.downloadUrl,
                  labelStyle: TextStyle(color: AppColors.white60),
                  hintText: 'https://example.com/file.zip',
                  hintStyle: TextStyle(color: AppColors.white30),
                  filled: true,
                  fillColor: AppColors.white.withValues(alpha: 0.05),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      AppStyles.borderRadiusMedium,
                    ),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: Icon(
                    Icons.link_rounded,
                    color: AppColors.white50,
                  ),
                ),
              ),
              const SizedBox(height: AppStyles.paddingLarge),
              TextField(
                controller: fileNameController,
                style: const TextStyle(color: AppColors.white),
                decoration: InputDecoration(
                  labelText: AppStrings.fileName,
                  labelStyle: TextStyle(color: AppColors.white60),
                  filled: true,
                  fillColor: AppColors.white.withValues(alpha: 0.05),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      AppStyles.borderRadiusMedium,
                    ),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: Icon(
                    Icons.edit_rounded,
                    color: AppColors.white50,
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              AppStrings.cancel,
              style: TextStyle(color: AppColors.white60),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (urlController.text.isNotEmpty) {
                context.read<TaskProvider>().addTask(
                  urlController.text,
                  fileName: fileNameController.text.isNotEmpty
                      ? fileNameController.text
                      : null,
                );
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  AppStyles.borderRadiusMedium,
                ),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: AppStyles.paddingLarge,
                vertical: AppStyles.paddingMedium,
              ),
            ),
            child: const Text(AppStrings.download),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmDialog(BuildContext context, TaskProvider provider) {
    AppDialog.showConfirmDialog(
      context,
      title: AppStrings.deleteDownloads,
      content: AppStrings.deleteConfirm.replaceAll(
        '{}',
        provider.selectedTaskIds.length.toString(),
      ),
      confirmText: AppStrings.delete,
      cancelText: AppStrings.cancel,
      confirmColor: AppColors.error,
    ).then((confirmed) {
      if (confirmed == true) {
        provider.deleteSelected();
      }
    });
  }

  void _showDeleteSingleConfirmDialog(
    BuildContext context,
    TaskProvider provider,
    String taskId,
  ) {
    AppDialog.showConfirmDialog(
      context,
      title: AppStrings.deleteDownload,
      content: AppStrings.deleteSingleConfirm,
      confirmText: AppStrings.delete,
      cancelText: AppStrings.cancel,
      confirmColor: AppColors.error,
    ).then((confirmed) {
      if (confirmed == true) {
        provider.deleteTask(taskId);
      }
    });
  }
}
