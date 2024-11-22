import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:task_brancher/services/app_library.dart';
import 'package:task_brancher/services/global.dart' as global;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    List<Project> projects = HiveService.getAllProjects();

    return Scaffold(
      backgroundColor: AppTheme.appColor('Background'),
      appBar: AppBar(
        backgroundColor: AppTheme.appColor('Background'),
        centerTitle: true,
        title: Text(
          "Список проектов",
          style: AppTheme.appTextStyle('AppBar'),
        ),
      ),
      // опция для выталкивания клавиатурой bottomSheet виджета
      resizeToAvoidBottomInset: true,
      // плавающая кнопка добавления проекта
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.appColor('Accent'),
        elevation: 0,
        shape: const CircleBorder(),
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
        child: const Icon(
          Icons.add,
          size: 24,
          color: Colors.white,
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 64,
        elevation: 0,
        shape: const CircularNotchedRectangle(),
        color: AppTheme.appColor('Background2'),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Image.asset(
                'assets/images/kanban.png',
                width: 26,
                height: 22,
                color: AppTheme.appColor('IconColor'),
              ),
              onPressed: () {
                if (global.currentProject != null) {
                  Navigator.of(context)
                      .pushNamed('/kanban', arguments: global.currentProject);
                }
              },
            ),
            const SizedBox(width: 24),
            IconButton(
              icon: Image.asset(
                'assets/images/tasks.png',
                width: 24,
                height: 24,
                color: AppTheme.appColor('IconColor'),
              ),
              onPressed: () {
                if (global.currentProject != null) {
                  Navigator.of(context)
                      .pushNamed('/tasks', arguments: global.currentProject);
                }
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            height: 3,
            color: AppTheme.appColor('Accent'),
          ),
          //Отступ
          const SizedBox(height: 10),
          //Список проектов
          Expanded(
            child: ListView.builder(
              //shrinkWrap: true,
              itemCount: projects.length,
              itemBuilder: (context, index) {
                return Slidable(
                  key: ValueKey(index),
                  startActionPane:
                      ActionPane(motion: const BehindMotion(), children: [
                    SlidableAction(
                      // An action can be bigger than the others.
                      backgroundColor: AppTheme.appColor('DeleteColor'),
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
                        backgroundColor: AppTheme.appColor('EditColor'),
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
                        inFocus: projects[index].equals(global.currentProject)),
                    onTap: () {
                      if (!projects[index].equals(global.currentProject)) {
                        global.currentProject = projects[index];
                        setState(() {});
                      } else {
                        // Открыть окно вложенных задач
                        Navigator.of(context)
                            .pushNamed('/tasks', arguments: projects[index]);
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) =>
                        //             TasksListScreen(parent: projects[index])));
                      }
                    },
                  ),
                );
              },
            ),
          ),
        ],
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
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 18,
                          ),
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
