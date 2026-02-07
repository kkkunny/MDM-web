import 'package:flutter/material.dart';
import 'package:mdm/constants/colors.dart';
import 'package:mdm/constants/styles.dart';
import 'package:mdm/constants/strings.dart';
import 'package:mdm/providers/task_provider.dart';
import 'package:mdm/providers/theme_provider.dart';
import 'package:mdm/utils/color_helper.dart';
import 'package:mdm/utils/format_helper.dart';
import 'package:mdm/utils/icon_helper.dart';
import 'package:mdm/widgets/common/app_progress_indicator.dart';
import 'package:provider/provider.dart';

class OverviewPanel extends StatelessWidget {
  const OverviewPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Container(
      decoration: BoxDecoration(
        gradient: ColorHelper.getSurfaceGradient(isDark: isDark),
      ),
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppStyles.paddingXLarge),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSpeedCard(context),
                  const SizedBox(height: AppStyles.spacingXLarge),
                  _buildStatsGrid(context),
                  const SizedBox(height: AppStyles.spacingXLarge),
                  _buildStorageCard(context),
                  const SizedBox(height: AppStyles.spacingXLarge),
                  _buildFilterSection(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return Container(
          padding: const EdgeInsets.all(AppStyles.paddingXXLarge),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppStyles.paddingMedium),
                decoration: BoxDecoration(
                  gradient: ColorHelper.getPrimaryGradient(),
                  borderRadius: BorderRadius.circular(
                    AppStyles.borderRadiusLarge,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.4),
                      blurRadius: AppStyles.blurRadiusMedium,
                      offset: const Offset(0, AppStyles.shadowOffsetMedium),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.download_rounded,
                  color: AppColors.white,
                  size: AppStyles.iconSizeXLarge,
                ),
              ),
              const SizedBox(width: AppStyles.spacingLarge),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.download,
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: AppStyles.fontSizeXXLarge,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    AppStrings.manager,
                    style: TextStyle(
                      color: AppColors.white54,
                      fontSize: AppStyles.fontSizeMedium,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              _buildThemeToggle(context, themeProvider),
            ],
          ),
        );
      },
    );
  }

  Widget _buildThemeToggle(BuildContext context, ThemeProvider themeProvider) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => themeProvider.toggleTheme(),
        borderRadius: BorderRadius.circular(AppStyles.borderRadiusMedium),
        child: Container(
          padding: const EdgeInsets.all(AppStyles.paddingMedium),
          decoration: BoxDecoration(
            color: AppColors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppStyles.borderRadiusMedium),
          ),
          child: Icon(
            themeProvider.isDarkMode
                ? Icons.light_mode_rounded
                : Icons.dark_mode_rounded,
            color: AppColors.white,
            size: AppStyles.iconSizeLarge,
          ),
        ),
      ),
    );
  }

  Widget _buildSpeedCard(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, provider, _) {
        final stats = provider.stats;
        return Container(
          padding: const EdgeInsets.all(AppStyles.paddingXLarge),
          decoration: BoxDecoration(
            gradient: ColorHelper.getPrimaryGradient(),
            borderRadius: BorderRadius.circular(AppStyles.borderRadiusXLarge),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.3),
                blurRadius: AppStyles.blurRadiusMedium,
                offset: const Offset(0, AppStyles.shadowOffsetLarge),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    AppStrings.downloadSpeed,
                    style: TextStyle(
                      color: AppColors.white70,
                      fontSize: AppStyles.fontSizeMedium,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: stats.downloading > 0
                                ? AppColors.success
                                : AppColors.white54,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          stats.downloading > 0
                              ? AppStrings.active
                              : AppStrings.idle,
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: AppStyles.fontSizeSmall,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppStyles.spacingLarge),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    FormatHelper.formatSpeed(stats.totalSpeed.toDouble()),
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: AppStyles.fontSizeXXXLarge,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 6, left: 4),
                    child: Text(
                      AppStrings.perSecond,
                      style: TextStyle(
                        color: AppColors.white70,
                        fontSize: AppStyles.fontSizeLarge,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppStyles.spacingLarge),
              _buildSpeedIndicator(stats.totalSpeed.toDouble()),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSpeedIndicator(double speed) {
    final maxSpeed = AppStyles.maxSpeed;
    final progress = (speed / maxSpeed).clamp(0.0, 1.0);

    return AppProgressIndicator(
      value: progress,
      backgroundColor: AppColors.white.withValues(alpha: 0.2),
      valueColor: AppColors.white,
      height: AppStyles.progressHeightSmall,
      showLabel: true,
      label: '${AppStrings.zeroMB} - ${AppStrings.tenMB}',
    );
  }

  Widget _buildStatsGrid(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, provider, _) {
        final stats = provider.stats;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              AppStrings.statistics,
              style: TextStyle(
                color: AppColors.white,
                fontSize: AppStyles.fontSizeLarge,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppStyles.paddingMedium),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    icon: Icons.download_rounded,
                    label: AppStrings.downloading,
                    value: '${stats.downloading}',
                    color: AppColors.info,
                  ),
                ),
                const SizedBox(width: AppStyles.paddingMedium),
                Expanded(
                  child: _buildStatItem(
                    icon: Icons.check_circle_rounded,
                    label: AppStrings.completed,
                    value: '${stats.completed}',
                    color: AppColors.success,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppStyles.paddingMedium),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    icon: Icons.pause_circle_rounded,
                    label: AppStrings.paused,
                    value: '${stats.paused}',
                    color: AppColors.warning,
                  ),
                ),
                const SizedBox(width: AppStyles.paddingMedium),
                Expanded(
                  child: _buildStatItem(
                    icon: Icons.error_rounded,
                    label: AppStrings.failed,
                    value: '${stats.failed}',
                    color: AppColors.error,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppStyles.paddingLarge),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppStyles.borderRadiusLarge),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: AppStyles.iconSizeLarge),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: AppStyles.fontSizeXXLarge,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: AppColors.white60,
              fontSize: AppStyles.fontSizeSmall,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStorageCard(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, provider, _) {
        final stats = provider.stats;
        final progress = stats.totalSize > 0
            ? stats.totalDownloaded / stats.totalSize
            : 0.0;

        return Container(
          padding: const EdgeInsets.all(AppStyles.paddingXLarge),
          decoration: BoxDecoration(
            color: AppColors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(AppStyles.borderRadiusXLarge),
            border: Border.all(color: AppColors.white.withValues(alpha: 0.1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    AppStrings.totalProgress,
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: AppStyles.fontSizeMedium,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '${(progress * 100).toStringAsFixed(1)}%',
                    style: const TextStyle(
                      color: AppColors.info,
                      fontSize: AppStyles.fontSizeMedium,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppStyles.paddingLarge),
              AppProgressIndicator(
                value: progress,
                backgroundColor: AppColors.white.withValues(alpha: 0.1),
                valueColor: AppColors.info,
                height: AppStyles.progressHeightLarge,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    FormatHelper.formatSize(stats.totalDownloaded),
                    style: TextStyle(
                      color: AppColors.white60,
                      fontSize: AppStyles.fontSizeSmall,
                    ),
                  ),
                  Text(
                    FormatHelper.formatSize(stats.totalSize),
                    style: TextStyle(
                      color: AppColors.white60,
                      fontSize: AppStyles.fontSizeSmall,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterSection(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, provider, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              AppStrings.quickFilter,
              style: TextStyle(
                color: AppColors.white,
                fontSize: AppStyles.fontSizeLarge,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppStyles.paddingMedium),
            ...FilterType.values.map(
              (filter) => _buildFilterItem(context, filter, provider),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFilterItem(
    BuildContext context,
    FilterType filter,
    TaskProvider provider,
  ) {
    final isSelected = provider.currentFilter == filter;
    final icon = IconHelper.getFilterIcon(filter);
    final label = IconHelper.getFilterLabel(filter);
    final color = IconHelper.getFilterColor(filter);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppStyles.spacingSmall),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => provider.setFilter(filter),
          borderRadius: BorderRadius.circular(AppStyles.borderRadiusMedium),
          child: AnimatedContainer(
            duration: AppStyles.animationDurationMedium,
            padding: const EdgeInsets.symmetric(
              horizontal: AppStyles.paddingLarge,
              vertical: AppStyles.paddingMedium,
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? color.withValues(alpha: 0.15)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(AppStyles.borderRadiusMedium),
              border: Border.all(
                color: isSelected
                    ? color.withValues(alpha: 0.3)
                    : Colors.transparent,
              ),
            ),
            child: Row(
              children: [
                Icon(icon, color: color, size: AppStyles.iconSizeMedium),
                const SizedBox(width: AppStyles.paddingMedium),
                Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? color : AppColors.white70,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
                const Spacer(),
                if (isSelected)
                  Icon(
                    Icons.chevron_right_rounded,
                    color: color,
                    size: AppStyles.iconSizeMedium,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
