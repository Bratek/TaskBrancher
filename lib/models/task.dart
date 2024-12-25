import 'package:task_brancher/models/base.dart';
import 'package:task_brancher/models/status.dart';

class Task extends Base {
  Task(
      {required super.projectId,
      required super.parentId,
      required super.title,
      required super.description,
      required super.number,
      required super.children,
      super.id,
      super.status = Status.none});

  factory Task.fromJson(Map<dynamic, dynamic> json) {
    return Task(
        id: json['id'],
        projectId: json['projectId'],
        parentId: json['parentId'],
        title: json['title'],
        description: json['description'],
        number: json['number'],
        children: json['children'],
        status: Status.values.byName(json['status'] ?? 'none'));
  }

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'projectId': projectId,
        'parentId': parentId,
        'title': title,
        'description': description,
        'number': number,
        'children': children,
        'status': status.name,
      };
}
