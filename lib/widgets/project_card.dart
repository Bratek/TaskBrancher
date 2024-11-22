import 'package:flutter/material.dart';
import 'package:task_brancher/services/app_library.dart';

class ProjectCard extends StatelessWidget {
  final Project project;
  final bool inFocus;

  const ProjectCard({super.key, required this.project, this.inFocus = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
      padding: const EdgeInsets.all(10),
      height: 120,
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: inFocus
              ? AppTheme.appColor('SelectedCard')
              : AppTheme.appColor('Background'),
          border: Border.all(color: AppTheme.appColor('Srtoke'), width: 1)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          height: 22,
          padding: const EdgeInsets.only(left: 5, right: 5),
          child: Text("${project.number}. ${project.title}",
              style: AppTheme.appTextStyle('Title')),
        ),
        Divider(
          thickness: 1,
          color: AppTheme.appColor('Accent'),
          indent: 5,
          endIndent: 5,
        ),
        Container(
          height: 58,
          padding: const EdgeInsets.only(left: 5, right: 5),
          child: Text(project.description,
              softWrap: true,
              maxLines: 3,
              style: AppTheme.appTextStyle('Description')),
        ),
      ]),
    );
  }
}
