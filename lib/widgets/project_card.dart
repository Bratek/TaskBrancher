import 'package:flutter/material.dart';

import 'package:task_brancher/models/project.dart';

class ProjectCard extends StatelessWidget {
  final Project project;
  bool inFocus = false;

  ProjectCard({super.key, required this.project, this.inFocus = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
      padding: const EdgeInsets.all(10),
      height: 120,
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: inFocus ? Colors.white : Color(0xFFF0EDED),
          border: Border.all(color: const Color(0xFFD9D9D9), width: 1)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          height: 22,
          padding: const EdgeInsets.only(left: 5, right: 5),
          child: Text("${project.number}. ${project.title}",
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
        ),
        const Divider(thickness: 1, color: Color(0xFF9D9D9D)),
        Container(
          height: 58,
          padding: const EdgeInsets.only(left: 5, right: 5),
          child: Text(project.description,
              softWrap: true,
              maxLines: 3,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: Colors.black)),
        ),
      ]),
    );
  }
}
