import 'package:flutter/material.dart';
import 'package:mdm/constants/colors.dart';
import 'package:mdm/constants/styles.dart';

class AppProgressIndicator extends StatelessWidget {
  final double value;
  final Color? backgroundColor;
  final Color? valueColor;
  final double? height;
  final double? borderRadius;
  final bool showLabel;
  final String? label;

  const AppProgressIndicator({
    super.key,
    required this.value,
    this.backgroundColor,
    this.valueColor,
    this.height,
    this.borderRadius,
    this.showLabel = false,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBackgroundColor =
        backgroundColor ?? AppColors.white.withValues(alpha: 0.1);
    final effectiveValueColor = valueColor ?? AppColors.info;
    final effectiveHeight = height ?? AppStyles.progressHeightMedium;
    final effectiveBorderRadius = borderRadius ?? AppStyles.borderRadiusSmall;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(effectiveBorderRadius),
          child: LinearProgressIndicator(
            value: value.clamp(0.0, 1.0),
            backgroundColor: effectiveBackgroundColor,
            valueColor: AlwaysStoppedAnimation(effectiveValueColor),
            minHeight: effectiveHeight,
          ),
        ),
        if (showLabel && label != null) ...[
          const SizedBox(height: AppStyles.spacingSmall),
          Text(
            label!,
            style: TextStyle(
              color: AppColors.white54,
              fontSize: AppStyles.fontSizeSmall,
            ),
          ),
        ],
      ],
    );
  }
}
