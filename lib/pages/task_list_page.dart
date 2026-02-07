import 'package:flutter/material.dart';
import 'package:mdm/constants/colors.dart';
import 'package:mdm/constants/styles.dart';
import 'package:mdm/providers/task_provider.dart';
import 'package:mdm/widgets/overview_panel.dart';
import 'package:mdm/widgets/task_list_panel.dart';
import 'package:provider/provider.dart';

class TaskListPage extends StatefulWidget {
  const TaskListPage({super.key});

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskProvider>().initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Row(
        children: [
          SizedBox(width: AppStyles.panelWidth, child: const OverviewPanel()),
          Container(width: 1, color: AppColors.white.withValues(alpha: 0.1)),
          const Expanded(child: TaskListPanel()),
        ],
      ),
    );
  }
}
