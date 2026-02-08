import 'package:flutter/material.dart';
import 'package:mdm/constants/colors.dart';
import 'package:mdm/constants/styles.dart';

class AddTaskData{
  String taskName;
  String link;

  AddTaskData(this.link, {this.taskName=""});
}

class AddTaskDialog extends StatelessWidget {
  final void Function(AddTaskData data)? action;

  const AddTaskDialog({super.key, this.action});

  @override
  Widget build(BuildContext context) {
    final taskNameCtl = TextEditingController();
    final linkCtl = TextEditingController();

    return AlertDialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppStyles.borderRadiusXLarge),
      ),
      title: const Text(
        "添加新任务",
        style: TextStyle(color: AppColors.white),
      ),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: linkCtl,
              style: const TextStyle(color: AppColors.white),
              decoration: InputDecoration(
                labelText: '下载链接',
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
              controller: taskNameCtl,
              style: const TextStyle(color: AppColors.white),
              decoration: InputDecoration(
                labelText: '任务名（可选）',
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
            '取消',
            style: TextStyle(color: AppColors.white60),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            if (linkCtl.text.isEmpty) {
              return;
            }
            final data = AddTaskData(linkCtl.text, taskName: taskNameCtl.text);
            Navigator.pop(context);
            action?.call(data);
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
          child: const Text('下载'),
        ),
      ],
    );
  }
}