import 'package:flutter/material.dart';

import 'package:task_brancher/models/task.dart';

class TaskCard extends StatelessWidget {
  Task task;

  TaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
      padding: const EdgeInsets.all(10),
      height: 120,
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: Colors.white,
          border: Border.all(color: const Color(0xFFD9D9D9), width: 1)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          height: 22,
          padding: const EdgeInsets.only(left: 5, right: 5),
          child: Text(task.title,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
        ),
        const Divider(thickness: 1, color: Color(0xFF9D9D9D)),
        Container(
          height: 58,
          padding: const EdgeInsets.only(left: 5, right: 5),
          child: Text(task.description,
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
