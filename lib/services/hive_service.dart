import 'package:hive_flutter/hive_flutter.dart';
import 'package:task_brancher/models/base.dart';
import 'package:task_brancher/models/project.dart';
import 'package:task_brancher/models/settings.dart';
import 'package:task_brancher/models/task.dart';
import 'package:task_brancher/models/status.dart';
import 'package:task_brancher/services/global.dart' as global;

class HiveService {
  static init() async {
    //Инициализация Hive
    await Hive.initFlutter();

    //Открытие боксов
    await Hive.openBox("Project"); //key: ProjectId, value: json
    await Hive.openBox("Task"); //key: TaskId, value: json
    await Hive.openBox("Kanban"); //key: ProjectId, value: List<TaskId>
    await Hive.openBox("Settings");

    //Получение сохраненых настроек
    global.appSettings = getSettings();
  }

// ################################################################## CRUD

//Добавить новый элемент в коробку -------------------------------------------------
  static void createObject(Base model) {
    //Добавляем новую запись в коробку
    _putObject(model);

    if (model is Task) {
      //Добавляем записи о новой задаче в объект родителя
      addChildToParent(model);

      //Добавим запись в канбан
      addToKanban(model);
    }
  }

  //Получить объект по id
  static Base? getObjectById(String id) {
    var task = _getTaskById(id);
    if (task != null) return task;
    return _getProjectById(id)!;
  }

  //Обновить элемент в коробке -------------------------------------------------
  static void updateObject(Base model) {
    //Обновляем запись в коробке
    _putObject(model);
  }

//Удалить запись по объекту в коробке -------------------------------------------------
  static void deleteObject(Base? model) {
    if (model == null) return;

    if (model is Project) {
      //удаляем запись из канбана
      _deleteProjectFromKanbanById(model.id);

      //Удаляем все дочерние элементы
      List<Task> childrenList = getAllChildren(model);
      deleteChildrenByList(childrenList);

      //Удаляем запись из коробки
      _deleteProjectById(model.id);
    } else {
      //model is Task

      //Получаем список дочерних задач
      List<Task> childrenList = getAllChildren(model);

      //Удаляем записи из канбана по списку
      deleteFromKanbanByList(childrenList);

      //Удаляем записи из коробки задач по списку
      deleteChildrenByList(childrenList);

      //Удаляем запись из коробки
      _deleteTaskById(model.id);
    }
  }

// ################################################################## Box

  //Очистить все коробки -------------------------------------------------
  static void clearAllBox() {
    clearBox("Project");
    clearBox("Task");
    clearBox("Kanban");
  }

  static void clearBox(String boxName) {
    //Очистка бокса
    _clearBoxByName(boxName);
  }

//Очистить коробку по имени -------------------------------------------------
  static void _clearBoxByName(String boxName) {
    Hive.box(boxName).clear();
  }

// ################################################################## Child

  //Добавляем поздадачу в родительский объект -------------------------------------------------
  static void addChildToParent(Base child) {
    //Получаем объект родителя из коробки по id
    var parent = getObjectById(child.parentId);
    if (parent == null) return;

    //Добавляем запись о дочернем элементе в объект родителя
    //parrent.addChild(child);
    parent.children.add(child.id);

    //Помещаем объект родителя в коробку
    _putObject(parent);
  }

  static void deleteChildFromParent(Base child) {
    //Получаем объект родителя из коробки по id
    var parrent = getObjectById(child.parentId);
    if (parrent == null) return;

    //Удаляем запись о дочернем элементе в объект родителя
    parrent.deleteChild(child);

    //Помещаем объект родителя в коробку
    _putObject(parrent);

    //Добавим запись в канбан
    if (parrent is Task && parrent.getChildrenCount() == 0) {
      addToKanban(parrent);
    }
  }

//Получить иерархический список всех подзадач
  static List<Task> getAllChildren(Base model) {
    List<Task> list = [];
    if (model is Task) list.add(model);
    if (model.children.isEmpty) return list;

    for (var element in model.children) {
      var task = _getTaskById(element);
      if (task != null) {
        list.addAll(getAllChildren(task));
      }
    }

    return list;
  }

  static void deleteChildrenByList(List<Task> list) {
    for (var element in list) {
      _deleteTaskById(element.id);
    }
  }

// ################################################################## Project

  //Получить список проектов
  static List<Project> getProjectsList() {
    return _getProjectsList();
  }

  //Получить объект проекта по id
  static Project? _getProjectById(String id) {
    var box = Hive.box("Project");
    var json = box.get(id);
    return json == null ? null : Project.fromJson(json);
  }

  //Получить список проектов
  static List<Project> _getProjectsList() {
    List<Project> list = [];
    var box = Hive.box("Project");
    var projects = box.values.toList();

    if (projects.isEmpty) return list;

    for (var element in projects) {
      list.add(Project.fromJson(element));
    }

    return list;
  }

  //Создать/Обновить запись по объекту в коробке
  static void _putObject(Base? model) {
    if (model == null) return;

    var box = Hive.box(model.getType());
    box.put(model.id, model.toJson());
  }

  //Удалить проект по id из коробки
  static void _deleteProjectById(String id) {
    var box = Hive.box("Project");
    box.delete(id);
  }

// ################################################################## Task

  //Получить список подзадач
  static List<Task> getTasksList(Base parent) {
    var parrent = getObjectById(parent.id);
    List<Task> list = [];

    for (String element in parrent!.children) {
      var task = _getTaskById(element);
      if (task != null) {
        list.add(task);
      }
    }

    return list;
  }

//Получить объект задачи по id
  static Task? _getTaskById(String? id) {
    if (id == null) return null;

    var box = Hive.box("Task");
    var json = box.get(id);

    return json == null ? null : Task.fromJson(json);
  }

  //Удалить задачу по id из коробки
  static void _deleteTaskById(String id) {
    var box = Hive.box("Task");
    box.delete(id);
  }

// ################################################################## Kanban

  //Обновим записи в канбане
  static void addToKanban(Base? model) {
    if (model == null) return;

    //1. добавим текущую задачу в канбан
    addTaskToKanban(model);

    //2. удалим родителя из канбана
    _deleteTaskFromKanbanById(model.projectId, model.parentId);
  }

  //Добавить новую задачу в канбан
  static void addTaskToKanban(Base model) {
    addTaskToKanbanById(model.projectId, model.id);
  }

  //Добавить новую задачу в канбан по id
  static void addTaskToKanbanById(String projectId, String id) {
    var box = Hive.box("Kanban");
    List<String> values = box.get(projectId) ?? [];
    values.add(id);
    box.put(projectId, values);
  }

  static List<Task> getKanbanList(Project project) {
    return _getKanbanList(project.id);
  }

//Удалить задачи по списку из канбана
  static void deleteFromKanbanByList(List<Task> list) {
    for (var element in list) {
      _deleteTaskFromKanbanById(element.projectId, element.id);
    }
  }

//Удалить проект из канбана по id
  static void _deleteProjectFromKanbanById(String projectId) {
    var box = Hive.box("Kanban");
    box.delete(projectId);
  }

//Удалить задачу из канбан по id
  static void _deleteTaskFromKanbanById(String projectId, String taskId) {
    if (projectId == taskId) return;

    var box = Hive.box("Kanban");
    List<String> values = box.get(projectId) ?? [];
    values.remove(taskId);
    box.put(projectId, values);
  }

//Получить список задач канбана по id
  static List<Task> _getKanbanList(String projectId) {
    var box = Hive.box("Kanban");
    var kanban = box.get(projectId) ?? [];

    List<Task> list = [];
    for (var element in kanban) {
      var task = _getTaskById(element);
      if (task != null) {
        list.add(task);
      }
    }

    return list;
  }

  // ################################################################## Settings
  //Получить настройки
  static Settings getSettings() {
    var box = Hive.box("Settings");
    var json = box.get("Settings");
    return json == null
        ? Settings(kanbanColumnList: [
            Status.none,
            Status.inprogress,
            Status.verify,
            Status.completed,
            Status.calceled,
            Status.hidden
          ])
        : Settings.fromJson(json);
  }

  //Сохранить настройки
  static void saveSettings(Settings settings) {
    var box = Hive.box("Settings");
    box.put("Settings", settings.toJson());
  }

  //###############################################################################################
}
