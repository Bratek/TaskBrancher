//import 'package:hive/hive.dart';
import 'package:task_brancher/models/basic.dart';

//part 'project.g.dart';

// @HiveType(typeId: 0)
// class Project extends Basic{
//   @HiveField(0)
//   String id = "";
//   @HiveField(1)
//   String name = "";
//   @HiveField(2)
//   String description = "";

//   Project({required this.name, required this.description}) {
//     id = DateTime.now().millisecondsSinceEpoch.toString();
//   }

// }

class Project extends Basic {
  String number = "";

  Project(
      {required super.title,
      required super.description,
      required super.parentId,
      this.number = ""});
}
