import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mdm/providers/task_provider.dart';
import 'package:mdm/providers/theme_provider.dart';
import 'package:mdm/pages/task_list_page.dart';
import 'package:mdm/theme/app_theme.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'Download Manager',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            home: const TaskListPage(),
          );
        },
      ),
    );
  }
}
