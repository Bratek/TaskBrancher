import 'package:task_brancher/models/status.dart';

class Settings {
  List<Status> kanbanStatusList = [];
  List<Status> taskStatusList = [];

  Settings({required this.kanbanStatusList, required this.taskStatusList});

  factory Settings.fromJson(Map<dynamic, dynamic> json) {
    final jsonKanbanStatusList = json['kanbanStatusList'] as List;
    final jsonTaskStatusList = json['taskStatusList'] as List;

    return Settings(
      kanbanStatusList:
          List.generate(jsonKanbanStatusList.length, (index) => Status.values.byName(jsonKanbanStatusList[index])),
      taskStatusList:
          List.generate(jsonTaskStatusList.length, (index) => Status.values.byName(jsonTaskStatusList[index])),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'kanbanStatusList': List.generate(kanbanStatusList.length, (index) => kanbanStatusList[index].name),
      'taskStatusList': List.generate(taskStatusList.length, (index) => taskStatusList[index].name),
    };
  }
}
