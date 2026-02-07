import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mdm/providers/task_provider.dart';
import 'package:mdm/pages/task_list_page.dart';
import 'package:mdm/theme/app_theme.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TaskProvider(),
      child: MaterialApp(
        title: 'Download Manager',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const TaskListPage(),
      ),
    );
  }
}
