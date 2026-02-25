import 'package:flutter/material.dart';
import 'package:mdm/constants/colors.dart';
import 'package:mdm/constants/styles.dart';
import 'package:mdm/constants/strings.dart';
import 'package:mdm/icons/iconfont.dart';
import 'package:mdm/providers/task_provider.dart';
import 'package:mdm/utils/color_helper.dart';
import 'package:mdm/utils/format_helper.dart';
import 'package:provider/provider.dart';

class OverviewPanel extends StatelessWidget {
  const OverviewPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSpeedCard(context),
          const SizedBox(height: 20),
          _buildFilterSection(context),
        ],
      ),
    );
  }

  Widget _buildSpeedCard(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, provider, _) {
        final stats = provider.stats;
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: ColorHelper.getPrimaryGradient(),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
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
                    '下载速度',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
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
                              ? '已连接'
                              : '已断联',
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 12,
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
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 6, left: 4),
                    child: Text(
                      AppStrings.perSecond,
                      style: TextStyle(
                        color: AppColors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppStyles.spacingLarge),
              LinearProgressIndicator(
                minHeight: 6,
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
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    FormatHelper.formatSize(stats.totalSize),
                    style: TextStyle(
                      color: AppColors.white60,
                      fontSize: 12,
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
            ExpansionTile(
              initiallyExpanded: true,
              leading: Icon(Icons.download_rounded),
              title: Text('下载任务'),
              children: FilterType.values.getRange(0, 4).map(
                    (filter) => _buildFilterItem(context, filter, provider),
              ).toList(),
            ),
            const SizedBox(height: 12),
            ExpansionTile(
              initiallyExpanded: true,
              leading: Icon(Icons.upload_rounded),
              title: Text('上传任务'),
              children: FilterType.values.skip(4).map(
                    (filter) => _buildFilterItem(context, filter, provider),
              ).toList(),
            ),
          ],
        );
      },
    );
  }

  static Icon getFilterIcon(FilterType filter) {
    switch (filter) {
      case FilterType.DL_running:
        return const Icon(Icons.download_for_offline_rounded, color: AppColors.info, size: 20);
      case FilterType.DL_completed:
        return const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 20);
      case FilterType.DL_paused:
        return const Icon(Icons.pause_circle_rounded, color: AppColors.warning, size: 20);
      case FilterType.DL_failed:
        return const Icon(Icons.pause_circle_rounded, color: AppColors.error, size: 20);
      case FilterType.UL_running:
        return const Icon(IconFont.upload, color: AppColors.info, size: 18);
      case FilterType.UL_completed:
        return const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 20);
      case FilterType.UL_paused:
        return const Icon(Icons.pause_circle_rounded, color: AppColors.warning, size: 20);
      case FilterType.UL_failed:
        return const Icon(Icons.pause_circle_rounded, color: AppColors.error, size: 20);
    }
  }

  static String getFilterLabel(FilterType filter) {
    switch (filter) {
      case FilterType.DL_running:
        return '下载中';
      case FilterType.DL_completed:
        return '已完成';
      case FilterType.DL_paused:
        return '暂停中';
      case FilterType.DL_failed:
        return '已失败';
      case FilterType.UL_running:
        return '上传中';
      case FilterType.UL_completed:
        return '已完成';
      case FilterType.UL_paused:
        return '暂停中';
      case FilterType.UL_failed:
        return '已失败';
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

    return Padding(
      padding: const EdgeInsets.only(bottom: AppStyles.spacingSmall),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => provider.setFilter(filter),
          borderRadius: BorderRadius.circular(12),
          child: AnimatedContainer(
            duration: AppStyles.animationDurationMedium,
            padding: const EdgeInsets.symmetric(
              horizontal: AppStyles.paddingLarge,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? icon.color!.withValues(alpha: 0.15)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? icon.color!.withValues(alpha: 0.3)
                    : Colors.transparent,
              ),
            ),
            child: Row(
              children: [
                icon,
                const SizedBox(width: 12),
                Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? icon.color! : Colors.black54,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
                const Spacer(),
                if (isSelected)
                  Icon(
                    Icons.chevron_right_rounded,
                    color: icon.color!,
                    size: 20,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
