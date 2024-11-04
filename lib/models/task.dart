//import 'package:hive/hive.dart';
import 'package:task_brancher/models/basic.dart';

//part 'task.g.dart';

// @HiveType(typeId: 1)
// class Task {
//   @HiveField(0)
//   late String id;
//   @HiveField(1)
//   String title;
//   @HiveField(2)
//   String description;
//   @HiveField(3)
//   late Status status;
//   @HiveField(4)
//   String parentId;

//   Task(
//       {required this.title,
//       required this.description,
//       required this.parentId}) {
//     id = DateTime.now().millisecondsSinceEpoch.toString();
//     status = Status.none;
//   }
// }

// @HiveType(typeId: 2)
// enum Status {
//   @HiveField(0)
//   none,
//   @HiveField(1)
//   inprogress,
//   @HiveField(2)
//   completed,
//   @HiveField(3)
//   calceled
// }

class Task extends Basic {
  String number = "";
  Status status;

  Task(
      {required super.title,
      required super.description,
      required super.parentId,
      this.number = "",
      this.status = Status.none});
}

enum Status { none, inprogress, completed, calceled }
