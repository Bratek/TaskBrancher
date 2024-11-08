import 'package:flutter/material.dart';
import 'package:task_brancher/screens/home_screen.dart';
import 'package:task_brancher/services/hive_service.dart';

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
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
