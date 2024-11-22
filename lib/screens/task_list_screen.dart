import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:task_brancher/services/app_library.dart';
import 'package:task_brancher/services/global.dart' as global;

class TasksListScreen extends StatefulWidget {
  final Project project;

  const TasksListScreen({super.key, required this.project});

  @override
  State<TasksListScreen> createState() => _TasksListScreenState();
}

class _TasksListScreenState extends State<TasksListScreen> {
  Base? parent;

  @override
  void initState() {
    super.initState();
    parent = widget.project;
  }

  @override
  Widget build(BuildContext context) {
    List<Task> tasks = HiveService.getChildren(parent!.id);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) => goBackScreen(context),
      child: Scaffold(
        // ignore: prefer_const_constructors
        backgroundColor: AppTheme.appColor('Background'),
        appBar: AppBar(
          backgroundColor: AppTheme.appColor('Background'),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              goBackScreen(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
          ),
          title: const Text(
            "Подзадачи",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.normal,
                color: Colors.black),
          ),
        ),
        // опция для выталкивания клавиатурой bottomSheet виджета
        resizeToAvoidBottomInset: true,
        // плавающая кнопка добавления проекта
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppTheme.appColor('Accent2'),
          elevation: 0,
          shape: const CircleBorder(),
          onPressed: () async {
            var newTask = Task(
                parentId: parent!.id,
                title: "",
                description: "",
                number: "${parent!.number}.${(tasks.length + 1).toString()}");
            // Показать форму для добавления задачи
            final result = await taskEditForm(context, newTask);
            if (result) {
              HiveService.create(newTask);
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
                  icon: Icon(
                    Icons.home,
                    color: AppTheme.appColor('IconColor'),
                    size: 24,
                  ),
                  onPressed: () {
                    //Navigator.pop(context);
                    navigateToScreen(context, '/home');
                  }),
              const SizedBox(width: 24),
              IconButton(
                icon: Image.asset(
                  'assets/images/kanban.png',
                  width: 24,
                  height: 24,
                  color: AppTheme.appColor('IconColor'),
                ),
                onPressed: () {
                  if (global.currentProject != null) {
                    navigateToScreen(context, '/kanban');
                    // Navigator.of(context)
                    //     .pushNamed('/kanban', arguments: widget.project);
                  }
                },
              ),
            ],
          ),
        ),

        body: Column(
          children: [
            Container(
              color: AppTheme.appColor('Accent2'),
              height: 3,
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
              child: Text(
                "${parent!.number}. ${parent!.title}",
                textAlign: TextAlign.start,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
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
                          //tasks.removeAt(index);
                          HiveService.delete(tasks[index]);
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
                                await taskEditForm(context, tasks[index]);
                            if (result) {
                              //Сохранить изменения
                              HiveService.update(tasks[index]);
                              // Обновить список
                              setState(() {});
                            }
                          },
                        ),
                      ],
                    ),
                    child: GestureDetector(
                      child: TaskCard(task: tasks[index]),
                      onTap: () {
                        // Переход к вложенному списку задач
                        parent = tasks[index];
                        setState(() {});

                        //Navigator.of(context).pushNamed('/tasks', arguments: tasks[index]);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void navigateToScreen(BuildContext context, String routeName) {
    Navigator.of(context).popUntil((route) {
      if (route.isFirst) {
        if (route.settings.name != routeName) {
          Navigator.of(context).pushNamed(routeName, arguments: widget.project);
        }
        return true;
      }
      return route.settings.name ==
          routeName; // Удаляем все маршруты, не соответствующие заданному имени
    });
  }

  void goBackScreen(BuildContext context) {
    if (parent!.parentId == "") {
      navigateToScreen(context, '/');
    } else {
      parent = HiveService.getObjectById(
          parent!.parentId); //HiveService.getTask(parent!.parentId);
      setState(() {});
    }
  }

  Future<bool> taskEditForm(BuildContext context, Task task) async {
    //контроллеры для ввода c установленными начальными значениями
    final titleController = TextEditingController(text: task.title);
    final descriptionController = TextEditingController(text: task.description);
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
                  controller: titleController,
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
                          task.title = titleController.text;
                          task.description = descriptionController.text;
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
