import 'package:flutter/material.dart';
import 'package:task_brancher/widgets/project_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Список проектов"),
      ),
      body: ListView(
        children: [
          ProjectCard(
              name: "Первый проект",
              description:
                  "Описание первого проекта. Описание первого проекта. Описание первого проекта. Описание первого проекта. Описание первого проекта. "),
          ProjectCard(
              name: "Второй проект",
              description:
                  "Описание второго проекта. Описание второго проекта. Описание второго проекта. Описание второго проекта. Описание второго проекта. "),
          ProjectCard(
              name: "Третий проект",
              description:
                  "Описание третьего проекта. Описание третьего проекта. Описание третьего проекта. Описание третьего проекта. Описание третьего проекта. "),
          ProjectCard(
              name: "Четверный проект",
              description:
                  "Описание четверного проекта. Описание четвертого проекта. Описание четвертого проекта. Описание четвертого проекта. Описание четвертого проекта. "),
          ProjectCard(
              name: "Первый проект",
              description:
                  "Описание первого проекта. Описание первого проекта. Описание первого проекта. Описание первого проекта. Описание первого проекта. "),
          ProjectCard(
              name: "Второй проект",
              description:
                  "Описание второго проекта. Описание второго проекта. Описание второго проекта. Описание второго проекта. Описание второго проекта. "),
          ProjectCard(
              name: "Третий проект",
              description:
                  "Описание третьего проекта. Описание третьего проекта. Описание третьего проекта. Описание третьего проекта. Описание третьего проекта. "),
          ProjectCard(
              name: "Четверный проект",
              description:
                  "Описание четверного проекта. Описание четвертого проекта. Описание четвертого проекта. Описание четвертого проекта. Описание четвертого проекта. "),
        ],
      ),
    );
  }
}