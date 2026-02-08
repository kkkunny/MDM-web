import 'package:flutter/material.dart';
import 'package:mdm/constants/colors.dart';
import 'package:mdm/constants/styles.dart';
import 'package:mdm/models/task.dart';
import 'package:mdm/models/vo/task.pb.dart';
import 'package:mdm/providers/theme_provider.dart';
import 'package:mdm/utils/color_helper.dart';
import 'package:mdm/utils/format_helper.dart';
import 'package:mdm/utils/icon_helper.dart';
import 'package:provider/provider.dart';

class TaskCard extends StatefulWidget {
  final Task task;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onPause;
  final VoidCallback onResume;
  final VoidCallback onDelete;
  final VoidCallback onRetry;

  const TaskCard({
    super.key,
    required this.task,
    required this.isSelected,
    required this.onTap,
    required this.onPause,
    required this.onResume,
    required this.onDelete,
    required this.onRetry,
  });

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppStyles.animationDurationShort,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _controller, curve: AppStyles.animationCurve),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = ColorHelper.getStatusColor(widget.task.phase);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _controller.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _controller.reverse();
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: GestureDetector(
              onTap: widget.onTap,
              child: AnimatedContainer(
                duration: AppStyles.animationDurationMedium,
                padding: const EdgeInsets.all(AppStyles.paddingXLarge),
                decoration: BoxDecoration(
                  gradient: widget.isSelected
                      ? LinearGradient(
                          colors: [
                            AppColors.primary.withValues(alpha: 0.2),
                            AppColors.primaryDark.withValues(alpha: 0.1),
                          ],
                        )
                      : null,
                  color: widget.isSelected
                      ? null
                      : (isDark ? AppColors.surface : AppColors.lightSurface),
                  borderRadius: BorderRadius.circular(
                    AppStyles.borderRadiusLarge,
                  ),
                  border: Border.all(
                    color: widget.isSelected
                        ? AppColors.primary.withValues(alpha: 0.5)
                        : _isHovered
                        ? (isDark
                              ? AppColors.white.withValues(alpha: 0.2)
                              : AppColors.lightDivider)
                        : (isDark
                              ? AppColors.white.withValues(alpha: 0.05)
                              : AppColors.lightDivider),
                    width: widget.isSelected
                        ? AppStyles.borderWidthMedium
                        : AppStyles.borderWidthThin,
                  ),
                  boxShadow: _isHovered
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            blurRadius: AppStyles.blurRadiusMedium,
                            offset: const Offset(
                              0,
                              AppStyles.shadowOffsetMedium,
                            ),
                          ),
                        ]
                      : null,
                ),
                child: Column(
                  children: [
                    _buildHeader(statusColor, isDark),
                    const SizedBox(height: AppStyles.spacingLarge),
                    _buildProgressSection(statusColor, isDark),
                    const SizedBox(height: AppStyles.spacingLarge),
                    _buildFooter(statusColor, isDark),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(Color statusColor, bool isDark) {
    return Row(
      children: [
        _buildFileIcon(statusColor),
        const SizedBox(width: AppStyles.spacingLarge),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.task.name,
                style: TextStyle(
                  color: isDark ? AppColors.white : AppColors.lightText,
                  fontSize: AppStyles.fontSizeLarge,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  _buildStatusBadge(statusColor),
                  const SizedBox(width: 8),
                  if (widget.task.category.name.isNotEmpty)
                    _buildCategoryBadge(isDark),
                ],
              ),
            ],
          ),
        ),
        _buildActionButtons(statusColor),
      ],
    );
  }

  Widget _buildFileIcon(Color statusColor) {
    final iconData = IconHelper.getFileIcon(widget.task.name);

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppStyles.borderRadiusMedium),
      ),
      child: Icon(iconData, color: statusColor, size: AppStyles.iconSizeLarge),
    );
  }

  Widget _buildStatusBadge(Color statusColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: ColorHelper.getStatusBackgroundColor(widget.task.phase),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: ColorHelper.getStatusBorderColor(widget.task.phase),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.task.phase == TaskPhase.TpDownRunning)
            SizedBox(
              width: 12,
              height: 12,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation(statusColor),
              ),
            )
          else
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: statusColor,
                shape: BoxShape.circle,
              ),
            ),
          const SizedBox(width: 6),
          Text(
            widget.task.phase.label,
            style: TextStyle(
              color: statusColor,
              fontSize: AppStyles.fontSizeSmall,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryBadge(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.white.withValues(alpha: 0.05)
            : AppColors.lightSurfaceLight,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        widget.task.category.name,
        style: TextStyle(
          color: isDark ? AppColors.white50 : AppColors.lightTextSecondary,
          fontSize: AppStyles.fontSizeSmall,
        ),
      ),
    );
  }

  Widget _buildActionButtons(Color statusColor) {
    return Row(
      children: [
        if (widget.task.phase == TaskPhase.TpDownRunning)
          _buildIconButton(
            icon: Icons.pause_rounded,
            color: AppColors.warning,
            onPressed: widget.onPause,
            tooltip: 'Pause',
          ),
        if (widget.task.phase == TaskPhase.TpDownPaused)
          _buildIconButton(
            icon: Icons.play_arrow_rounded,
            color: AppColors.info,
            onPressed: widget.onResume,
            tooltip: 'Resume',
          ),
        if (widget.task.phase == TaskPhase.TpDownFailed)
          _buildIconButton(
            icon: Icons.refresh_rounded,
            color: AppColors.primary,
            onPressed: widget.onRetry,
            tooltip: 'Retry',
          ),
        const SizedBox(width: 8),
        _buildIconButton(
          icon: Icons.delete_outline_rounded,
          color: AppColors.error,
          onPressed: widget.onDelete,
          tooltip: 'Delete',
        ),
      ],
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressSection(Color statusColor, bool isDark) {
    final progress = widget.task.downloadStats.progress;
    final total = widget.task.size;

    return Column(
      children: [
        LinearProgressIndicator(
          minHeight: 8,
          borderRadius: BorderRadius.circular(6),
          value: progress.toDouble() / total.toDouble(),
          backgroundColor: isDark
            ? AppColors.white.withValues(alpha: 0.1)
            : AppColors.lightDivider,
          valueColor: widget.task.phase == TaskPhase.TpDownRunning ? AlwaysStoppedAnimation(AppColors.info): AlwaysStoppedAnimation(statusColor),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              FormatHelper.formatProgress(
                progress.toDouble(),
                total.toDouble(),
              ),
              style: TextStyle(
                color: statusColor,
                fontSize: AppStyles.fontSizeMedium,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '${FormatHelper.formatSize(progress.toInt())} / ${FormatHelper.formatSize(total.toInt())}',
              style: TextStyle(
                color: isDark
                    ? AppColors.white50
                    : AppColors.lightTextSecondary,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFooter(Color statusColor, bool isDark) {
    return Row(
      children: [
        if (widget.task.phase == TaskPhase.TpDownRunning) ...[
          Icon(
            Icons.speed_rounded,
            color: isDark ? AppColors.white40 : AppColors.lightTextSecondary,
            size: AppStyles.iconSizeSmall,
          ),
          const SizedBox(width: 6),
          Text(
            '${FormatHelper.formatSpeed(widget.task.downloadStats.speed.toDouble())}/s',
            style: TextStyle(
              color: isDark ? AppColors.white60 : AppColors.lightTextSecondary,
              fontSize: 13,
            ),
          ),
          const SizedBox(width: 16),
          Icon(
            Icons.timer_outlined,
            color: isDark ? AppColors.white40 : AppColors.lightTextSecondary,
            size: AppStyles.iconSizeSmall,
          ),
          const SizedBox(width: 6),
          Text(
            FormatHelper.formatDuration(
              widget.task.downloadStats.speed == 0 ? Duration.zero :
                Duration(seconds: ((widget.task.size.toDouble() - widget.task.downloadStats.progress.toDouble()) / widget.task.downloadStats.speed.toDouble()).toInt()),
            ),
            style: TextStyle(
              color: isDark ? AppColors.white60 : AppColors.lightTextSecondary,
              fontSize: 13,
            ),
          ),
        ],
        const Spacer(),
        Icon(
          Icons.access_time_rounded,
          color: isDark ? AppColors.white30 : AppColors.lightTextSecondary,
          size: 14,
        ),
        const SizedBox(width: 4),
        Text(
          FormatHelper.formatDateTime(
            DateTime.fromMillisecondsSinceEpoch(
              widget.task.createdAt.toInt() * 1000,
            ),
          ),
          style: TextStyle(
            color: isDark ? AppColors.white40 : AppColors.lightTextSecondary,
            fontSize: AppStyles.fontSizeSmall,
          ),
        ),
      ],
    );
  }
}
