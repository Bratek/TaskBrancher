import 'package:hive/hive.dart';

part 'project.g.dart';

@HiveType(typeId: 0)
class Project {
  @HiveField(0)
  String id = "";
  @HiveField(1)
  String name = "";
  @HiveField(2)
  String description = "";


  Project({required this.name, required this.description}) {
    id = DateTime.now().millisecondsSinceEpoch.toString();
  }

}
