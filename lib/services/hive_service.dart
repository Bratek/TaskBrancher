
// import 'package:hive/hive.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:task_brancher/models/project.dart';
// import 'package:task_brancher/models/task.dart';

// class HiveService {
//   static init() async {
    

//     //Инициализация Hive
//     await Hive.initFlutter();
    
//     //Регистрация адаптеров
//     Hive.registerAdapter(ProjectAdapter());
//     Hive.registerAdapter(TaskAdapter());

//     //Открытие боксов
//     await Hive.openBox<Project>("projects_box");
//     await Hive.openBox<Task>("tasks_box");
//   }

//    //Добавить проект
//   static addProject(Project project) {
//     var box = Hive.box<Project>("projects_box");
//     box.add(project);
//   }

//   static getProjectList() {
//     var box = Hive.box<Project>("projects_box");
//     return box.values.toList();
//   }

// }
