import 'package:flutter/material.dart';
import 'package:mdm/constants/colors.dart';
import 'package:mdm/constants/styles.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;
  final bool isLoading;
  final bool isOutlined;
  final double? width;
  final double? height;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.icon,
    this.isLoading = false,
    this.isOutlined = false,
    this.width,
    this.height,
  });

  factory AppButton.primary({
    required String text,
    VoidCallback? onPressed,
    IconData? icon,
    bool isLoading = false,
    double? width,
  }) {
    return AppButton(
      text: text,
      onPressed: onPressed,
      backgroundColor: AppColors.primary,
      textColor: AppColors.white,
      icon: icon,
      isLoading: isLoading,
      width: width,
    );
  }

  factory AppButton.danger({
    required String text,
    VoidCallback? onPressed,
    IconData? icon,
    bool isLoading = false,
    double? width,
  }) {
    return AppButton(
      text: text,
      onPressed: onPressed,
      backgroundColor: AppColors.error,
      textColor: AppColors.white,
      icon: icon,
      isLoading: isLoading,
      width: width,
    );
  }

  factory AppButton.outlined({
    required String text,
    VoidCallback? onPressed,
    Color? color,
    IconData? icon,
    double? width,
  }) {
    return AppButton(
      text: text,
      onPressed: onPressed,
      backgroundColor: Colors.transparent,
      textColor: color ?? AppColors.white70,
      icon: icon,
      isOutlined: true,
      width: width,
    );
  }

  @override
  Widget build(BuildContext context) {
    final effectiveBackgroundColor = backgroundColor ?? AppColors.primary;
    final effectiveTextColor = textColor ?? AppColors.white;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isLoading ? null : onPressed,
        borderRadius: BorderRadius.circular(AppStyles.borderRadiusMedium),
        child: Container(
          width: width,
          height: height ?? AppStyles.buttonHeight,
          padding: const EdgeInsets.symmetric(
            horizontal: AppStyles.paddingLarge,
          ),
          decoration: BoxDecoration(
            gradient: isOutlined
                ? null
                : LinearGradient(
                    colors: [
                      effectiveBackgroundColor,
                      effectiveBackgroundColor.withValues(alpha: 0.8),
                    ],
                  ),
            color: isOutlined ? Colors.transparent : null,
            borderRadius: BorderRadius.circular(AppStyles.borderRadiusMedium),
            border: isOutlined
                ? Border.all(color: effectiveTextColor.withValues(alpha: 0.3))
                : null,
            boxShadow: isOutlined
                ? null
                : [
                    BoxShadow(
                      color: effectiveBackgroundColor.withValues(alpha: 0.4),
                      blurRadius: AppStyles.blurRadiusSmall,
                      offset: const Offset(0, AppStyles.shadowOffsetSmall),
                    ),
                  ],
          ),
          child: Center(
            child: isLoading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(effectiveTextColor),
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (icon != null) ...[
                        Icon(icon, color: effectiveTextColor, size: 20),
                        const SizedBox(width: AppStyles.spacingSmall),
                      ],
                      Text(
                        text,
                        style: TextStyle(
                          color: effectiveTextColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
