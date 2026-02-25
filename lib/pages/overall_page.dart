import 'package:flutter/material.dart';
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
      backgroundColor: Color(0xFFF5F7FA),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Expanded(
            flex: 1,
            child: OverviewPanel(),
          ),
          Container(
            width: 1,
            color: Color(0xFFF0F2F5),
          ),
          const Expanded(
            flex: 5,
            child: TaskListPanel(),
          ),
        ],
      ),
    );
  }
}
