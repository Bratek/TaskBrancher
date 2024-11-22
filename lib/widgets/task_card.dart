import 'package:flutter/material.dart';
import 'package:task_brancher/services/app_library.dart';

class TaskCard extends StatelessWidget {
  final Task task;

  const TaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
      padding: const EdgeInsets.all(10),
      //height: 250,
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: AppTheme.appColor('SelectedCard'),
          border: Border.all(color: AppTheme.appColor('Srtoke'), width: 1)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          height: 22,
          padding: const EdgeInsets.only(left: 5, right: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(task.number, style: AppTheme.appTextStyle('Title')),
              Text(task.getStatusName().toUpperCase(),
                  style: AppTheme.statusTextStyle(task.status)),
            ],
          ),
        ),
        Divider(
            thickness: 1,
            color: AppTheme.appColor('Accent2'),
            indent: 5,
            endIndent: 5),
        Container(
          height: 100,
          padding: const EdgeInsets.only(left: 5, right: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(task.title, style: AppTheme.appTextStyle('Title')),
              const SizedBox(height: 5),
              Text(task.description,
                  softWrap: true,
                  maxLines: 3,
                  style: AppTheme.appTextStyle('Description')),
            ],
          ),
        ),
      ]),
    );
  }
}
