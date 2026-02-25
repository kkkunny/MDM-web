import 'package:flutter/material.dart';
import 'package:mdm/constants/colors.dart';
import 'package:mdm/constants/styles.dart';
import 'package:mdm/constants/strings.dart';
import 'package:mdm/providers/task_provider.dart';
import 'package:mdm/utils/color_helper.dart';
import 'package:mdm/utils/format_helper.dart';
import 'package:mdm/utils/icon_helper.dart';
import 'package:provider/provider.dart';

class OverviewPanel extends StatelessWidget {
  const OverviewPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: ColorHelper.getSurfaceGradient(isDark: false),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSpeedCard(context),
            const SizedBox(height: 20),
            _buildFilterSection(context),
          ],
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
              LinearProgressIndicator(
                minHeight: AppStyles.progressHeightSmall,
                borderRadius: BorderRadius.circular(8),
                value: stats.totalSize > 0
                    ? stats.totalDownloaded / stats.totalSize
                    : 0.0,
                backgroundColor: AppColors.white.withValues(alpha: 0.2),
                valueColor: AlwaysStoppedAnimation(AppColors.white),
              ),
              const SizedBox(height: 6),
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

  static IconData getFilterIcon(FilterType filter) {
    switch (filter) {
      case FilterType.downloading:
        return Icons.download_rounded;
      case FilterType.completed:
        return Icons.check_circle_rounded;
      case FilterType.paused:
        return Icons.pause_circle_rounded;
      case FilterType.failed:
        return Icons.error_rounded;
    }
  }

  static String getFilterLabel(FilterType filter) {
    switch (filter) {
      case FilterType.downloading:
        return 'Downloading';
      case FilterType.completed:
        return 'Completed';
      case FilterType.paused:
        return 'Paused';
      case FilterType.failed:
        return 'Failed';
    }
  }

  static Color getFilterColor(FilterType filter) {
    switch (filter) {
      case FilterType.downloading:
        return AppColors.info;
      case FilterType.completed:
        return AppColors.success;
      case FilterType.paused:
        return AppColors.warning;
      case FilterType.failed:
        return AppColors.error;
    }
  }

  Widget _buildFilterItem(
    BuildContext context,
    FilterType filter,
    TaskProvider provider,
  ) {
    final isSelected = provider.currentFilter == filter;
    final icon = getFilterIcon(filter);
    final label = getFilterLabel(filter);
    final color = getFilterColor(filter);

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
