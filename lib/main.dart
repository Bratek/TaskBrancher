import 'package:flutter/material.dart';
import 'package:task_brancher/services/app_library.dart';

void main() async {
  //Ожидание инициализации дерева Flutter
  WidgetsFlutterBinding.ensureInitialized();

  //Инициализация Hive
  await DataBase.init();

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
        //Project project;
        if (settings.arguments == null) {}
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (context) => const HomeScreen());
          case '/tasks':
            Base project = settings.arguments as Base;
            return MaterialPageRoute(builder: (context) => TasksListScreen(parent: project));
          case '/kanban':
            Project project = settings.arguments as Project;
            return MaterialPageRoute(builder: (context) => KanbanScreen(project: project));
          case '/settings':
            return MaterialPageRoute(builder: (context) => const SettingsScreen());
          default:
            return MaterialPageRoute(builder: (context) => const HomeScreen());
        }
      },
      home: const HomeScreen(),
    );
  }
}
