import 'package:flutter/material.dart';
import 'package:mdm/constants/colors.dart';
import 'package:mdm/providers/task_provider.dart';
import 'package:mdm/widgets/overview_panel.dart';
import 'package:mdm/widgets/task_list_panel.dart';
import 'package:provider/provider.dart';

class OverallPage extends StatefulWidget {
  const OverallPage({super.key});

  @override
  State<OverallPage> createState() => _OverallPageState();
}

class _OverallPageState extends State<OverallPage> {
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
      backgroundColor: AppColors.lightBackground,
      body: Row(
        children: [
          SizedBox(width: 320.0, child: const OverviewPanel()),
          Container(
            width: 1,
            color: AppColors.lightDivider,
          ),
          const Expanded(child: TaskListPanel()),
        ],
      ),
    );
  }
}
