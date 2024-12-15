import 'package:hive_flutter/hive_flutter.dart';
import 'package:task_brancher/models/base.dart';
import 'package:task_brancher/models/project.dart';
import 'package:task_brancher/models/settings.dart';
import 'package:task_brancher/models/task.dart';
import 'package:task_brancher/models/status.dart';
import 'package:task_brancher/services/global.dart' as global;

class HiveService {
  
  // ################################################################## Внешние методы
  //Инициализация
  Future<void> init() async {
    
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

  //Создать объект
  void create(Base model) {
    _createObject(model);
  }

  //Обновить объект
  void update(Base model) {
    _updateObject(model);
  }

  //Удалить объект
  void delete(Base model) {
    _deleteObject(model);
  }

  //Получить список проектов
  List<Project> getProjectsList() {
    return _getProjectsList();
  }

  //Получить список задач
  List<Task> getTasksList(Base parent) {
    return _getTasksList(parent);
  }

  //Получить объект по id
  Base? getObjectById(String id) {
    var task = _getTaskById(id);
    if (task != null) return task;
    return _getProjectById(id)!;
  }

// ################################################################## CRUD

//Добавить новый элемент в коробку -------------------------------------------------
  void _createObject(Base model) {
    //Добавляем новую запись в коробку
    _putObject(model);

    if (model is Task) {
      //Добавляем записи о новой задаче в объект родителя
      addChildToParent(model);

      //Добавим запись в канбан
      addToKanban(model);
    }
  }

  //Обновить элемент в коробке -------------------------------------------------
  void _updateObject(Base model) {
    //Обновляем запись в коробке
    _putObject(model);
  }

//Удалить запись по объекту в коробке -------------------------------------------------
  void _deleteObject(Base? model) {
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

      //Удаляем запись о задаче из списка родителя
      deleteChildFromParent(model);

      //Удаляем записи из коробки задач по списку
      deleteChildrenByList(childrenList);

      //Удаляем запись из коробки
      _deleteTaskById(model.id);
    }
  }

// ################################################################## Box

  //Очистить все коробки -------------------------------------------------
  void clearAllBox() {
    clearBox("Project");
    clearBox("Task");
    clearBox("Kanban");
  }

  void clearBox(String boxName) {
    //Очистка бокса
    _clearBoxByName(boxName);
  }

//Очистить коробку по имени -------------------------------------------------
  void _clearBoxByName(String boxName) {
    Hive.box(boxName).clear();
  }

// ################################################################## Child

  //Добавляем поздадачу в родительский объект -------------------------------------------------
  void addChildToParent(Base child) {
    //Получаем объект родителя из коробки по id
    var parent = getObjectById(child.parentId);
    if (parent == null) return;

    //Добавляем запись о дочернем элементе в объект родителя
    //parrent.addChild(child);
    parent.children.add(child.id);

    //Помещаем объект родителя в коробку
    _putObject(parent);
  }

  //Удалить дочерний элемент из списка дочерних элементов родителя
  void deleteChildFromParent(Base child) {
    //Получаем объект родителя из коробки по id
    var parrent = getObjectById(child.parentId);
    if (parrent == null) return;

    //Удаляем запись о дочернем элементе из списка children родителя
    parrent.deleteChild(child);

    //Сохраним объект родителя в коробку
    _putObject(parrent);

    //Добавим запись в канбан
    if (parrent is Task && parrent.getChildrenCount() == 0) {
      addToKanban(parrent);
    }
  }

//Получить иерархический список всех подзадач
  List<Task> getAllChildren(Base model) {
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

  //Удаление задач по списку
  void deleteChildrenByList(List<Task> list) {
    for (var element in list) {
      _deleteTaskById(element.id);
    }
  }

// ################################################################## Project

  //Получить объект проекта по id
  Project? _getProjectById(String id) {
    var box = Hive.box("Project");
    var json = box.get(id);
    return json == null ? null : Project.fromJson(json);
  }

  //Получить список проектов
  List<Project> _getProjectsList() {
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
  void _putObject(Base? model) {
    if (model == null) return;

    var box = Hive.box(model.getType());
    box.put(model.id, model.toJson());
  }

  //Удалить проект по id из коробки
  void _deleteProjectById(String id) {
    var box = Hive.box("Project");
    box.delete(id);
  }

//Получить список для канбан
  List<Task> getKanbanList(Project project) {
    return _getKanbanList(project.id);
  }

// ################################################################## Task

  //Получить список подзадач
  List<Task> _getTasksList(Base parent) {
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
  Task? _getTaskById(String? id) {
    if (id == null) return null;

    var box = Hive.box("Task");
    var json = box.get(id);

    return json == null ? null : Task.fromJson(json);
  }

  //Удалить задачу по id из коробки
  void _deleteTaskById(String id) {
    var box = Hive.box("Task");
    box.delete(id);
  }

// ################################################################## Kanban

  //Обновим записи в канбане
  void addToKanban(Base? model) {
    if (model == null) return;

    //1. добавим текущую задачу в канбан
    addTaskToKanban(model);

    //2. удалим родителя из канбана
    _deleteTaskFromKanbanById(model.projectId, model.parentId);
  }

  //Добавить новую задачу в канбан
  void addTaskToKanban(Base model) {
    addTaskToKanbanById(model.projectId, model.id);
  }

  //Добавить новую задачу в канбан по id
  void addTaskToKanbanById(String projectId, String id) {
    var box = Hive.box("Kanban");
    List<String> values = box.get(projectId) ?? [];
    values.add(id);
    box.put(projectId, values);
  }

//Удалить задачи по списку из канбана
  void deleteFromKanbanByList(List<Task> list) {
    for (var element in list) {
      _deleteTaskFromKanbanById(element.projectId, element.id);
    }
  }

//Удалить проект из канбана по id
  void _deleteProjectFromKanbanById(String projectId) {
    var box = Hive.box("Kanban");
    box.delete(projectId);
  }

//Удалить задачу из канбан по id
  void _deleteTaskFromKanbanById(String projectId, String taskId) {
    if (projectId == taskId) return;

    var box = Hive.box("Kanban");
    List<String> values = box.get(projectId) ?? [];
    values.remove(taskId);
    box.put(projectId, values);
  }

//Получить список задач канбана по id
  List<Task> _getKanbanList(String projectId) {
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
  void saveSettings(Settings settings) {
    var box = Hive.box("Settings");
    box.put("Settings", settings.toJson());
  }

  //###############################################################################################
}
