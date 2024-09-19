import 'package:flutter/material.dart';
import 'package:kpi_drive_kanban/presentation/di/injector.dart';
import 'package:kpi_drive_kanban/presentation/screens/catalog_screen/view/kanban_screen.dart';

void main() {
  initInjector();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.black,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const KanbanScreen(),
    );
  }
}
