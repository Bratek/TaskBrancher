import 'package:task_brancher/models/base.dart';

class Project extends Base {
  bool visible = true;

  Project(
      {super.id,
      required super.projectId,
      required super.parentId,
      required super.title,
      required super.description,
      required super.number,
      required super.children,
      this.visible = true});

  @override
  factory Project.fromJson(Map<dynamic, dynamic> json) => Project(
      id: json['id'],
      projectId: json['projectId'],
      parentId: json['parentId'],
      title: json['title'],
      description: json['description'],
      number: json['number'],
      visible: json['visible'],
      children: json['children']);

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'projectId': projectId,
        'parentId': parentId,
        'title': title,
        'description': description,
        'number': number,
        'visible': visible,
        'children': children
      };
}
