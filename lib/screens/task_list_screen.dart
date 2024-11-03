import 'package:flutter/material.dart';

class TasksListScreen extends StatefulWidget {
  const TasksListScreen(
      {super.key, required this.parentId, required this.title});

  final String parentId;
  final String title;

  @override
  State<TasksListScreen> createState() => _TasksListScreenState();
}

class _TasksListScreenState extends State<TasksListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF0EDED),
      body: Center(
        child: Text(
          'Задачи для проекта ${widget.title}',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
      ),
    );
  }
}
