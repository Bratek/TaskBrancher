import 'package:task_brancher/services/app_library.dart';
import 'package:task_brancher/services/hive_service.dart';

enum CRUD { create, read, update, delete, none }

class DataBase {
  static HiveService db = HiveService();

  static Future<void> init() async {
    await db.init();
  }

  static void create(Base obj) {
    db.create(obj);
  }

  static Base? read(String id) {
    return db.getObjectById(id);
  }

  static void update(Base obj) {
    db.update(obj);
  }

  static void delete(Base obj) {
    db.delete(obj);
  }

  static void executeMetod(Base model, CRUD metod) {
    switch (metod) {
      case CRUD.create:
        create(model);
        break;
      case CRUD.read:
        read(model.id);
        break;
      case CRUD.update:
        update(model);
        break;
      case CRUD.delete:
        delete(model);
        break;
      case CRUD.none:
        break;
    }
  }

  static List<Project> getProjectsList() {
    return db.getProjectsList();
  }

  static List<Task> getTasksList(Base parent) {
    return db.getTasksList(parent);
  }

  static List<Task> getKanbanList(Project project) {
    return db.getKanbanList(project);
  }

  static Base? getObjectById(String id) {
    return db.getObjectById(id);
  }

  static Settings getSettings() {
    return db.getSettings();
  }

  static void saveSettings(Settings settings) {
    db.saveSettings(settings);
  }
}
