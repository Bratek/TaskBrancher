import 'package:hive/hive.dart';

part 'task.g.dart';

@HiveType(typeId: 1)
class Task {
  @HiveField(0)
  late String id;
  @HiveField(1)
  String title;
  @HiveField(2)
  String description;
  @HiveField(3)
  late Status status;
  @HiveField(4)
  String parentId;

  Task(
      {required this.title,
      required this.description,
      required this.parentId}) {
    id = DateTime.now().millisecondsSinceEpoch.toString();
    status = Status.none;
  }
}

@HiveType(typeId: 2)
enum Status {
  @HiveField(0)
  none,
  @HiveField(1)
  inprogress,
  @HiveField(2)
  completed,
  @HiveField(3)
  calceled
}
