import 'package:task_brancher/models/base.dart';

enum Status { none, inprogress, completed, calceled }

class Task extends Base {
  Status status;
  bool visible = true;

  Task(
      {required super.title,
      required super.description,
      required super.parentId,
      required super.number,
      super.id,
      this.status = Status.none,
      this.visible = true});

  @override
  factory Task.fromJson(Map<dynamic, dynamic> json) {
    return Task(
        id: json['id'],
        parentId: json['parentId'],
        title: json['title'],
        description: json['description'],
        number: json['number'],
        status: Status.values.byName(json['status']),
        visible: json['visible']);
  }

  @override
  Map<String, dynamic> tojson() => {
        'id': id,
        'title': title,
        'description': description,
        'parentId': parentId,
        'number': number,
        'status': status.name,
        'visible': visible,
      };
}
