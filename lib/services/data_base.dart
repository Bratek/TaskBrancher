import 'package:task_brancher/services/app_library.dart';
import 'package:task_brancher/services/hive_service.dart';

class DataBase {
  static HiveService db = HiveService();

  static Future<void> init() async {
    await db.init();
  }

  static void create(Base obj) {
    db.create(obj);
  }

  static void update(Base obj) {
    db.update(obj);
  }

  static void delete(Base obj) {
    db.delete(obj);
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
}
