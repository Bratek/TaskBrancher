import 'package:flutter/material.dart';
import 'package:task_brancher/services/app_library.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //Инициализация Hive
  await HiveService.init();

  //Запуск приложения
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (context) => const HomeScreen());
          case '/tasks':
            Project project = settings.arguments as Project;
            return MaterialPageRoute(
                builder: (context) => TasksListScreen(project: project));
          case '/kanban':
            Project project = settings.arguments as Project;
            return MaterialPageRoute(
                builder: (context) => KanbanScreen(project: project));
          default:
            return MaterialPageRoute(builder: (context) => const HomeScreen());
        }
      },
      home: const HomeScreen(),
    );
  }
}
