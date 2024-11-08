import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:page_transition/page_transition.dart';
import 'package:task_brancher/screens/task_list_screen.dart';
import 'package:task_brancher/services/hive_service.dart';
import 'package:task_brancher/widgets/project_card.dart';
//import 'package:task_brancher/widgets/project_edit_form.dart';

import '../models/project.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomeScreen> {
  int? currentProject;

  @override
  Widget build(BuildContext context) {
    List<Project> projects = HiveService.getAllProjects();

    return Scaffold(
      backgroundColor: const Color(0xFFF0EDED),
      appBar: AppBar(
        title: const Text(
          "Список проектов",
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      // опция для выталкивания клавиатурой bottomSheet виджета
      resizeToAvoidBottomInset: true,
      // плавающая кнопка добавления проекта
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF45D900),
        onPressed: () async {
          var newProject = Project(
              title: "",
              description: "",
              parentId: "",
              number: (projects.length + 1).toString());
          // Показать форму для добавления проекта
          final result = await projectEditForm(context, newProject);
          if (result) {
            // Добавить проект
            HiveService.create(newProject);
            setState(() {});
          }
        },
        child: const Icon(Icons.add),
      ),

      body: ListView.builder(
        itemCount: projects.length,
        itemBuilder: (context, index) {
          return Slidable(
            key: ValueKey(index),
            startActionPane:
                ActionPane(motion: const BehindMotion(), children: [
              SlidableAction(
                // An action can be bigger than the others.
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                icon: Icons.delete,
                label: 'Удалить',
                onPressed: (context) {
                  // Удалить проект
                  projects.removeAt(index);
                  //Обновить список
                  setState(() {});
                },
              ),
            ]),
            endActionPane: ActionPane(
              motion: const BehindMotion(),
              children: [
                SlidableAction(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  icon: Icons.edit,
                  label: 'Изменить',
                  onPressed: (context) async {
                    final result =
                        await projectEditForm(context, projects[index]);
                    if (result) {
                      // Сохранить изменения
                      //HiveService.addProject(result);
                      HiveService.update(projects[index]);
                      // Обновить список
                      setState(() {});
                    }
                  },
                ),
              ],
            ),
            child: GestureDetector(
              child: ProjectCard(
                  project: projects[index],
                  inFocus: currentProject == index ? true : false),
              onTap: () {
                if (currentProject != index) {
                  currentProject = index;
                  setState(() {});
                } else {
                  // Открыть окно вложенных задач
                  Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.rightToLeft,
                        child: TasksListScreen(parent: projects[index]),
                      ));
                }
                // MaterialPageRoute(
                //     builder: (context) =>
                //         TasksListScreen(parent: projects[index])));
              },
            ),
          );
        },
      ),
    );
  }

  Future<bool> projectEditForm(BuildContext context, Project project) async {
    //контроллеры для ввода c установленными начальными значениями
    final nameController = TextEditingController(text: project.title);
    final descriptionController =
        TextEditingController(text: project.description);
    bool result = false;

    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        //отрисовываем виджеты формы
        return Container(
          height: 300,
          margin: EdgeInsets.only(
              bottom: MediaQuery.of(context)
                  .viewInsets
                  .bottom), // нижний отступ для отталкивания от клавиатуры
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  //autofocus: true,
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Заголовок',
                  ),
                ),

                const SizedBox(height: 10),

                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Описание',
                  ),
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 3,
                  //maxLengthEnforcement: MaxLengthEnforcement.enforced,
                ),
                const SizedBox(height: 10),

                //кнопки
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        child: const Text(
                          'Отмена',
                          style: TextStyle(color: Colors.grey, fontSize: 18),
                        ),
                        onPressed: () async {
                          result = false;
                          // закрыть форму
                          Navigator.pop(context);
                        },
                      ),
                      TextButton(
                        child: const Text(
                          'Сохранить',
                          style: TextStyle(color: Colors.green, fontSize: 18),
                        ),
                        onPressed: () {
                          // Сохранить изменения
                          project.title = nameController.text;
                          project.description = descriptionController.text;
                          result = true;
                          // закрыть форму
                          Navigator.pop(context);
                        },
                      ),
                    ]),
              ],
            ),
          ),
        );
      },
    );

    return result;
  }
}
