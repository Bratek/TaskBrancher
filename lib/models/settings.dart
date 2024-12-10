
import 'package:task_brancher/models/status.dart';

class Settings {
  List<Status> kanbanColumnList = [];

  Settings({required this.kanbanColumnList});

  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(kanbanColumnList: json['kanbanColumnList']);
  }

  Map<String, dynamic> toJson() {
    return {
      'kanbanColumnList': kanbanColumnList,
    };
  }
}