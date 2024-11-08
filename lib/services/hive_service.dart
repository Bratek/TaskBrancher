import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:task_brancher/models/base.dart';
import 'package:task_brancher/models/project.dart';
import 'package:task_brancher/models/task.dart';

class HiveService {
  static init() async {
    //Инициализация Hive
    await Hive.initFlutter();

    //Открытие боксов
    await Hive.openBox("Project");
    await Hive.openBox("Task");
    await Hive.openBox("Children");
  }

  static create(Base model) {
    var box = Hive.box(model.runtimeType.toString());
    //Добавление записи в бокс
    box.put(model.id, model.tojson());
    //Добавляем записи о дочерних элементах
    if (model.parentId != "") {
      addChild(model.parentId, model.id);
    }
  }

  static Project getProject(String id) {
    var box = Hive.box("Project");
    var json = box.get(id);
    return Project.fromJson(json);
  }

  static Task getTask(String id) {
    var box = Hive.box("Task");
    var json = box.get(id);
    return Task.fromJson(json);
  }

  static List<Project> getAllProjects() {
    var box = Hive.box("Project");
    List<dynamic> values = box.values.toList();
    List<Project> list = [];
    for (var element in values) {
      list.add(getProject(element['id']));
    }
    return list;
  }

  static void update(Base model) {
    var box = Hive.box(model.runtimeType.toString());
    box.put(model.id, model.tojson());
  }

  static void delete(Base model) {
    var box = Hive.box(model.runtimeType.toString());
    box.delete(model.id);
    //Удаляем записи о дочерних элементах
    if (model.parentId != "") {
      deleteChild(model.parentId, model.id);
    }
  }

  static void deleteAll(String boxName) {
    //Очистка бокса
    Hive.box(boxName).clear();
  }

//Children_box
  static List<Task> getChildren(String parentId) {
    var box = Hive.box("Children");
    List<String> values = box.get(parentId) ?? [];
    List<Task> children = [];

    for (var element in values) {
      children.add(getTask(element));
    }
    return children;
  }

  static addChild(String parentId, String childId) {
    var box = Hive.box("Children");
    List<String> values = box.get(parentId) ?? [];
    values.add(childId);
    box.put(parentId, values);
  }

  static deleteChild(String parentId, String childId) {
    var box = Hive.box("Children");
    List<String> values = box.get(parentId) ?? [];
    values.remove(childId);
    box.put(parentId, values);
  }
}
