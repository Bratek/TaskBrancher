import 'package:task_brancher/models/base.dart';

class Project extends Base {
  bool visible = true;

  Project(
      {required super.title,
      required super.description,
      required super.parentId,
      required super.number,
      super.id,
      this.visible = true});

  @override
  factory Project.fromJson(Map<dynamic, dynamic> json) => Project(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      parentId: json['parentId'],
      number: json['number'],
      visible: json['visible']);

  @override
  Map<String, dynamic> tojson() => {
        'id': id,
        'title': title,
        'description': description,
        'parentId': parentId,
        'number': number,
        'visible': visible,
      };
}
