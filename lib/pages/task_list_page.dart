import 'package:flutter/material.dart';
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
      backgroundColor: const Color(0xFF0F0F23),
      body: Row(
        children: [
          // 左侧概览面板
          const SizedBox(
            width: 320,
            child: OverviewPanel(),
          ),
          // 分割线
          Container(
            width: 1,
            color: Colors.white.withValues(alpha: 0.1),
          ),
          // 右侧任务列表
          const Expanded(
            child: TaskListPanel(),
          ),
        ],
      ),
    );
  }
}