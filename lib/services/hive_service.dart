//import 'package:hive/hive.dart';
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

  static Project? getProject(String id) {
    var box = Hive.box("Project");
    var json = box.get(id);
    return json == null ? null : Project.fromJson(json);
  }

  static Task? getTask(String? id) {
    if (id == null) return null;

    var box = Hive.box("Task");
    var json = box.get(id);

    return json == null ? null : Task.fromJson(json);
  }

  static Base getObjectById(String id) {
    var task = getTask(id);
    if (task != null) return task;
    return getProject(id)!;
  }

  static List<Project> getAllProjects() {
    var box = Hive.box("Project");
    List<dynamic> values = box.values.toList();
    List<Project> list = [];
    for (var element in values) {
      var project = getProject(element['id']);
      if (project == null) continue;
      list.add(project);
    }
    return list;
  }

  static void update(Base? model) {
    if (model == null) return;

    var box = Hive.box(model.runtimeType.toString());
    box.put(model.id, model.tojson());
  }

  static void delete(Base? model) {
    if (model == null) return;

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
  static List<Task> getChildren(String? parentId) {
    var box = Hive.box("Children");
    List<Task> children = [];
    if (parentId == null) return children;

    List<String> values = box.get(parentId) ?? [];

    for (var element in values) {
      var task = getTask(element);
      if (task == null) continue;
      children.add(task);
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
    //если нет дочерних элементов удаляем запись по родителю
    if (values.isEmpty) {
      box.delete(parentId);
    }
  }

  static int getChildrenCount(String parentId) {
    var box = Hive.box("Children");
    List<String> values = box.get(parentId) ?? [];
    return values.length;
  }

  static List<Task> getTasksForKanban() {
    var box = Hive.box("Children");
    List<dynamic> keys = box.keys.toList();
    List<dynamic> values = box.values.toList();
    List<Task> list = [];

    for (int i = 0; i < keys.length; i++) {
      if (values[i].length == 0) {
        var task = getTask(keys[i]);
        if (task == null) continue;
        list.add(task);
      }
    }
    return list;
  }
}
